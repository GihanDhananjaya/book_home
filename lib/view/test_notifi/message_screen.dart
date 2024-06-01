import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class MessageScreen extends StatelessWidget {
  final RemoteMessage message;

  const MessageScreen({required this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notification Received'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Title: ${message.notification?.title ?? "No Title"}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Body: ${message.notification?.body ?? "No Body"}',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
