import 'dart:async';
import 'dart:developer';
import 'package:flutter/widgets.dart';

import 'package:audio_repository/audio_repository.dart';

import 'app/app.dart';

void bootstrap({required AudioApi audioApi}) {
  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };

  final audioRepo = AudioRepository(audioApi: audioApi);

  runZonedGuarded(() => runApp(App(audioRepository: audioRepo)),
      (error, stack) => log(error.toString(), stackTrace: stack));
}
