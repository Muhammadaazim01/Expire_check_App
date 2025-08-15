import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class EmployeesController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  RxList<Map<String, dynamic>> employees = <Map<String, dynamic>>[].obs;
  RxString searchQuery = ''.obs;
  RxBool isLoading = true.obs;

  List<Map<String, dynamic>> get filteredEmployees {
    if (searchQuery.value.isEmpty) return employees;
    return employees.where((emp) {
      final fullName = emp['fullName']?.toLowerCase() ?? '';
      return fullName.contains(searchQuery.value.toLowerCase()) ||
          (emp['jobTitle']?.toLowerCase() ?? '').contains(
            searchQuery.value.toLowerCase(),
          );
    }).toList();
  }

  @override
  void onInit() {
    super.onInit();
    fetchEmployees();
  }

  void fetchEmployees() {
    isLoading.value = true;
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
            isLoading.value = false;
            Get.snackbar('Error', 'Failed to fetch employees: $error');
          },
        );
  }

  Future<void> addEmployee(
    String fullName,
    String jobTitle,
    DateTime expiryDate, // yahan expiryDate hona chahiye
    List<Map<String, String>> trainings,
  ) async {
    await _firestore.collection('employees').add({
      'fullName': fullName,
      'jobTitle': jobTitle,
      'expiryDate': Timestamp.fromDate(
        expiryDate,
      ), // hiredDate ki jagah expiryDate
      'trainings': trainings,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> updateEmployee(
    String documentId,
    Map<String, dynamic> data,
  ) async {
    await _firestore.collection('employees').doc(documentId).update({
      'fullName': data['fullName'],
      'jobTitle': data['jobTitle'],
      'expiryDate': Timestamp.fromDate(
        data['expiryDate'],
      ), // hiredDate ki jagah expiryDate
      'trainings': data['trainings'],
    });
  }
}
