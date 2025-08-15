import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class EditDialog extends StatefulWidget {
  final Map<String, dynamic> employee;
  final List<Map<String, dynamic>> fields;
  final void Function(Map<String, dynamic> data) onSubmit;
  final Future<List<Map<String, String>>> Function() fetchTrainings;

  const EditDialog({
    super.key,
    required this.employee,
    required this.fields,
    required this.onSubmit,
    required this.fetchTrainings,
  });

  @override
  State<EditDialog> createState() => _EditDialogState();
}

class _EditDialogState extends State<EditDialog> {
  DateTime? _expiryDate;
  final Set<String> selectedTrainings = {};
  List<Map<String, String>> trainings = [];
  bool dropdownOpen = false;

  @override
  void initState() {
    super.initState();
    _loadTrainings();

    // Expiry date pre-fill
    _expiryDate = widget.employee['expiryDate'] != null
        ? (widget.employee['expiryDate'] is DateTime
              ? widget.employee['expiryDate']
              : widget.employee['expiryDate'].toDate())
        : null;

    // Trainings pre-select
    if (widget.employee['trainings'] != null) {
      for (var t in widget.employee['trainings']) {
        selectedTrainings.add(t['code']);
      }
    }

    // Pre-fill text fields using 'key'
    for (var field in widget.fields) {
      final key = field["key"];
      if (widget.employee[key] != null) {
        field["controller"].text = widget.employee[key].toString();
      }
    }
  }

  Future<void> _loadTrainings() async {
    trainings = await widget.fetchTrainings();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 8,
      child: Container(
        padding: const EdgeInsets.all(24),
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
              // Header
              Text(
                "Edit Employee",
                style: GoogleFonts.montserrat(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),

              // Dynamic Text Fields
              for (var field in widget.fields) ...[
                _buildTextField(
                  controller: field["controller"],
                  label: field["label"],
                  icon: field["icon"],
                ),
                const SizedBox(height: 16),
              ],

              // Dropdown Trainings
              GestureDetector(
                onTap: () => setState(() => dropdownOpen = !dropdownOpen),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white54),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          selectedTrainings.isEmpty
                              ? "Select Trainings"
                              : selectedTrainings.join(', '),
                          style: GoogleFonts.montserrat(color: Colors.white),
                          overflow: TextOverflow.ellipsis,
                        ),
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
              const SizedBox(height: 8),

              // Trainings Chips
              if (dropdownOpen && trainings.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 8,
                  ),
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
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        selected: selected,
                        selectedColor: Colors.deepPurpleAccent,
                        backgroundColor: Colors.white70,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
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

              const SizedBox(height: 16),

              // Expiry Date Picker
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
              const SizedBox(height: 24),

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
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: _handleSubmit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurpleAccent,
                      padding: const EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 24,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      "Update",
                      style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.white,
                      ),
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
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white54),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: Get.context!,
      initialDate: _expiryDate ?? DateTime.now(),
      firstDate: DateTime.now(), // ✅ past dates block
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Colors.deepPurpleAccent,
            hintColor: Colors.deepPurpleAccent,
            colorScheme: const ColorScheme.light(
              primary: Colors.deepPurpleAccent,
              onPrimary: Colors.white,
              onSurface: Colors.black87,
            ),
            dialogTheme: DialogThemeData(
              backgroundColor: Colors.white,
            ), // ✅ clear white background
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _expiryDate = picked;
      });
    }
  }

  void _handleSubmit() {
    // Validation
    for (var field in widget.fields) {
      final controller = field["controller"] as TextEditingController?;
      if (controller == null || controller.text.trim().isEmpty) {
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
        "Please select an expiry date",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    // Construct data map with 'key'
    final Map<String, dynamic> data = {};
    for (var field in widget.fields) {
      final controller = field["controller"] as TextEditingController;
      final key = field["key"].toString(); // Firestore key
      data[key] = controller.text.trim();
    }
    data["expiryDate"] = _expiryDate;
    data["trainings"] = selectedTrainings
        .map((code) => {"code": code})
        .toList(growable: false);

    widget.onSubmit(data);
    Get.back();
  }
}
