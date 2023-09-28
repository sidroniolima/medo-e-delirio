import "dart:convert";

import 'package:audio_repository/src/api/audio_api.dart';
import "package:audio_repository/src/models/models.dart";
import "package:http/http.dart" as http;
import "package:mocktail/mocktail.dart";
import "package:shared_preferences/shared_preferences.dart";
import "package:test/test.dart";

class MockHttpClient extends Mock implements http.Client {}

class MockResponse extends Mock implements http.Response {}

class FakeUri extends Fake implements Uri {}

class FaqueRequest extends Fake implements http.BaseRequest {}

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  group("MeuEspacoApiClient", () {
    const _defaultUrl = "sidroniolima.com.br";

    late MockHttpClient mockHttpClient;
    late SharedPreferences plugin;

    final commas = [
      Comma(
          id: 1126,
          fileName: 'lula-passarinhos.mpga',
          author: 'Lula',
          label: 'Ó o passarim cantando',
          type: 'INSERT',
          date: '2023-07-12T00:00:00.000'),
      Comma(
          id: 1127,
          fileName: 'xo_drogado.mpga',
          author: '',
          label: 'Xô drogado',
          type: 'INSERT',
          words: 'xo drogrado',
          date: '2022-01-31T00:00:00.000'),
    ];

    setUpAll(() {
      registerFallbackValue(FakeUri());
      registerFallbackValue(FaqueRequest());
    });

    setUp(() {
      plugin = MockSharedPreferences();
      mockHttpClient = MockHttpClient();

      when(() => plugin.getString(any())).thenReturn(json.encode(commas));
      when(() => plugin.setString(any(), any())).thenAnswer((_) async => true);
    });

    AudioApi createSubject() {
      return AudioJsonApi(httpClient: mockHttpClient, plugin: plugin);
    }

    group("constructor", () {
      test("does not require a httpClient", () {
        expect(AudioJsonApi(plugin: plugin), isNotNull);
      });
    });

    group("Comma", () {
      group('favorites', () {
        test('should get favorites saved commas', () async {
          final subject = createSubject();

          List<Comma> favorites = await subject.getFavoritedCommas();

          expect(favorites, commas);

          verify(() =>
                  plugin.getString(AudioJsonApi.kFavoriteCommasCollectionKey))
              .called(1);
        });

        test('should save a favorite comma', () async {
          final subject = createSubject();

          final finalToFavorite = Comma(
              id: 666,
              fileName: 'sai.mpga',
              author: '',
              label: 'Sai, Alexandre de Moraes',
              type: 'INSERT',
              words: 'xandao',
              date: '2023-01-31T00:00:00.000');

          await subject.favoriteComma(finalToFavorite);

          verify(() => plugin.setString(
              AudioJsonApi.kFavoriteCommasCollectionKey,
              json.encode([...commas, finalToFavorite]))).called(1);
        });
      });

      test("makes correct http request", () async {
        final subject = createSubject();

        get() => mockHttpClient.get(Uri.https(_defaultUrl, "/med/audios.json"));

        final response = MockResponse();
        when(() => response.statusCode).thenReturn(200);
        when(() => get()).thenAnswer((_) async => response);

        try {
          await subject.fetchCommas();
        } catch (_) {}

        verify(() => get()).called(1);
      });

      test("throw CommasRequestFailure on http response != 200", () async {
        final subject = createSubject();

        get() => mockHttpClient.get(Uri.https(_defaultUrl, "/med/audios.json"));

        final response = MockResponse();
        when(() => response.statusCode).thenReturn(500);
        when(() => get()).thenAnswer((_) async => response);

        expect(() async => await subject.fetchCommas(),
            throwsA(isA<CommasRequestFailure>()));
      });

      test("returns List of Commas on valid response", () async {
        final response = MockResponse();
        final subject = createSubject();

        when(() => response.statusCode).thenReturn(200);
        when(() => response.body).thenReturn(
          """
[
	{
              "id": 1126,
              "fileName": "lula-passarinhos.mpga",
              "author": "Lula",
              "label": "Ó o passarim cantando",
              "type": "INSERT",
              "date": "2023-07-12T00:00:00.000"
	},
	{
              "id": 1127,
              "fileName": "defante_do_neida.mpga",
              "author": "Defante",
              "label": "Do neida",
              "type": "INSERT",
              "words": "defante kuduro do neida",
              "date": "2023-07-20T00:00:00.000"
	}
]""",
        );
        when(() => mockHttpClient.get(any())).thenAnswer((_) async => response);

        final List<Comma> actual = await subject.fetchCommas();

        expect(
            actual.elementAt(1),
            isA<Comma>()
                .having((w) => w.id, "id", 1126)
                .having((w) => w.fileName, "fileName", "lula-passarinhos.mpga")
                .having((w) => w.author, "author", "Lula")
                .having((w) => w.date, "createdAt", "2023-07-12T00:00:00.000")
                .having((w) => w.label, "label", "Ó o passarim cantando")
                .having((w) => w.words, "words", '')
                .having((w) => w.type, "type", "INSERT"));
        expect(
            actual.elementAt(0),
            isA<Comma>()
                .having((w) => w.id, "id", 1127)
                .having((w) => w.fileName, "fileName", "defante_do_neida.mpga")
                .having((w) => w.author, "author", "Defante")
                .having((w) => w.date, "createdAt", "2023-07-20T00:00:00.000")
                .having((w) => w.label, "label", "Do neida")
                .having((w) => w.words, "words", "defante kuduro do neida")
                .having((w) => w.type, "type", "INSERT"));
      });
    });
  });
}
