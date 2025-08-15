import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class AlertCard extends StatelessWidget {
  final Map<String, dynamic> alertData;
  final VoidCallback? onDelete;

  const AlertCard({super.key, required this.alertData, this.onDelete});

  void _showDeleteDialog() {
    Get.defaultDialog(
      backgroundColor: Colors.transparent,
      titleStyle: TextStyle(color: Colors.transparent),
      radius: 15,
      barrierDismissible: false,
      content: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min, // 🔹 Dialog height fit content
          children: [
            Icon(Icons.delete_forever, color: Colors.white, size: 50),
            SizedBox(height: 12),
            Text(
              "Are you sure you want to delete this aler",
              textAlign: TextAlign.center,
              style: GoogleFonts.montserrat(
                color: Colors.white70,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                OutlinedButton(
                  onPressed: () => Get.back(),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.white54),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    "Cancel",
                    style: GoogleFonts.montserrat(color: Colors.white),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade600,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    Get.back();
                    if (onDelete != null) {
                      onDelete!();
                      Get.snackbar(
                        "Deleted",
                        "Alert deleted successfully!",
                        backgroundColor: Colors.grey,
                        colorText: Colors.black87,
                        snackPosition: SnackPosition.BOTTOM,
                        margin: EdgeInsets.all(12),
                        borderRadius: 10,
                        duration: Duration(seconds: 2),
                      );
                    }
                  },
                  child: Text("Delete"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final code = alertData['code'] ?? 'Unknown Code';
    final dateRaw = alertData['date'];
    DateTime? date;

    if (dateRaw is DateTime) {
      date = dateRaw;
    } else if (dateRaw is String) {
      date = DateTime.tryParse(dateRaw);
    }

    final formattedDate = date != null
        ? DateFormat('dd MMM yyyy').format(date)
        : 'No Date';

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 2, vertical: 6),
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              // ignore: deprecated_member_use
              color: Colors.black.withOpacity(0.15),
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.red, size: 36),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    code,
                    style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Expiry Date: $formattedDate',
                    style: GoogleFonts.montserrat(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            if (onDelete != null)
              IconButton(
                icon: Icon(Icons.delete, color: Colors.black),
                onPressed: _showDeleteDialog,
              ),
          ],
        ),
      ),
    );
  }
}
