import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

class TokenSubscriber {
  final FirebaseMessaging _messaging;

  TokenSubscriber({required FirebaseMessaging messaging})
      : _messaging = messaging;

  Future<void> subscribe(toToken) async {
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    switch (settings.authorizationStatus) {
      case AuthorizationStatus.authorized:
        {
          final topics = ['all'];

          if (null != toToken) {
            if (kDebugMode) {
              topics.add('debug');
            }

            await subscribeTo(topics);
          }
        }
      case AuthorizationStatus.denied || AuthorizationStatus.notDetermined:
      default:
    }
  }

  Future<void> subscribeTo(List<String> topics) async {
    topics.forEach((topic) async => await _messaging.subscribeToTopic(topic));
  }
}
