import 'package:expire_check/firebase_options.dart';
import 'package:expire_check/screens/alerts/controller/contoller.dart';
import 'package:expire_check/screens/dashboard/dashboard_controller/controller.dart';
import 'package:expire_check/screens/employes/controllers/controllers.dart';
import 'package:expire_check/screens/profile/controller/notifiction_controller.dart';
import 'package:expire_check/screens/profile/loginsignup/loginscreen/login_controller.dart';
import 'package:expire_check/screens/profile/loginsignup/signupscreen/signup_controller.dart';
import 'package:expire_check/screens/splash_screen.dart';
import 'package:expire_check/screens/training/controllers/training_controller.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// 🔹 Background message handler
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("📩 Background message: ${message.notification?.title}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // 🔹 Set background handler
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // 🔹 Put controllers
  Get.put(EmployeesController(), permanent: true);
  Get.put(TrainingController(), permanent: true);
  Get.put(DashboardController(), permanent: true);
  Get.put(AlertController(), permanent: true);
  Get.put(NotificationController(), permanent: true);
  Get.put(LoginController(), permanent: true);
  Get.put(SignUpController(), permanent: true);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
