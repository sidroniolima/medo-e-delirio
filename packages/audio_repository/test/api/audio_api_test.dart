import 'package:audio_repository/src/api/audio_api.dart';
import "package:audio_repository/src/models/models.dart";
import "package:http/http.dart" as http;
import "package:mocktail/mocktail.dart";
import "package:test/test.dart";

class MockHttpClient extends Mock implements http.Client {}

class MockResponse extends Mock implements http.Response {}

class FakeUri extends Fake implements Uri {}

class FaqueRequest extends Fake implements http.BaseRequest {}

void main() {
  group("MeuEspacoApiClient", () {
    const _defaultUrl = "sidroniolima.com.br";
    late AudioApi apiClient;
    late MockHttpClient mockHttpClient;

    setUpAll(() {
      registerFallbackValue(FakeUri());
      registerFallbackValue(FaqueRequest());
    });

    setUp(() {
      mockHttpClient = MockHttpClient();
      apiClient = AudioJsonApi(httpClient: mockHttpClient);
    });

    group("constructor", () {
      test("does not require ah httpClient", () {
        expect(AudioJsonApi(), isNotNull);
      });
    });

    group("Comma", () {
      test("makes correct http request", () async {
        get() => mockHttpClient.get(Uri.https(_defaultUrl, "/med/audios.json"));

        final response = MockResponse();
        when(() => response.statusCode).thenReturn(200);
        when(() => get()).thenAnswer((_) async => response);

        try {
          await apiClient.fetchCommas();
        } catch (_) {}

        verify(() => get()).called(1);
      });

      test("throw CommasRequestFailure on http response != 200", () async {
        get() => mockHttpClient.get(Uri.https(_defaultUrl, "/med/audios.json"));

        final response = MockResponse();
        when(() => response.statusCode).thenReturn(500);
        when(() => get()).thenAnswer((_) async => response);

        expect(() async => await apiClient.fetchCommas(),
            throwsA(isA<CommasRequestFailure>()));
      });

      test("returns List of Commas on valid response", () async {
        final response = MockResponse();

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

        final List<Comma> actual = await apiClient.fetchCommas();

        expect(
            actual.elementAt(0),
            isA<Comma>()
                .having((w) => w.id, "id", 1126)
                .having((w) => w.fileName, "fileName", "lula-passarinhos.mpga")
                .having((w) => w.author, "author", "Lula")
                .having((w) => w.createdAt, "createdAt",
                    DateTime.parse("2023-07-12T00:00:00.000"))
                .having((w) => w.label, "label", "Ó o passarim cantando")
                .having((w) => w.words, "words", null)
                .having((w) => w.type, "type", "INSERT"));
        expect(
            actual.elementAt(1),
            isA<Comma>()
                .having((w) => w.id, "id", 1127)
                .having((w) => w.fileName, "fileName", "defante_do_neida.mpga")
                .having((w) => w.author, "author", "Defante")
                .having((w) => w.createdAt, "createdAt",
                    DateTime.parse("2023-07-20T00:00:00.000"))
                .having((w) => w.label, "label", "Do neida")
                .having((w) => w.words, "words", "defante kuduro do neida")
                .having((w) => w.type, "type", "INSERT"));
      });
    });
  });
}
