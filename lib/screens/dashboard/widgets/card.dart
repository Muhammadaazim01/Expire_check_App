import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final String title;
  final List<Map<String, dynamic>> data;
  final VoidCallback onTap;

   const CustomCard({super.key, required this.title, required this.data, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin:  EdgeInsets.all(8.0),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding:  EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style:  TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
               SizedBox(height: 10),
              ...data.map((item) => ListTile(
                title: Text(item['title'] ?? 'N/A'),
                subtitle: Text(item['subtitle'] ?? ''),
              )),
            ],
          ),
        ),
      ),
    );
  }
}