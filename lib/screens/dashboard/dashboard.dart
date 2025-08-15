import 'package:expire_check/screens/alerts/controller/contoller.dart';
import 'package:expire_check/screens/dashboard/dashboard_controller/controller.dart';
import 'package:expire_check/screens/dashboard/widgets/analytics_widget.dart';
import 'package:expire_check/screens/dashboard/widgets/header.dart';
import 'package:expire_check/screens/dashboard/widgets/over_view_card.dart';
import 'package:expire_check/screens/dashboard/widgets/status.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final DashboardController controller = Get.find<DashboardController>();
  final AlertController alertController = Get.find<AlertController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        return Column(
          children: [
            // ✅ Fixed Header (no scroll)
            DashboardHeader(
              title: "Dashboard",
              subtitle: "Manage Trainings & Employees",
            ),

            // ✅ Scrollable content from "Overview"
            Expanded(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.all(7.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Overview title
                      Row(
                        children: [
                          SizedBox(width: 10),
                          Text(
                            "Overview",
                            style: GoogleFonts.montserrat(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),

                      // Overview Cards Grid
                      GridView.count(
                        crossAxisCount: 2,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        childAspectRatio: 1.2,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                        children: [
                          OverviewCard(
                            icon: Icons.people,
                            color: Colors.blue[100]!,
                            iconColor: Colors.blue[700]!,
                            number: controller.totalEmployees.toString(),
                            label: 'Total Employees',
                          ),
                          OverviewCard(
                            icon: Icons.school,
                            color: Colors.purple[100]!,
                            iconColor: Colors.purple[700]!,
                            number: controller.totalTrainings.toString(),
                            label: 'Total Trainings',
                          ),
                          OverviewCard(
                            icon: Icons.warning_amber,
                            color: Colors.orange[100]!,
                            iconColor: Colors.orange[700]!,
                            number: alertController.soonExpireAlerts.length
                                .toString(),
                            label: 'Expiring Soon',
                          ),
                          OverviewCard(
                            icon: Icons.error_outline,
                            color: Colors.red[100]!,
                            iconColor: Colors.red[700]!,
                            number: alertController.expiredAlerts.length
                                .toString(),
                            label: 'Expired',
                          ),
                        ],
                      ),

                      SizedBox(height: 10),
                      Obx(
                        () => TrainingStatusWidget(
                          expiringSoon:
                              alertController.soonExpireAlerts.length.obs,
                          expired: alertController.expiredAlerts.length.obs,
                        ),
                      ),

                      SizedBox(height: 20),
                      Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Row(
                          children: [
                            Text(
                              "Analytics",
                              style: GoogleFonts.montserrat(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Row(
                          children: [
                            Text(
                              "Training Expiry Trends (Last 6 Months)",
                              style: GoogleFonts.montserrat(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),

                      Obx(() {
                        final monthly = alertController.monthlyChartData
                            .toList();
                        final daily = alertController.dailyChartData.toList();

                        return AnalyticsWidget(
                          monthlyData: monthly,
                          dailyData: daily,
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
