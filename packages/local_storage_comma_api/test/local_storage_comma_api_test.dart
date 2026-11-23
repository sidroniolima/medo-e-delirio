import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:local_storage_comma_api/local_storage_comma_api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test/test.dart';

const _catalog = [
  {
    'id': 1,
    'fileName': 'a.mp3',
    'author': 'Autor',
    'label': 'Um',
    'type': 'AUDIO'
  },
  {
    'id': 2,
    'fileName': 'b.mp3',
    'author': 'Autor',
    'label': 'Dois',
    'type': 'MUSIC'
  },
];

final _online = MockClient((_) async => http.Response.bytes(
    utf8.encode(jsonEncode(_catalog)), 200,
    headers: {'content-type': 'application/json; charset=utf-8'}));

final _offline =
    MockClient((_) async => throw http.ClientException('sem internet'));

Future<LocalStorageCommaApi> _api(http.Client client) async =>
    LocalStorageCommaApiFactory().initiate(
        plugin: await SharedPreferences.getInstance(), httpClient: client);

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  test('saves the catalog to cache when online', () async {
    final api = await _api(_online);

    expect((await api.getCommas().first).map((c) => c.id), [2, 1]);

    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getString(LocalStorageCommaApi.kCachedCommasKey), isNotNull);
  });

  test('emits the cached catalog when offline', () async {
    SharedPreferences.setMockInitialValues(
        {LocalStorageCommaApi.kCachedCommasKey: jsonEncode(_catalog)});

    final api = await _api(_offline);

    expect((await api.getCommas().first).map((c) => c.id), [2, 1]);
  });

  test('emits an error when offline without cache', () async {
    final api = await _api(_offline);

    await expectLater(api.getCommas().first, throwsA(isA<Exception>()));
  });

  test('keeps favorites when loading from cache', () async {
    SharedPreferences.setMockInitialValues({
      LocalStorageCommaApi.kCachedCommasKey: jsonEncode(_catalog),
      LocalStorageCommaApi.kFavoriteCommasCollectionKey: jsonEncode([_catalog[0]]),
    });

    final api = await _api(_offline);
    final commas = await api.getCommas().first;

    expect(commas.firstWhere((c) => c.id == 1).favorite, isTrue);
    expect(commas.firstWhere((c) => c.id == 2).favorite, isFalse);
  });
}
