import 'package:expire_check/screens/training/controllers/training_controller.dart';
import 'package:expire_check/screens/training/widgets/add_edit_dialoge.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class TrainingCard extends StatelessWidget {
  final String documentId;
  final Map<String, dynamic> training;

  TrainingCard({super.key, required this.documentId, required this.training});
  final TrainingController controller = Get.find<TrainingController>();

  @override
  Widget build(BuildContext context) {
    final code = training['code'] ?? 'Unknown';
    final date = training['date'] != null
        ? DateFormat('yyyy-MM-dd').parse(training['date'])
        : DateTime.now();
    final formattedDate = DateFormat('yyyy-MM-dd').format(date);

    final avatarText = code.isNotEmpty ? code[0] : 'U';

    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.black.withOpacity(0.25),
            blurRadius: 5,
            spreadRadius: 2,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
        child: Row(
          children: [
            Expanded(
              // ✅ Left content ko flexible banaya
              child: Row(
                children: [
                  // Gradient Circle Avatar
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          // ignore: deprecated_member_use
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 6,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: CircleAvatar(
                      radius: 26,
                      backgroundColor: Colors.transparent,
                      child: Text(
                        avatarText,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    // ✅ Text ko bhi flexible banaya
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          code,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1, // ✅ Ek line me rakha
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 6),
                        Text(
                          'Date: $formattedDate',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min, // ✅ Buttons apne width tak simit
              children: [
                IconButton(
                  icon: Icon(Icons.edit, color: Color(0xFF6A11CB)),
                  onPressed: () {
                    Get.dialog(
                      AddTrainingDialog(
                        documentId: documentId,
                        initialData: {'code': code, 'date': formattedDate},
                        onSubmit: (data) async {
                          await controller.updateTraining(documentId, data);
                        },
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.black),
                  onPressed: () {
                    Get.defaultDialog(
                      title: '',
                      backgroundColor: Colors.transparent,
                      contentPadding: EdgeInsets.zero,
                      content: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(20),
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
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Confirm Delete',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Are you sure you want to delete this training?',
                              textAlign: TextAlign.center,
                              style: TextStyle(
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
                                    side: BorderSide(color: Colors.white70),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: Text(
                                    'Cancel',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () async {
                                    Get.back();
                                    try {
                                      await controller.deleteTraining(
                                        documentId,
                                        training['code'],
                                      );
                                      Get.snackbar(
                                        'Success',
                                        'Training deleted',
                                        backgroundColor: Colors.grey,
                                        colorText: Colors.black87,
                                        snackPosition: SnackPosition.BOTTOM,
                                        margin: EdgeInsets.all(12),
                                        borderRadius: 10,
                                        duration: Duration(seconds: 2),
                                      );
                                    } catch (e) {
                                      Get.snackbar(
                                        'Error',
                                        'Failed to delete training: $e',
                                        backgroundColor: Colors.grey,
                                        colorText: Colors.black87,
                                        snackPosition: SnackPosition.BOTTOM,
                                        margin: EdgeInsets.all(12),
                                        borderRadius: 10,
                                        duration: Duration(seconds: 2),
                                      );
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: Color(0xFF6A11CB),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: Text('Delete'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
