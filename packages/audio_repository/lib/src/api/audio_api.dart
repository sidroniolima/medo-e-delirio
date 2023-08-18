import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:audio_repository/src/models/comma.dart';

class CommasRequestFailure implements Exception {}

abstract class AudioApi {
  Future<List<Comma>> fetchCommas();
}

class AudioJsonApi extends AudioApi {
  AudioJsonApi({http.Client? httpClient})
      : _httpClient = httpClient ?? http.Client();

  static const _baseUrlCommas = 'sidroniolima.com.br';

  final http.Client _httpClient;

  @override
  Future<List<Comma>> fetchCommas() async {
    final commasRequest = Uri.https(_baseUrlCommas, '/med/audios.json');

    final commasResponse = await _httpClient.get(commasRequest);

    if (commasResponse.statusCode != 200) {
      throw CommasRequestFailure();
    }

    final commasJson = jsonDecode(commasResponse.body) as List;

    if (commasJson.isEmpty) return [];

    return commasJson.map((comma) => Comma.fromJson(comma)).toList();
  }
}
