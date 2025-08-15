import 'package:expire_check/screens/alerts/controller/contoller.dart';
import 'package:expire_check/screens/alerts/widgets/card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class AlertScreen extends StatelessWidget {
  final AlertController alertController = Get.find<AlertController>();

  AlertScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Header
          Container(
            height: 150,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            padding: const EdgeInsets.only(top: 70, left: 16, right: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Expire Alerts",
                  style: GoogleFonts.montserrat(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  "Manage alerts record",
                  style: GoogleFonts.montserrat(
                    fontSize: 15,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),

          // Scrollable List
          Expanded(
            child: Obx(() {
              final expired = alertController.expiredAlerts;
              final soon = alertController.soonExpireAlerts;

              if (expired.isEmpty && soon.isEmpty) {
                return const Center(child: Text('No alerts found!'));
              }

              return ListView(
                padding: const EdgeInsets.all(12),
                physics: const BouncingScrollPhysics(), // ✅ iOS-style bounce
                children: [
                  if (expired.isNotEmpty) ...[
                    Text(
                      'Expired Trainings',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...expired.map(
                      (alert) => AlertCard(
                        alertData: alert,
                        onDelete: () {
                          // delete functionality yahan
                        },
                      ),
                    ),
                    const SizedBox(height: 24), // Divider ke jagah spacing
                  ],

                  if (soon.isNotEmpty) ...[
                    Text(
                      'Expiring Soon',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...soon.map((alert) => AlertCard(alertData: alert)),
                  ],
                  const SizedBox(height: 12),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
}
