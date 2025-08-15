import 'package:expire_check/screens/dashboard/widgets/analytics_widget.dart';
import 'package:expire_check/screens/profile/controller/notifiction_controller.dart';
import 'package:expire_check/screens/training/controllers/training_controller.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AlertController extends GetxController {
  final TrainingController trainingController = Get.find<TrainingController>();

  RxList<Map<String, dynamic>> expiredAlerts = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> soonExpireAlerts = <Map<String, dynamic>>[].obs;

  // Analytics ke liye chart data
  RxList<ChartData> monthlyChartData = <ChartData>[].obs;
  RxList<ChartData> dailyChartData = <ChartData>[].obs;

  get isLoading => null;

  @override
  void onInit() {
    super.onInit();

    ever<List<Map<String, dynamic>>>(trainingController.trainings, (trainings) {
      _updateAlerts(trainings);
      _updateAnalytics(trainings); // monthly & daily analytics
    });

    _updateAlerts(trainingController.trainings);
    _updateAnalytics(trainingController.trainings);
  }

  /// Expired / Soon to Expire check + Notification trigger
  void _updateAlerts(List<Map<String, dynamic>> trainings) {
    final now = DateTime.now();
    final soon = now.add(const Duration(days: 7));

    expiredAlerts.value = trainings.where((training) {
      final date = _getDate(training['date']);
      return date != null && date.isBefore(now);
    }).toList();

    soonExpireAlerts.value = trainings.where((training) {
      final date = _getDate(training['date']);
      return date != null && date.isAfter(now) && date.isBefore(soon);
    }).toList();

    // Push notification trigger
    if (expiredAlerts.isNotEmpty) {
      final notificationController = Get.find<NotificationController>();
      notificationController.sendPushNotification(
        "Training Expired",
        "${expiredAlerts.length} training(s) have expired.",
      );
    }
  }

  /// Monthly + Daily analytics
  void _updateAnalytics(List<Map<String, dynamic>> trainings) {
    final now = DateTime.now();

    // === MONTHLY ===
    final Map<String, int> monthCount = {};
    for (int i = 0; i < 6; i++) {
      final monthDate = DateTime(now.year, now.month - i, 1);
      final monthName = DateFormat('MMM').format(monthDate);
      monthCount[monthName] = 0;
    }

    for (var training in trainings) {
      final expiry = _getDate(training['date']);
      if (expiry != null &&
          expiry.isBefore(now) &&
          expiry.isAfter(DateTime(now.year, now.month - 5, 1))) {
        final monthName = DateFormat('MMM').format(expiry);
        if (monthCount.containsKey(monthName)) {
          monthCount[monthName] = (monthCount[monthName] ?? 0) + 1;
        }
      }
    }

    monthlyChartData.value = monthCount.entries
        .toList()
        .reversed
        .map((e) => ChartData(e.key, e.value.toDouble()))
        .toList();

    // === DAILY ===
    final Map<String, int> dayCount = {};
    for (int i = 29; i >= 0; i--) {
      final dayDate = now.subtract(Duration(days: i));
      final dayLabel = DateFormat('dd MMM').format(dayDate);
      dayCount[dayLabel] = 0;
    }

    for (var training in trainings) {
      final expiry = _getDate(training['date']);
      if (expiry != null &&
          expiry.isBefore(now) &&
          expiry.isAfter(now.subtract(const Duration(days: 30)))) {
        final dayLabel = DateFormat('dd MMM').format(expiry);
        if (dayCount.containsKey(dayLabel)) {
          dayCount[dayLabel] = (dayCount[dayLabel] ?? 0) + 1;
        }
      }
    }

    dailyChartData.value = dayCount.entries
        .map((e) => ChartData(e.key, e.value.toDouble()))
        .toList();
  }

  DateTime? _getDate(dynamic dateValue) {
    if (dateValue == null) return null;
    if (dateValue is DateTime) return dateValue;
    if (dateValue is String) return DateTime.tryParse(dateValue);
    return null;
  }
}
