import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class AddDialog extends StatefulWidget {
  final List<Map<String, dynamic>> fields;
  final Future<void> Function(Map<String, dynamic> data) onSubmit;
  final Future<List<Map<String, String>>> Function() fetchTrainings;

  const AddDialog({
    super.key,
    required this.fields,
    required this.onSubmit,
    required this.fetchTrainings,
  });

  @override
  State<AddDialog> createState() => _AddDialogState();
}

class _AddDialogState extends State<AddDialog> {
  DateTime? _expiryDate;
  final Set<String> selectedTrainings = {};
  List<Map<String, String>> trainings = [];
  bool dropdownOpen = false;

  @override
  void initState() {
    super.initState();
    _loadTrainings();
  }

  Future<void> _loadTrainings() async {
    trainings = await widget.fetchTrainings();
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 8,
      child: Container(
        padding: EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF4E54C8), Color(0xFF8F94FB)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Add New Employee",
                style: GoogleFonts.montserrat(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 20),
              // Dynamic text fields
              for (var field in widget.fields) ...[
                _buildTextField(
                  controller: field["controller"] as TextEditingController,
                  label: field["label"] as String,
                  icon: field["icon"] as IconData,
                ),
                SizedBox(height: 16),
              ],
              // Trainings dropdown
              GestureDetector(
                onTap: () => setState(() => dropdownOpen = !dropdownOpen),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white54),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        selectedTrainings.isEmpty
                            ? "Select Trainings"
                            : selectedTrainings.join(', '),
                        style: GoogleFonts.montserrat(color: Colors.white),
                      ),
                      Icon(
                        dropdownOpen
                            ? Icons.arrow_drop_up
                            : Icons.arrow_drop_down,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 8),
              if (dropdownOpen && trainings.isNotEmpty)
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white12,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: trainings.map((t) {
                      final code = t['code'] ?? '';
                      final selected = selectedTrainings.contains(code);
                      return ChoiceChip(
                        label: Text(
                          code,
                          style: GoogleFonts.montserrat(
                            color: selected ? Colors.white : Colors.black87,
                          ),
                        ),
                        selected: selected,
                        selectedColor: Colors.deepPurpleAccent,
                        onSelected: (val) {
                          setState(() {
                            if (val) {
                              selectedTrainings.add(code);
                            } else {
                              selectedTrainings.remove(code);
                            }
                          });
                        },
                      );
                    }).toList(),
                  ),
                ),
              SizedBox(height: 16),
              // Expiry date picker
              InkWell(
                onTap: _pickDate,
                borderRadius: BorderRadius.circular(12),
                child: InputDecorator(
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.calendar_today,
                      color: Colors.white70,
                    ),
                    labelText: "Expiry Date",
                    labelStyle: GoogleFonts.montserrat(color: Colors.white70),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.white54),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                  child: Text(
                    _expiryDate != null
                        ? DateFormat('yyyy-MM-dd').format(_expiryDate!)
                        : "Select Date",
                    style: GoogleFonts.montserrat(color: Colors.white),
                  ),
                ),
              ),
              SizedBox(height: 24),
              // Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Get.back(),
                    child: Text(
                      "Cancel",
                      style: GoogleFonts.montserrat(color: Colors.white70),
                    ),
                  ),
                  SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: _handleSubmit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurpleAccent,
                      padding: EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 24,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      "Save",
                      style: GoogleFonts.montserrat(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
  }) {
    return TextField(
      controller: controller,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.white70),
        labelText: label,
        labelStyle: TextStyle(color: Colors.white70),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => _expiryDate = picked);
  }

  Future<void> _handleSubmit() async {
    // Validate text fields
    for (var field in widget.fields) {
      final controller = field["controller"] as TextEditingController;
      if (controller.text.trim().isEmpty) {
        Get.snackbar(
          "Error",
          "Please fill all fields",
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }
    }

    if (_expiryDate == null) {
      Get.snackbar(
        "Error",
        "Please select expiry date",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    // Prepare data safely
    final Map<String, dynamic> data = {
      for (var field in widget.fields)
        field["label"]: field["controller"].text.trim(),
      "trainings": selectedTrainings
          .map((code) => <String, String>{"code": code})
          .toList(),
      "expiryDate": _expiryDate,
    };

    // Call the onSubmit safely
    try {
      await widget.onSubmit(data);
      // Close dialog only if successful
    } catch (e) {
      Get.snackbar(
        "Error",
        "Something went wrong: $e",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
