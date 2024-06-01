import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class NotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> requestNotificationPermission() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
    );

    print('Notification permission granted: ${settings.authorizationStatus}');
  }

  Future<String?> getDeviceToken() async {
    return await _firebaseMessaging.getToken();
  }

  void firebaseInit(BuildContext context) {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("onMessage: $message");
      _handleNotification(message.data);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("onMessageOpenedApp: $message");
      _handleNotification(message.data);
    });

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  Future<void> setupInteractMessage(BuildContext context) async {
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  Future<void> isTokenRefresh() async {
    _firebaseMessaging.onTokenRefresh.listen((String token) {
      print('Token refreshed: $token');
    });
  }

  Future<void> sendNotificationToToken({
    required String targetToken,
    required String title,
    required String body,
  }) async {
    var data = {
      'to': targetToken,
      'priority': 'high',
      'notification': {
        'title': title,
        'body': body,
      },
      'data': {
        'type': 'msj',
        'id': '123456',
      }
    };

    try {
      var response = await http.post(
        Uri.parse('http://fcm.googleapis.com/fcm/send'),
        body: jsonEncode(data),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'key=YOUR_FCM_SERVER_KEY',
        },
      );

      print('FCM Response Status Code: ${response.statusCode}');
      print('FCM Response Body: ${response.body}');
    } catch (error) {
      print('Error sending FCM notification: $error');
    }
  }

  void _handleNotification(Map<String, dynamic> data) {
    print('Notification data: $data');
    // You can handle the notification data here.
  }

  static Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    print("Handling a background message: ${message.messageId}");
  }
}
