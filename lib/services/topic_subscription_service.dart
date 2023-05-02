import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../exceptions/custom_firebase_messaging_exception.dart';
import '../utils/preferences.dart';

class TopicSubscriptionService {
  Future<List<String>> _nonSubscribedTopics(
      List<String> availableTopics) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String> subscriptions =
        prefs.getStringList('${Preferences.medo_e_delirio_subscriptions}') ?? [];

    availableTopics.removeWhere((element) => subscriptions.contains(element));

    return availableTopics;
  }

  Future<void> subscribeIfAlreadyNot(List<String> availableTopics) async {
    await Firebase.initializeApp();
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      List<String> newSubscriptions =
          await this._nonSubscribedTopics(availableTopics);
      if (newSubscriptions.isEmpty) {
        return;
      }

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(
          '${Preferences.medo_e_delirio_subscriptions}', newSubscriptions);

      newSubscriptions.forEach((topic) async {
        await FirebaseMessaging.instance.subscribeToTopic(topic);
      });
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      throw new CustomFirebaseMessagingException(
          'Verifique se as notificações estão autorizadas.');
    } else {
      throw new CustomFirebaseMessagingException(
          'Parece que as notificações estão desabilitadas. Habilite-as para ficar por dentro de novidades.');
    }
  }
}