import 'dart:developer';
import 'package:comma_api/comma_api.dart';
import 'package:flutter/widgets.dart';

import 'package:audio_repository/audio_repository.dart';

import 'app/app.dart';

void bootstrap({required CommaApi commaApi}) {
  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };

  final audioRepo = AudioRepository(commaApi: commaApi);

  /*
  runZonedGuarded(() => runApp(App(audioRepository: audioRepo)),
      (error, stack) => log(error.toString(), stackTrace: stack));
      */

  runApp(App(audioRepository: audioRepo));
}
