import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignOutCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final Future<void> Function() onSignOut;

  const SignOutCard({
    super.key,
    required this.label,
    required this.icon,
    required this.onSignOut,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        // Show blurred loader dialog
        Get.dialog(
          WillPopScope(
            onWillPop: () async => false, // back button disable
            child: Stack(
              children: [
                // Blur background
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                  child: Container(color: Colors.black.withOpacity(0.3)),
                ),
                // Loader
                const Center(child: CircularProgressIndicator()),
              ],
            ),
          ),
          barrierDismissible: false,
        );

        try {
          await onSignOut(); // Call signOut logic
        } catch (e) {
          Get.snackbar(
            "Error",
            e.toString(),
            backgroundColor: Colors.red[600],
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
            margin: const EdgeInsets.all(12),
            borderRadius: 8,
            duration: const Duration(seconds: 2),
          );
        } finally {
          Get.back(); // Close loader dialog
        }
      },
      child: Container(
        constraints: const BoxConstraints(minHeight: 56),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300, width: 1),
        ),
        child: Row(
          children: [
            Icon(icon, size: 24, color: Colors.red),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
