import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_core/firebase_core.dart';

/// 🔹 Top-level background message handler
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  final FlutterLocalNotificationsPlugin localNotifications =
      FlutterLocalNotificationsPlugin();

  const androidDetails = AndroidNotificationDetails(
    "default_channel",
    "Default Notifications",
    importance: Importance.max,
    priority: Priority.high,
    playSound: true,
    enableVibration: true,
  );
  const iosDetails = DarwinNotificationDetails();
  const notifDetails = NotificationDetails(
    android: androidDetails,
    iOS: iosDetails,
  );

  await localNotifications.show(
    0,
    message.notification?.title ?? "",
    message.notification?.body ?? "",
    notifDetails,
  );
}

class NotificationController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  RxBool isNotificationOn = false.obs;

  @override
  void onInit() {
    super.onInit();
    _initLocalNotifications();
    _initFCM();
    loadNotificationStatus();
  }

  /// Load toggle status from Firestore
  Future<void> loadNotificationStatus() async {
    try {
      final uid = _auth.currentUser?.uid;
      if (uid != null) {
        final docRef = _firestore.collection("users").doc(uid);
        final docSnap = await docRef.get();

        if (docSnap.exists) {
          isNotificationOn.value = docSnap.data()?["notifications"] ?? false;
        } else {
          // Create user doc if missing
          await docRef.set({"notifications": false, "fcmToken": ""});
          isNotificationOn.value = false;
        }
      }
    } catch (e) {
      print("Error loading notification status: $e");
    }
  }

  /// Toggle On/Off
  Future<void> toggleNotification(bool value) async {
    try {
      isNotificationOn.value = value;
      final uid = _auth.currentUser?.uid;
      if (uid != null) {
        final docRef = _firestore.collection("users").doc(uid);
        final docSnap = await docRef.get();

        if (docSnap.exists) {
          await docRef.update({"notifications": value});
        } else {
          // Create doc if missing
          await docRef.set({"notifications": value, "fcmToken": ""});
        }
      }
    } catch (e) {
      print("Error updating notification toggle: $e");
    }
  }

  /// Init Local Notifications
  void _initLocalNotifications() {
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInit = DarwinInitializationSettings();
    const initSettings = InitializationSettings(
      android: androidInit,
      iOS: iosInit,
    );

    _localNotifications.initialize(initSettings);
  }

  /// Init FCM
  Future<void> _initFCM() async {
    await _messaging.requestPermission();

    try {
      final token = await _messaging.getToken();
      print("FCM Token: $token");

      final uid = _auth.currentUser?.uid;
      if (uid != null && token != null) {
        final docRef = _firestore.collection("users").doc(uid);
        final docSnap = await docRef.get();

        if (docSnap.exists) {
          await docRef.update({"fcmToken": token});
        } else {
          // Create user doc if missing
          await docRef.set({"fcmToken": token, "notifications": true});
        }
      }
    } catch (e) {
      print("Error saving FCM token: $e");
    }

    // Foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _showLocalNotification(
        message.notification?.title ?? "",
        message.notification?.body ?? "",
      );
      print("📩 Foreground message: ${message.notification?.title}");
    });

    // Background & terminated messages
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  }

  /// Local notification show
  void _showLocalNotification(String title, String body) {
    const androidDetails = AndroidNotificationDetails(
      "default_channel",
      "Default Notifications",
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
    );
    const iosDetails = DarwinNotificationDetails();
    const notifDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    _localNotifications.show(0, title, body, notifDetails);
  }

  /// Public method to trigger push notification
  void sendPushNotification(String title, String body) {
    if (isNotificationOn.value) {
      _showLocalNotification(title, body);
    }
  }
}
