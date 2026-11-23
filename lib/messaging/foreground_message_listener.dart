import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:medo_e_delirio_app/@shared/@shared.dart';

/// Android doesn't show FCM notifications while the app is in the
/// foreground, so they're shown here as a floating in-app message.
class ForegroundMessageListener extends StatefulWidget {
  const ForegroundMessageListener({
    super.key,
    required this.messages,
    required this.child,
  });

  /// Usually [FirebaseMessaging.onMessage].
  final Stream<RemoteMessage> messages;
  final Widget child;

  @override
  State<ForegroundMessageListener> createState() =>
      _ForegroundMessageListenerState();
}

class _ForegroundMessageListenerState extends State<ForegroundMessageListener> {
  late final StreamSubscription<RemoteMessage> _subscription;

  @override
  void initState() {
    super.initState();
    _subscription = widget.messages.listen(_show);
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  void _show(RemoteMessage message) {
    final notification = message.notification;
    if (notification == null || !mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
        appSnackBar(title: notification.title, body: notification.body));
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
