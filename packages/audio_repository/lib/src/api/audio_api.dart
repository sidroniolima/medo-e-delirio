import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:audio_repository/src/models/comma.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CommasRequestFailure implements Exception {}

abstract class AudioApi {
  Future<List<Comma>> fetchCommas();
  Future<void> favoriteComma(Comma comma);
  Future<List<Comma>> getFavoritedCommas();
}

class AudioJsonApi extends AudioApi {
  AudioJsonApi({required SharedPreferences plugin, http.Client? httpClient})
      : _httpClient = httpClient ?? http.Client(),
        _plugin = plugin;

  static const _baseUrlCommas = 'sidroniolima.com.br';

  final http.Client _httpClient;
  final SharedPreferences _plugin;

  @visibleForTesting
  static const kFavoriteCommasCollectionKey =
      '__commas_favorite_collection_key';

  String? _getValue(String key) => _plugin.getString(key);
  Future<void> _setValue(String key, String value) =>
      _plugin.setString(key, value);

  @override
  Future<List<Comma>> fetchCommas() async {
    final commasRequest = Uri.https(_baseUrlCommas, '/med/audios.json');

    final commasResponse = await _httpClient
        .get(commasRequest, headers: {'content-type': 'application/json'});

    if (commasResponse.statusCode != 200) {
      throw CommasRequestFailure();
    }

    final commasJson =
        jsonDecode(utf8.decode(commasResponse.bodyBytes)) as List;

    if (commasJson.isEmpty) return [];

    return commasJson
        .map((comma) => Comma.fromJson(comma))
        .toList()
        .reversed
        .toList();
  }

  @override
  Future<void> favoriteComma(Comma comma) async {
    final List<Comma> savedCommas = await getFavoritedCommas();

    final newCommas = [...savedCommas];
    newCommas.add(comma);

    await _setValue(kFavoriteCommasCollectionKey, json.encode(newCommas));
  }

  @override
  Future<List<Comma>> getFavoritedCommas() async {
    final commasJson = await _getValue(kFavoriteCommasCollectionKey);

    if (commasJson != null) {
      final commas = List<Map<dynamic, dynamic>>.from(
        json.decode(commasJson) as List,
      )
          .map((jsonMap) => Comma.fromJson(Map<String, dynamic>.from(jsonMap)))
          .toList();

      return commas;
    }

    return [];
  }
}
