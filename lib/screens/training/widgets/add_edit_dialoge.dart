import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class AddTrainingDialog extends StatefulWidget {
  final String documentId;
  final Map<String, dynamic> initialData;
  final Function(Map<String, dynamic>) onSubmit;

  AddTrainingDialog({
    super.key,
    required this.documentId,
    required this.initialData,
    required this.onSubmit,
  });

  @override
  _AddTrainingDialogState createState() => _AddTrainingDialogState();
}

class _AddTrainingDialogState extends State<AddTrainingDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _codeController;
  late TextEditingController _dateController;

  @override
  void initState() {
    super.initState();
    _codeController = TextEditingController(
      text: widget.initialData['code'] ?? '',
    );
    _dateController = TextEditingController(
      text:
          widget.initialData['date'] ??
          DateFormat('yyyy-MM-dd').format(DateTime.now()),
    );
  }

  @override
  void dispose() {
    _codeController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final data = {
        'code': _codeController.text.trim(),
        'date': _dateController.text.trim(),
      };
      widget.onSubmit(data);
      Get.back();
    }
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: GoogleFonts.montserrat(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        padding: EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.documentId.isEmpty ? 'Add Training' : 'Edit Training',
                style: GoogleFonts.montserrat(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 20),

              Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Training Code
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel("Training Code"),
                        TextFormField(
                          controller: _codeController,
                          style: GoogleFonts.montserrat(color: Colors.black),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            hintText: "Training Code",
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: Colors.black,
                                width: 1.5,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            prefixIcon: Icon(
                              Icons.confirmation_number,
                              color: Color(0xFF6A11CB),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a training code';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 16),

                    // Expiry Date
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel("Expiry Date"),
                        TextFormField(
                          controller: _dateController,
                          style: GoogleFonts.montserrat(color: Colors.black),
                          readOnly: true,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: Colors.black,
                                width: 1.5,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            prefixIcon: Icon(
                              Icons.date_range,
                              color: Color(0xFF6A11CB),
                            ),
                          ),
                          onTap: () async {
                            FocusScope.of(context).requestFocus(FocusNode());
                            final DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate:
                                  DateTime.tryParse(_dateController.text) ??
                                  DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime(2100),
                            );
                            if (pickedDate != null) {
                              setState(() {
                                _dateController.text = DateFormat(
                                  'yyyy-MM-dd',
                                ).format(pickedDate);
                              });
                            }
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter an expiry date';
                            }
                            try {
                              DateFormat('yyyy-MM-dd').parse(value);
                              return null;
                            } catch (e) {
                              return 'Please enter a valid date (yyyy-MM-dd)';
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24),

              // Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    style: TextButton.styleFrom(foregroundColor: Colors.white),
                    onPressed: () => Get.back(),
                    child: Text('Cancel'),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Color(0xFF6A11CB),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: _submitForm,
                    child: Text('Save'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
