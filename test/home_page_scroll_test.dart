import 'package:audio_repository/audio_repository.dart';
import 'package:comma_api/comma_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medo_e_delirio_app/donation/donation.dart';
import 'package:medo_e_delirio_app/home/view/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _FakeCommaApi implements CommaApi {
  @override
  Stream<List<Comma>> getCommas() => Stream.value([
        for (var i = 0; i < 60; i++)
          Comma(
              id: i,
              fileName: '$i.mp3',
              author: 'Autor $i',
              label: 'Áudio número $i',
              type: i.isEven ? 'AUDIO' : 'MUSIC'),
      ]);

  @override
  Future<void> fetchCommas(int offset, int resultsForPage, String userId) =>
      Future.value();

  @override
  Future<void> favorite(String userId, Comma comma) => Future.value();

  @override
  Future<void> desfavorite(String userId, Comma comma) => Future.value();
}

void main() {
  for (final textScale in [1.0, 1.5]) {
    testWidgets('scrolls the whole list with text scale $textScale',
        (tester) async {
      tester.platformDispatcher.textScaleFactorTestValue = textScale;
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);

      // The banner is a network image, which always fails in tests.
      final onError = FlutterError.onError;
      FlutterError.onError = (details) {
        if (details.library == 'image resource service') return;
        onError?.call(details);
      };
      addTearDown(() => FlutterError.onError = onError);

      SharedPreferences.setMockInitialValues({});
      final preferences = await SharedPreferences.getInstance();

      await tester.pumpWidget(MultiRepositoryProvider(
        providers: [
          RepositoryProvider.value(
              value: AudioRepository(commaApi: _FakeCommaApi())),
          RepositoryProvider.value(value: DonationPrompt(plugin: preferences)),
        ],
        child: const MaterialApp(home: HomePage()),
      ));
      await tester.pump();

      expect(find.text('Áudio número 0'), findsOneWidget);

      final scrollable = find.byType(Scrollable).first;
      await tester.dragUntilVisible(
          find.text('Áudio número 59'), scrollable, const Offset(0, -400));
      await tester.pump();

      // Search stays visible under the collapsed bar and the end is reachable.
      expect(find.byType(TextField).hitTestable(), findsOneWidget);
      expect(find.text('Áudio número 59'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }
}
