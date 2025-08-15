import 'package:expire_check/screens/training/controllers/training_controller.dart';
import 'package:expire_check/screens/training/widgets/add_edit_dialoge.dart';
import 'package:expire_check/screens/training/widgets/card.dart';
import 'package:expire_check/screens/widgets/button.dart';
import 'package:expire_check/screens/widgets/search_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class TrainingsPage extends StatelessWidget {
  const TrainingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TrainingController>();

    return Scaffold(
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return Column(
          children: [
            // Header (fixed)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 70, left: 16, bottom: 16),
              decoration: const BoxDecoration(
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
                    "Trainings",
                    style: GoogleFonts.montserrat(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "Manage trainings record",
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
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    const SizedBox(height: 16),

                    // Search bar
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: CustomSearchBar(
                        hintText: "Search trainings...",
                        onChanged: (value) =>
                            controller.searchQuery.value = value,
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Add button
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: CustomButton(
                        text: "Add New Training",
                        onPressed: () {
                          Get.dialog(
                            AddTrainingDialog(
                              documentId: '',
                              initialData: {
                                'code': '',
                                'date': DateFormat(
                                  'yyyy-MM-dd',
                                ).format(DateTime.now()),
                              },
                              onSubmit: (data) async {
                                await controller.addTraining(
                                  data['code'],
                                  data['date'],
                                );
                              },
                            ),
                          );
                        },
                        backgroundcolor: const Color(0xFF6A11CB),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Training cards
                    Obx(() {
                      if (controller.filteredTrainings.isEmpty) {
                        return const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Center(child: Text('No trainings yet')),
                        );
                      }

                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: controller.filteredTrainings.length,
                        itemBuilder: (context, index) {
                          final training = controller.filteredTrainings[index];
                          return TrainingCard(
                            documentId: training['id'],
                            training: training,
                          );
                        },
                      );
                    }),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
