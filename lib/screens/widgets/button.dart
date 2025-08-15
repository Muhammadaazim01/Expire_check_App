import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color backgroundcolor;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    required this.backgroundcolor,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundcolor,
        minimumSize: Size(double.infinity, 50),
      ),
      child: Text(
        text,
        style: GoogleFonts.montserrat(color: Colors.white, fontSize: 20),
      ),
    );
  }
}
