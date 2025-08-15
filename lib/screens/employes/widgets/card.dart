import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class EmployeeCard extends StatelessWidget {
  final String fullName;
  final String jobTitle;
  final DateTime? expiryDate;
  final List<Map<String, dynamic>> trainings;
  final VoidCallback onEdit;

  const EmployeeCard({
    super.key,
    required this.fullName,
    required this.jobTitle,
    required this.expiryDate,
    required this.trainings,
    required this.onEdit,
  });

  // Trainings ko chunks me todna (3 per row)
  List<List<Map<String, dynamic>>> chunkTrainings(
    List<Map<String, dynamic>> list,
    int chunkSize,
  ) {
    List<List<Map<String, dynamic>>> chunks = [];
    for (var i = 0; i < list.length; i += chunkSize) {
      int end = (i + chunkSize < list.length) ? i + chunkSize : list.length;
      chunks.add(list.sublist(i, end));
    }
    return chunks;
  }

  @override
  Widget build(BuildContext context) {
    final initials = fullName.isNotEmpty ? fullName[0] : 'U';
    final formattedExpiryDate = expiryDate != null
        ? DateFormat('yyyy-MM-dd').format(expiryDate!)
        : 'No date';

    final List<Color> bgColors = [
      Colors.red.shade100,
      Colors.green.shade100,
      Colors.blue.shade100,
      Colors.orange.shade100,
      Colors.purple.shade100,
      Colors.teal.shade100,
    ];

    final List<Color> borderColors = [
      Colors.red.shade400,
      Colors.green.shade400,
      Colors.blue.shade400,
      Colors.orange.shade400,
      Colors.purple.shade400,
      Colors.teal.shade400,
    ];

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.black.withOpacity(0.15),
            blurRadius: 10,
            spreadRadius: 2,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Row: Avatar + Details + Edit button
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
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
                      color: Colors.black.withOpacity(0.25),
                      blurRadius: 6,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: CircleAvatar(
                  radius: 26,
                  backgroundColor: Colors.transparent,
                  child: Text(
                    initials,
                    style: GoogleFonts.montserrat(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      fullName,
                      style: GoogleFonts.montserrat(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4),
                    Text(
                      jobTitle,
                      style: GoogleFonts.montserrat(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Heired Date: $formattedExpiryDate',
                      style: GoogleFonts.montserrat(
                        fontSize: 12,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(Icons.edit, color: Color(0xFF6A11CB)),
                onPressed: onEdit,
              ),
            ],
          ),
          SizedBox(height: 12),

          // Trainings Chips
          Column(
            children: chunkTrainings(trainings, 3).map((chunk) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: chunk.asMap().entries.map((entry) {
                  Map<String, dynamic> task = entry.value;
                  int overallIdx = trainings.indexOf(task);
                  Color bgColor = bgColors[overallIdx % bgColors.length];
                  Color borderColor =
                      borderColors[overallIdx % borderColors.length];

                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                    child: Chip(
                      label: Text(
                        '${task['code']}',
                        style: GoogleFonts.montserrat(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: borderColor,
                        ),
                      ),
                      backgroundColor: bgColor,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: borderColor, width: 1.5),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: EdgeInsets.symmetric(
                        vertical: 6,
                        horizontal: 12,
                      ),
                    ),
                  );
                }).toList(),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
