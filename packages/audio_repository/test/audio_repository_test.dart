import 'package:audio_repository/audio_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockAudioApiClient extends Mock implements AudioApi {}

class FakeComma extends Fake implements Comma {}

void main() {
  group('AudioRepository', () {
    late AudioApi audioApiClient;
    late AudioRepository audioRepo;

    setUpAll(() {
      registerFallbackValue(FakeComma());
    });

    setUp(() {
      audioApiClient = MockAudioApiClient();
      audioRepo = AudioRepository(audioApi: audioApiClient);
    });

    group('constructor', () {
      test('works properly', () {
        expect(audioRepo, isNotNull);
      });
    });

    group('fetchCommas', () {
      test('calls API correctly', () async {
        when(() => audioApiClient.fetchCommas()).thenAnswer((_) async {
          return [];
        });

        await audioRepo.fetchCommas();

        verify(() => audioApiClient.fetchCommas()).called(1);
      });
    });

    group('favorite', () {
      final comma = Comma(
          id: 1,
          fileName: 'name.mp3',
          author: 'Lula',
          label: 'Olha o passarinho',
          type: 'INSERT');

      test('calls API correctly', () async {
        when(() => audioApiClient.favoriteComma(any()))
            .thenAnswer((_) async {});

        await audioRepo.favorite(comma);

        verify(() => audioApiClient.favoriteComma(any())).called(1);
      });
    });

    group('getFavoritedCommas', () {
      final comma = Comma(
          id: 1,
          fileName: 'name.mp3',
          author: 'Lula',
          label: 'Olha o passarinho',
          type: 'INSERT');

      final List<Comma> favoritedCommas = [comma];

      test('calls API correctly', () async {
        when(() => audioApiClient.getFavoritedCommas())
            .thenAnswer((_) async => favoritedCommas);

        List<Comma> actual = await audioRepo.getFavoriteCommas();

        verify(() => audioApiClient.getFavoritedCommas()).called(1);
        expect(actual, favoritedCommas);
      });
    });
  });
}
