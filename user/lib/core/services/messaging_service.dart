import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final messagingServiceProvider = Provider<MessagingService>((ref) => MessagingService());

class MessagingService {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  Future<void> init() async {
    // Request permissions
    await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // Get FCM Token
    final token = await _fcm.getToken();
    print('FCM Token: $token');

    // Watch foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _showNotification(message);
    });
  }

  Future<void> _showNotification(RemoteMessage message) async {
    final notification = message.notification;
    if (notification == null) return;
    print('Notification: ${notification.title} - ${notification.body}');
  }

  Future<void> simulateSMSFallback(String phoneNumber, String message) async {
    // Logic to simulate SMS (logging or calling a mock API)
    print('Simulated SMS to $phoneNumber: $message');
  }
}
