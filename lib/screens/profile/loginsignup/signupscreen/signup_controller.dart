import 'package:expire_check/screens/profile/loginsignup/loginscreen/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUpController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  RxString userName = ''.obs;
  RxString email = ''.obs; // email track karne ke liye
  var isLoading = false.obs; // loader ke liye

  @override
  void onInit() {
    super.onInit();
    _loadUserData();
  }

  void _loadUserData() {
    final user = _auth.currentUser;
    if (user != null) {
      userName.value = user.displayName ?? 'Guest';
      email.value = user.email ?? '';
    }
  }

  Future<void> signUp(String email, String password, String userName) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      // Update display name
      await userCredential.user?.updateDisplayName(userName);
      await userCredential.user?.reload();

      // Update Rx variables
      this.userName.value = userName;
      this.email.value = email;

      Get.snackbar(
        "Success",
        "Account created successfully!",
        backgroundColor: Colors.grey[800],
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: EdgeInsets.all(12),
        borderRadius: 8,
        duration: Duration(seconds: 2),
      );

      Get.offAll(() => LoginScreen());
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
        backgroundColor: Colors.red[600],
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: EdgeInsets.all(12),
        borderRadius: 8,
        duration: Duration(seconds: 3),
      );
    }
  }

  /// ----------------------
  /// Sign Out Logic
  /// ----------------------
  Future<void> signOut() async {
    try {
      isLoading.value = true;

      Get.dialog(
        Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      await _auth.signOut();

      isLoading.value = false;
      Get.back(); // close loader

      Get.offAll(() => LoginScreen());

      Get.snackbar(
        "Success",
        "Logged out successfully!",
        backgroundColor: Colors.grey[800],
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: EdgeInsets.all(12),
        borderRadius: 8,
        duration: Duration(seconds: 2),
      );
    } catch (e) {
      isLoading.value = false;
      Get.back();
      Get.snackbar(
        "Error",
        "Logout failed. Please try again.",
        backgroundColor: Colors.red[600],
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: EdgeInsets.all(12),
        borderRadius: 8,
        duration: Duration(seconds: 2),
      );
    }
  }
}
