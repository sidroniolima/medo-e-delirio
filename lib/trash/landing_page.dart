import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:medo_e_delirio_app/screens/home_screen_bloc.dart';
import '../models/audio.dart';
import '../widgets/default_error_message.dart';
import '../widgets/default_progress_indicator.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  Future<List<Audio>> _init() async {
    List<Audio> audios = [];

    Uint8List bytes =
        await readBytes(Uri.https('sidroniolima.com.br', '/med/audios.json'));

    final data = await jsonDecode(utf8.decode(bytes));

    for (final item in data) {
      audios.add(Audio.fromJson(item));
    }

    audios.sort((a, b) => b.id.compareTo(a.id));

    return audios;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: FutureBuilder(
        future: _init(),
        builder: (BuildContext context, AsyncSnapshot<List<Audio>> snapshot) {
          if (snapshot.hasError) {
            print(snapshot.error);
            return DefaultErrorMessage(action: () {
              //this._search([]);
            });
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: DefaultProgressIndicator(
                    message: 'Carregando as vírgulas, oh cara!'));
          }

          List<Audio> audios = snapshot.hasData ? snapshot.data! : [];

          return HomeScreenBloc.create(context, audios);
        },
      )),
    );
  }
}
