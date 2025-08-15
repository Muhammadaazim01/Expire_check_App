import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expire_check/screens/dashboard/widgets/analytics_widget.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class DashboardController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  RxList<Map<String, dynamic>> trainings = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> employees = <Map<String, dynamic>>[].obs;
  RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    _fetchData();
  }

  void _fetchData() {
    isLoading.value = true;

    // Trainings realtime listener
    _firestore
        .collection('trainings')
        .snapshots()
        .listen(
          (snapshot) {
            trainings.value = snapshot.docs
                .map((doc) => {...doc.data(), 'id': doc.id})
                .toList();
          },
          onError: (error) {
            Get.snackbar(
              'Error',
              'Failed to fetch trainings: $error',
              snackPosition: SnackPosition.BOTTOM,
            );
          },
        );

    // Employees realtime listener
    _firestore
        .collection('employees')
        .snapshots()
        .listen(
          (snapshot) {
            employees.value = snapshot.docs
                .map((doc) => {...doc.data(), 'id': doc.id})
                .toList();
            isLoading.value = false;
          },
          onError: (error) {
            Get.snackbar(
              'Error',
              'Failed to fetch employees: $error',
              snackPosition: SnackPosition.BOTTOM,
            );
            isLoading.value = false;
          },
        );
  }

  List<Map<String, dynamic>> get allAssignedTrainings {
    List<Map<String, dynamic>> list = [];
    for (var emp in employees) {
      List<dynamic> empTrainings = emp['trainings'] ?? [];
      for (var t in empTrainings) {
        list.add(t as Map<String, dynamic>);
      }
    }
    return list;
  }

  int get totalEmployees => employees.length;

  int get totalTrainings => trainings.length;

  int get expiringSoon {
    const int expiringRangeDays = 7;
    int count = 0;
    DateTime now = DateTime.now();

    for (var t in allAssignedTrainings) {
      String? dateStr = t['date'] as String?;
      if (dateStr == null) continue;

      DateTime? expiryDate;
      try {
        expiryDate = DateFormat('yyyy-MM-dd').parse(dateStr);
      } catch (_) {
        continue;
      }
      final daysDiff = expiryDate.difference(now).inDays;
      if (daysDiff > 0 && daysDiff <= expiringRangeDays) {
        count++;
      }
    }
    return count;
  }

  int get expired {
    int count = 0;
    DateTime now = DateTime.now();

    for (var t in allAssignedTrainings) {
      String? dateStr = t['date'] as String?;
      if (dateStr == null) continue;

      DateTime? expiryDate;
      try {
        expiryDate = DateFormat('yyyy-MM-dd').parse(dateStr);
      } catch (_) {
        continue;
      }
      final daysDiff = expiryDate.difference(now).inDays;
      if (daysDiff <= 0) {
        count++;
      }
    }
    return count;
  }

  List<ChartData> get analyticsChartData {
    Map<String, int> expiryCounts = {};
    DateTime now = DateTime.now();

    for (int i = 5; i >= 0; i--) {
      DateTime monthDate = DateTime(now.year, now.month - i, 1);
      String month = DateFormat('MMM').format(monthDate);
      expiryCounts[month] = 0;
    }

    for (var t in allAssignedTrainings) {
      String? dateStr = t['date'] as String?;
      if (dateStr == null) continue;

      DateTime? expiryDate;
      try {
        expiryDate = DateFormat('yyyy-MM-dd').parse(dateStr);
      } catch (_) {
        continue;
      }

      String month = DateFormat('MMM').format(expiryDate);
      if (expiryCounts.containsKey(month)) {
        expiryCounts[month] = expiryCounts[month]! + 1;
      }
    }

    return expiryCounts.entries
        .map((e) => ChartData(e.key, e.value.toDouble()))
        .toList();
  }
}
