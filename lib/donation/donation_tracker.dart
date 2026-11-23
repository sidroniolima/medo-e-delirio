import 'package:firebase_analytics/firebase_analytics.dart';

/// Where the donation dialog was opened from.
enum DonationSource { appBar, prompt }

/// Analytics events for the donation funnel. The payment itself happens in
/// the bank app, so copying the PIX code is the closest signal we get.
class DonationTracker {
  DonationTracker({FirebaseAnalytics? analytics}) : _analytics = analytics;

  final FirebaseAnalytics? _analytics;

  FirebaseAnalytics get _instance => _analytics ?? FirebaseAnalytics.instance;

  Future<void> dialogOpened(DonationSource source) =>
      _log('donation_dialog_opened', {'source': source.name});

  /// [amount] is 0 when the payer chooses the value in the bank app.
  Future<void> pixCopied(double amount, DonationSource source) => _log(
      'donation_pix_copied', {'amount': amount.round(), 'source': source.name});

  Future<void> promptShown() => _log('donation_prompt_shown', {});

  Future<void> promptDismissed() => _log('donation_prompt_dismissed', {});

  Future<void> _log(String name, Map<String, Object> parameters) async {
    try {
      await _instance.logEvent(name: name, parameters: parameters);
    } catch (_) {
      // Analytics must never break the donation flow.
    }
  }
}
