import 'package:medo_e_delirio_app/models/audio.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'dart:convert';

class Webservice {
  Future<List<Audio>> fetchAudios() async {
    String response = await rootBundle.loadString('assets/audios.json');
    final body = jsonDecode(response);

    print(body);
    final Iterable json = body["audios"];

    return json.map((audio) => Audio.fromJson(audio)).toList();
  }
}
