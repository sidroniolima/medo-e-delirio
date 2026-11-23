/// Who receives the donations. Name and city show up in the payer's bank
/// app before confirming, so they must match the PIX key owner.
class DonationConfig {
  static const pixKey = '77d6aecd-f99f-45a3-8852-9d9b91de1f9d';

  static const receiverName = 'Sidronio Lima da Silva';
  static const receiverCity = 'Nova Friburgo';

  /// Suggested amounts, in reais.
  static const amounts = [5.0, 10.0, 20.0, 50.0, 100.0];

  /// Amount pre-selected when the dialog opens, and the one the prompt asks for.
  static const defaultAmount = 20.0;
  static const promptAmount = 10.0;

  /// Ask for a donation after this many finished shares or plays.
  static const sharesBeforeAsking = 10;
  static const playsBeforeAsking = 20;

  /// Days to wait before asking again.
  static const daysAfterDismiss = 20;
  static const daysAfterDonation = 30;

  static bool get isReady => receiverName.isNotEmpty && receiverCity.isNotEmpty;
}
