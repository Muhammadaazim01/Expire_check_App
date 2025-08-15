// overview_card.dart
import 'package:flutter/material.dart';

class OverviewCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final Color iconColor;
  final String number;
  final String label;

  const OverviewCard({
    super.key,
    required this.icon,
    required this.color,
    required this.iconColor,
    required this.number,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white, // same as before
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            spreadRadius: 2,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            backgroundColor: color, // same as before
            child: Icon(icon, color: iconColor), // same as before
          ),
          SizedBox(height: 8),
          Text(
            number,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black, // text color black
            ),
          ),
          SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(color: Colors.grey, fontSize: 12),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
