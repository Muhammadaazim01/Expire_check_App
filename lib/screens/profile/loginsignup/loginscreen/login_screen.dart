import 'package:expire_check/screens/profile/loginsignup/loginscreen/login_controller.dart';
import 'package:expire_check/screens/profile/loginsignup/signupscreen/signup_screen.dart';
import 'package:expire_check/screens/profile/loginsignup/textfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final loginController = Get.find<LoginController>();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Login here',
                    style: GoogleFonts.montserrat(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Welcome back, you\'ve been missed!',
                    style: GoogleFonts.montserrat(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                  SizedBox(height: 40),

                  /// Email
                  CustomTextField(
                    labelText: 'Email',
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: Icons.email,
                  ),
                  SizedBox(height: 20),

                  /// Password
                  CustomTextField(
                    labelText: 'Password',
                    controller: passwordController,
                    obscureText: true,
                    prefixIcon: Icons.lock,
                  ),

                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        setState(() {
                          isLoading = true; // Loader start
                        });

                        Future.delayed(Duration(seconds: 2), () {
                          setState(() {
                            isLoading = false; // Loader stop
                          });
                          Get.off(() => SignIn());
                        });
                      },
                      child: isLoading
                          ? SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white70,
                              ),
                            )
                          : Text(
                              "Don't have an account? Sign up",
                              style: GoogleFonts.montserrat(
                                color: Colors.white70,
                              ),
                            ),
                    ),
                  ),

                  SizedBox(height: 30),

                  /// Login Button with loader
                  Center(
                    child: Obx(() {
                      return ElevatedButton(
                        onPressed: loginController.isLoading.value
                            ? null
                            : () async {
                                await loginController.login(
                                  emailController.text.trim(),
                                  passwordController.text.trim(),
                                );
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(
                            0xFF6C63FF,
                          ), // Professional purple
                          minimumSize: Size(200, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: loginController.isLoading.value
                            ? SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(
                                'Login',
                                style: GoogleFonts.montserrat(
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
