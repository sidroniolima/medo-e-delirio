import 'package:shared_preferences/shared_preferences.dart';

import 'donation_config.dart';

/// Decides when to ask for a donation: after enough engagement, and never
/// again until the snooze period is over.
class DonationPrompt {
  DonationPrompt({required SharedPreferences plugin, DateTime Function()? now})
      : _plugin = plugin,
        _now = now ?? DateTime.now;

  final SharedPreferences _plugin;
  final DateTime Function() _now;

  static const kSharesKey = '__donation_shares_count';
  static const kPlaysKey = '__donation_plays_count';
  static const kSnoozedUntilKey = '__donation_snoozed_until';

  int get shares => _plugin.getInt(kSharesKey) ?? 0;
  int get plays => _plugin.getInt(kPlaysKey) ?? 0;

  Future<void> registerShare() => _plugin.setInt(kSharesKey, shares + 1);
  Future<void> registerPlay() => _plugin.setInt(kPlaysKey, plays + 1);

  bool get shouldAsk {
    if (!DonationConfig.isReady) return false;

    final snoozedUntil = _plugin.getInt(kSnoozedUntilKey);
    if (snoozedUntil != null &&
        _now().isBefore(DateTime.fromMillisecondsSinceEpoch(snoozedUntil))) {
      return false;
    }

    return shares >= DonationConfig.sharesBeforeAsking ||
        plays >= DonationConfig.playsBeforeAsking;
  }

  /// Called whenever the prompt is shown, so it never shows twice in a row.
  Future<void> snoozeAfterDismiss() =>
      _snooze(Duration(days: DonationConfig.daysAfterDismiss));

  /// Called when a PIX code is copied: the person likely donated.
  Future<void> snoozeAfterDonation() =>
      _snooze(Duration(days: DonationConfig.daysAfterDonation));

  Future<void> _snooze(Duration duration) => _plugin.setInt(
      kSnoozedUntilKey, _now().add(duration).millisecondsSinceEpoch);
}
