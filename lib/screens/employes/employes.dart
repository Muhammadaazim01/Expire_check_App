import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expire_check/screens/employes/controllers/controllers.dart';
import 'package:expire_check/screens/employes/widgets/add_dialog.dart';
import 'package:expire_check/screens/employes/widgets/card.dart';
import 'package:expire_check/screens/employes/widgets/edit_dialoge.dart';
import 'package:expire_check/screens/widgets/button.dart';
import 'package:expire_check/screens/widgets/search_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class EmployeesPage extends StatefulWidget {
  const EmployeesPage({super.key});

  @override
  State<EmployeesPage> createState() => _EmployeesPageState();
}

class _EmployeesPageState extends State<EmployeesPage> {
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<EmployeesController>();
    final nameController = TextEditingController();
    final jobController = TextEditingController();

    Future<List<Map<String, String>>> fetchTrainings() async {
      final snapshot = await FirebaseFirestore.instance
          .collection('trainings')
          .get();
      return snapshot.docs
          .map((doc) => {'code': doc['code'] as String})
          .toList();
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Header (fixed)
          Container(
            height: 150,
            width: double.infinity,
            padding: EdgeInsets.only(top: 70, left: 16, bottom: 16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Employees",
                  style: GoogleFonts.montserrat(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  "Manage employees record",
                  style: GoogleFonts.montserrat(
                    fontSize: 15,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),

          // Scrollable content
          Expanded(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                children: [
                  SizedBox(height: 16),

                  // Search Bar
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: CustomSearchBar(
                      hintText: "Search employees...",
                      onChanged: (value) =>
                          controller.searchQuery.value = value,
                    ),
                  ),

                  SizedBox(height: 16),

                  // Add Button
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: CustomButton(
                      text: "+ Add New Employee",
                      onPressed: () {
                        Get.dialog(
                          AddDialog(
                            fields: [
                              {
                                "label": "Full name",
                                "icon": Icons.person,
                                "controller": nameController,
                              },
                              {
                                "label": "Job title",
                                "icon": Icons.work,
                                "controller": jobController,
                              },
                            ],
                            onSubmit: (data) async {
                              final fullName = data["Full name"] ?? '';
                              final jobTitle = data["Job title"] ?? '';
                              final trainings = data["trainings"] ?? [];
                              final expiryDate = data["expiryDate"];

                              if (fullName.isEmpty ||
                                  jobTitle.isEmpty ||
                                  expiryDate == null) {
                                Get.snackbar(
                                  'Error',
                                  'Please fill all fields',
                                  snackPosition: SnackPosition.BOTTOM,
                                  backgroundColor: Colors.grey,
                                );
                                return;
                              }

                              await controller.addEmployee(
                                fullName,
                                jobTitle,
                                expiryDate,
                                trainings.cast<Map<String, String>>(),
                              );

                              nameController.clear();
                              jobController.clear();
                              Get.back();
                            },
                            fetchTrainings: fetchTrainings,
                          ),
                        );
                      },
                      backgroundcolor: Color(0xFF6A11CB),
                    ),
                  ),

                  // Employee Cards
                  Obx(() {
                    if (controller.isLoading.value) {
                      return Center(child: CircularProgressIndicator());
                    }

                    if (controller.filteredEmployees.isEmpty) {
                      return Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Center(child: Text('No employees yet')),
                      );
                    }

                    return ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: controller.filteredEmployees.length,
                      itemBuilder: (context, index) {
                        final employee = controller.filteredEmployees[index];
                        return EmployeeCard(
                          fullName: employee['fullName'] ?? '',
                          jobTitle: employee['jobTitle'] ?? '',
                          expiryDate: employee['expiryDate'] != null
                              ? (employee['expiryDate'] as Timestamp).toDate()
                              : null,
                          trainings: List<Map<String, dynamic>>.from(
                            employee['trainings'] ?? [],
                          ),
                          onEdit: () {
                            Get.dialog(
                              EditDialog(
                                employee: employee,
                                fields: [
                                  {
                                    "key": "fullName",
                                    "label": "Full name",
                                    "icon": Icons.person,
                                    "controller": TextEditingController(
                                      text: employee['fullName'] ?? '',
                                    ),
                                  },
                                  {
                                    "key": "jobTitle",
                                    "label": "Job title",
                                    "icon": Icons.work,
                                    "controller": TextEditingController(
                                      text: employee['jobTitle'] ?? '',
                                    ),
                                  },
                                ],
                                onSubmit: (data) async {
                                  await controller.updateEmployee(
                                    employee['id'],
                                    data,
                                  );
                                },
                                fetchTrainings: fetchTrainings,
                              ),
                            );
                          },
                        );
                      },
                    );
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
