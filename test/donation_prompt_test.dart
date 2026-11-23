import 'package:flutter_test/flutter_test.dart';
import 'package:medo_e_delirio_app/donation/donation.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late DateTime now;

  Future<DonationPrompt> prompt() async {
    SharedPreferences.setMockInitialValues({});
    return DonationPrompt(
        plugin: await SharedPreferences.getInstance(), now: () => now);
  }

  setUp(() => now = DateTime(2026, 11, 20));

  // These rules only apply once DonationConfig has name and city.
  final skip = DonationConfig.isReady ? false : 'DonationConfig not filled';

  test('asks only after enough shares', () async {
    final p = await prompt();
    for (var i = 1; i < DonationConfig.sharesBeforeAsking; i++) {
      await p.registerShare();
    }
    expect(p.shouldAsk, isFalse);

    await p.registerShare();
    expect(p.shouldAsk, isTrue);
  }, skip: skip);

  test('asks only after enough plays', () async {
    final p = await prompt();
    for (var i = 0; i < DonationConfig.playsBeforeAsking; i++) {
      await p.registerPlay();
    }
    expect(p.shouldAsk, isTrue);
  }, skip: skip);

  test('waits the snooze period after being dismissed', () async {
    final p = await prompt();
    for (var i = 0; i < DonationConfig.sharesBeforeAsking; i++) {
      await p.registerShare();
    }
    await p.snoozeAfterDismiss();
    expect(p.shouldAsk, isFalse);

    now = now.add(Duration(days: DonationConfig.daysAfterDismiss + 1));
    expect(p.shouldAsk, isTrue);
  }, skip: skip);

  test('waits longer after a donation', () async {
    final p = await prompt();
    for (var i = 0; i < DonationConfig.sharesBeforeAsking; i++) {
      await p.registerShare();
    }
    await p.snoozeAfterDonation();

    now = now.add(Duration(days: DonationConfig.daysAfterDismiss + 1));
    expect(p.shouldAsk, isFalse);

    now = now.add(Duration(days: DonationConfig.daysAfterDonation));
    expect(p.shouldAsk, isTrue);
  }, skip: skip);

  test('never asks while DonationConfig is not filled', () async {
    final p = await prompt();
    for (var i = 0; i < DonationConfig.sharesBeforeAsking; i++) {
      await p.registerShare();
    }
    expect(p.shouldAsk, DonationConfig.isReady);
  });

  test('default and prompt amounts are among the offered amounts', () {
    expect(DonationConfig.amounts, contains(DonationConfig.defaultAmount));
    expect(DonationConfig.amounts, contains(DonationConfig.promptAmount));
  });
}
