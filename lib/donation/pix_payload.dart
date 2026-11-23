/// Builds a static PIX "copia e cola" code (BR Code), following the
/// Banco Central EMV QR Code spec. Works offline: no PSP or server involved.
class PixPayload {
  PixPayload({
    required this.key,
    required String name,
    required String city,
    this.amount,
    this.txid = '***',
  })  : name = _sanitize(name, 25),
        city = _sanitize(city, 15);

  final String key;
  final String name;
  final String city;

  /// In reais. Without it, the payer types the amount in the bank app.
  final double? amount;

  final String txid;

  @override
  String toString() {
    final payload = StringBuffer()
      ..write(_field('00', '01'))
      ..write(_field('26', _field('00', 'br.gov.bcb.pix') + _field('01', key)))
      ..write(_field('52', '0000'))
      ..write(_field('53', '986'))
      ..write(amount == null ? '' : _field('54', amount!.toStringAsFixed(2)))
      ..write(_field('58', 'BR'))
      ..write(_field('59', name))
      ..write(_field('60', city))
      ..write(_field('62', _field('05', txid)))
      ..write('6304');

    return '$payload${crc16(payload.toString())}';
  }

  static String _field(String id, String value) =>
      '$id${value.length.toString().padLeft(2, '0')}$value';

  /// Banks expect plain ASCII uppercase in name and city.
  static String _sanitize(String text, int maxLength) {
    const accents = 'ÁÀÂÃÄÉÈÊËÍÌÎÏÓÒÔÕÖÚÙÛÜÇÑ';
    const plain = 'AAAAAEEEEIIIIOOOOOUUUUCN';

    final upper = text.trim().toUpperCase();
    final buffer = StringBuffer();
    for (final char in upper.split('')) {
      final index = accents.indexOf(char);
      buffer.write(index == -1 ? char : plain[index]);
    }

    final result = buffer.toString();
    return result.length > maxLength ? result.substring(0, maxLength) : result;
  }

  /// CRC16-CCITT (polynomial 0x1021, initial 0xFFFF), as the spec requires.
  static String crc16(String data) {
    var crc = 0xFFFF;
    for (final byte in data.codeUnits) {
      crc ^= byte << 8;
      for (var i = 0; i < 8; i++) {
        crc = (crc & 0x8000) != 0 ? (crc << 1) ^ 0x1021 : crc << 1;
        crc &= 0xFFFF;
      }
    }
    return crc.toRadixString(16).toUpperCase().padLeft(4, '0');
  }
}
