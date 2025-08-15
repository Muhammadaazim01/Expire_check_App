import 'package:expire_check/screens/profile/loginsignup/loginscreen/login_screen.dart';
import 'package:expire_check/screens/profile/loginsignup/signupscreen/signup_controller.dart';
import 'package:expire_check/screens/profile/loginsignup/textfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class SignIn extends StatefulWidget {
  SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final signUpController = Get.find<SignUpController>();

  final userNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isLoading = false;

  @override
  void dispose() {
    userNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

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
                    'Sign Up',
                    style: GoogleFonts.montserrat(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Create your account now!',
                    style: GoogleFonts.montserrat(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                  SizedBox(height: 40),

                  // Username Field
                  CustomTextField(
                    labelText: 'Username',
                    controller: userNameController,
                    keyboardType: TextInputType.text,
                    prefixIcon: Icons.person,
                  ),
                  SizedBox(height: 20),

                  // Email Field
                  CustomTextField(
                    labelText: 'Email',
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: Icons.email,
                  ),
                  SizedBox(height: 20),

                  // Password Field
                  CustomTextField(
                    labelText: 'Password',
                    controller: passwordController,
                    obscureText: true,
                    prefixIcon: Icons.lock,
                  ),
                  SizedBox(height: 10),

                  // Already have account? Button with loader
                  Align(
                    alignment: Alignment.centerRight,
                    child: isLoading
                        ? SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : TextButton(
                            onPressed: () async {
                              setState(() {
                                isLoading = true;
                              });

                              await Future.delayed(Duration(seconds: 2));

                              setState(() {
                                isLoading = false;
                              });

                              Get.to(() => LoginScreen());
                            },
                            child: Text(
                              "Already have an Account?",
                              style: GoogleFonts.montserrat(
                                color: Colors.white70,
                              ),
                            ),
                          ),
                  ),
                  SizedBox(height: 30),

                  // Sign Up Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          setState(() {
                            isLoading = true;
                          });

                          await signUpController.signUp(
                            emailController.text.trim(),
                            passwordController.text.trim(),
                            userNameController.text.trim(),
                          );

                          setState(() {
                            isLoading = false;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(
                            0xFF6C63FF,
                          ), // Professional purple button
                          minimumSize: Size(200, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'Sign Up',
                          style: GoogleFonts.montserrat(
                            fontSize: 18,
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
        ),
      ),
    );
  }
}
