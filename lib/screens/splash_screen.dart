import 'package:expire_check/screens/profile/loginsignup/signupscreen/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart'; // GetX for navigation

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // 3 seconds baad SignupScreen pe navigate karega
    Future.delayed(Duration(seconds: 3), () {
      Get.off(() => SignIn());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF6A11CB), // 🔹 Purple background
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 🔹 Beech wali image
            Image.asset(
              "assets/images/splash.png", // apni image ka path yahan daalo
              height: 120,
            ),

            SizedBox(height: 20),

            // 🔹 Neeche text
            Text(
              "Expire Check",
              style: GoogleFonts.montserrat(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1.2,
              ),
            ),

            SizedBox(height: 8),

            // 🔹 Tagline
            Text(
              "Stay Updated, Stay Notified",
              style: GoogleFonts.montserrat(
                fontSize: 16,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
