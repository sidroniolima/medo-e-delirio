import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:comma_api/comma_api.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CommasRequestFailure implements Exception {}

class LocalStorageCommaApiFactory {
  Future<LocalStorageCommaApi> initiate(
      {required SharedPreferences plugin, http.Client? httpClient}) async {
    LocalStorageCommaApi api =
        LocalStorageCommaApi(plugin: plugin, httpClient: httpClient);

    await api.init();

    return api;
  }
}

/// {@template local_storage_comma_api}
/// The Comma API local storage implementation
/// {@endtemplate}
class LocalStorageCommaApi implements CommaApi {
  /// {@macro local_storage_comma_api}
  LocalStorageCommaApi(
      {required SharedPreferences plugin, http.Client? httpClient})
      : _httpClient = httpClient ?? http.Client(),
        _plugin = plugin;

  static const _baseUrlCommas = 'sidroniolima.com.br';

  final http.Client _httpClient;
  final SharedPreferences _plugin;

  final _commaStreamController = BehaviorSubject<List<Comma>>.seeded([]);

  @visibleForTesting
  static const kFavoriteCommasCollectionKey =
      '__commas_favorite_collection_key';

  String? _getValue(String key) => _plugin.getString(key);
  Future<void> _setValue(String key, String value) =>
      _plugin.setString(key, value);

  @override
  Stream<List<Comma>> getCommas() => _commaStreamController.asBroadcastStream();

  Future<void> init() async {
    await this.fetchCommas(0, 10000, '');
  }

  @override
  Future<void> fetchCommas(
      int offset, int resultsForPage, String userId) async {
    final commasRequest =
        Uri.https(_baseUrlCommas, '/med/audios_with_musics.json');

    final commasResponse = await _httpClient
        .get(commasRequest, headers: {'content-type': 'application/json'});

    if (commasResponse.statusCode != 200) {
      throw CommasRequestFailure();
    }

    final commasJson =
        jsonDecode(utf8.decode(commasResponse.bodyBytes)) as List;

    if (commasJson.isEmpty) return;

    List<Comma> favorites = await this.loadFavoritedCommas();

    List<Comma> createdCommas = commasJson
        .map((comma) {
          Comma newComma = Comma.fromJson(comma);
          return (favorites.map((fav) => fav.id).contains(newComma.id)
              ? newComma.copyWith(favorite: true)
              : newComma);
        })
        .toList()
        .reversed
        .toList();

    _commaStreamController.add(createdCommas);
  }

  @override
  Future<void> desfavorite(String userId, Comma comma) async {
    final List<Comma> favoritedCommas = loadFavoritedCommas();

    if (!favoritedCommas.map((fav) => fav.id).contains(comma.id)) {
      return;
    }
    favoritedCommas.removeWhere((fav) => fav.id == comma.id);

    await _setValue(kFavoriteCommasCollectionKey, json.encode(favoritedCommas));

    final commas = [..._commaStreamController.value];
    int toDesfavoriteCommaIndex =
        commas.indexWhere((fav) => fav.id == comma.id);
    commas[toDesfavoriteCommaIndex] = comma.copyWith(favorite: false);
    _commaStreamController.add(commas);
  }

  @override
  Future<void> favorite(String userId, Comma comma) async {
    final List<Comma> favoritedCommas = loadFavoritedCommas();

    if (favoritedCommas.map((fav) => fav.id).contains(comma.id)) {
      return;
    }

    final commas = [..._commaStreamController.value];

    int toFavoriteIndex = commas.indexWhere((nonFav) => nonFav.id == comma.id);

    commas[toFavoriteIndex] = comma.copyWith(favorite: true);

    final newFavCommas = [...favoritedCommas];
    newFavCommas.add(commas[toFavoriteIndex]);
    await _setValue(kFavoriteCommasCollectionKey, json.encode(newFavCommas));

    _commaStreamController.add(commas);
  }

  List<Comma> loadFavoritedCommas() {
    final commasJson = _getValue(kFavoriteCommasCollectionKey);

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
