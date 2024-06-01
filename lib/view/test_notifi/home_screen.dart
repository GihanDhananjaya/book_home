import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  @override
  void initState() {
    super.initState();
    initializeNotifications();
    setupFirebaseMessaging();
  }

  Future<void> initializeNotifications() async {
    final AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('app_icon');
    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void setupFirebaseMessaging() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      // Handle FCM message when the app is in the foreground
      showNotification(message.data);
      // Store the notification in Firestore
      storeNotificationInFirestore(message.data);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      // Handle FCM message when the app is opened from the background
      handleNotificationTap(message.data);
      // Store the notification in Firestore
      storeNotificationInFirestore(message.data);
    });

    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
      // Handle FCM message when the app is opened from a terminated state
      if (message != null) {
        handleNotificationTap(message.data);
        // Store the notification in Firestore
        storeNotificationInFirestore(message.data);
      }
    });
  }

  Future<void> showNotification(Map<String, dynamic> message) async {
    final String title = message['notification']['title'] ?? 'Notification';
    final String body = message['notification']['body'] ?? 'Default Body';

    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          'channel_id',
          'Channel Name',
          //'Channel Description',
          importance: Importance.max,
          priority: Priority.high,
          icon: 'app_icon',
        ),
      ),
    );
  }

  void handleNotificationTap(Map<String, dynamic> message) {
    // Handle the tap on the notification, navigate to a specific screen, etc.
    print('Notification tapped: $message');
  }

  Future<void> storeNotificationInFirestore(Map<String, dynamic> notificationData) async {
    // Add your Firestore collection and document reference here
    CollectionReference notifications = FirebaseFirestore.instance.collection('notifications');

    await notifications.add({
      'title': notificationData['notification']['title'],
      'body': notificationData['notification']['body'],
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FCM Notifications Example'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Simulate a button click to trigger a test notification
            _simulateButtonClick();
          },
          child: Text('Send Test Notification'),
        ),
      ),
    );
  }

  void _simulateButtonClick() async {
    // Simulate a button click to trigger a test notification
    await _firebaseMessaging.subscribeToTopic('testTopic');
    await _firebaseMessaging.unsubscribeFromTopic('testTopic');
    await _firebaseMessaging.subscribeToTopic('testTopic');
  }
}