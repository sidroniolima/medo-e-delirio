import 'package:audio_repository/audio_repository.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:medo_e_delirio_app/bootstrap.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';

//To generate icon
//https://romannurik.github.io/AndroidAssetStudio/icons-launcher.html#foreground.type=clipart&foreground.clipart=outlined_flag&foreground.space.trim=1&foreground.space.pad=0.25&foreColor=rgb(98%2C%20148%2C%2096)&backColor=rgb(36%2C%2049%2C%2025)&crop=0&backgroundShape=circle&effects=none&name=notification_icon

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final audioApi = AudioJsonApi(plugin: await SharedPreferences.getInstance());

  bootstrap(audioApi: audioApi);
}
