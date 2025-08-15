import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class TrainingController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  RxList<Map<String, dynamic>> trainings = <Map<String, dynamic>>[].obs;
  RxString searchQuery = ''.obs;
  RxBool isLoading = true.obs;
  StreamSubscription? _trainingsSubscription;

  List<Map<String, dynamic>> get filteredTrainings {
    if (searchQuery.value.isEmpty) return trainings;
    return trainings.where((training) {
      final code = training['code']?.toLowerCase() ?? '';
      return code.contains(searchQuery.value.toLowerCase());
    }).toList();
  }

  @override
  void onInit() {
    super.onInit();
    _fetchTrainings();
  }

  @override
  void onClose() {
    _trainingsSubscription?.cancel();
    super.onClose();
  }

  Future<void> _fetchTrainings() async {
    isLoading.value = true;
    try {
      _trainingsSubscription?.cancel();
      _trainingsSubscription = _firestore
          .collection('trainings')
          .snapshots()
          .listen(
            (snapshot) {
              trainings.value = snapshot.docs
                  .map((doc) => {...doc.data(), 'id': doc.id})
                  .toList();
              isLoading.value = false;
            },
            onError: (error) {
              Get.snackbar(
                'Error',
                'Failed to fetch trainings: $error',
                snackPosition: SnackPosition.BOTTOM,
              );
              isLoading.value = false;
            },
          );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Unexpected error during fetch: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
      isLoading.value = false;
    }
  }

  Future<void> addTraining(String code, String date) async {
    try {
      isLoading.value = true;
      await _firestore.collection('trainings').add({
        'code': code,
        'date': date,
        'createdAt': FieldValue.serverTimestamp(),
      });
      Get.snackbar(
        'Success',
        'Training added',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (error) {
      Get.snackbar(
        'Error',
        'Failed to add training: $error',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateTraining(
    String documentId,
    Map<String, dynamic> data,
  ) async {
    try {
      isLoading.value = true;
      await _firestore.collection('trainings').doc(documentId).update({
        'code': data['code'],
        'date': data['date'],
        'updatedAt': FieldValue.serverTimestamp(),
      });
      Get.snackbar(
        'Success',
        'Training updated',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (error) {
      Get.snackbar(
        'Error',
        'Failed to update training: $error',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteTraining(String documentId, String code) async {
    try {
      isLoading.value = true;
      await _firestore.collection('trainings').doc(documentId).delete();

      // Ab employees ke trainings me se ye code remove karna hoga
      final employeesSnapshot = await _firestore.collection('employees').get();
      for (var doc in employeesSnapshot.docs) {
        final employeeData = doc.data();
        List<dynamic> employeeTrainings = employeeData['trainings'] ?? [];

        // Check karo agar ye training code trainings me hai to remove karo
        bool updated = false;
        employeeTrainings.removeWhere((t) {
          if (t['code'] == code) {
            updated = true;
            return true;
          }
          return false;
        });

        if (updated) {
          await _firestore.collection('employees').doc(doc.id).update({
            'trainings': employeeTrainings,
          });
        }
      }

      Get.snackbar(
        'Success',
        'Training deleted and removed from employees',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (error) {
      Get.snackbar(
        'Error',
        'Failed to delete training: $error',
        snackPosition: SnackPosition.BOTTOM,
      );
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }
}
