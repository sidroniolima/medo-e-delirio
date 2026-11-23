import 'package:flutter_test/flutter_test.dart';
import 'package:medo_e_delirio_app/donation/pix_payload.dart';

void main() {
  test('crc16 matches the CCITT-FALSE check value', () {
    expect(PixPayload.crc16('123456789'), '29B1');
  });

  test('crc16 matches the Banco Central BR Code example', () {
    const withoutCrc = '00020126580014br.gov.bcb.pix'
        '0136123e4567-e12b-12d1-a456-426655440000'
        '5204000053039865802BR5913Fulano de Tal6008BRASILIA'
        '62070503***6304';
    expect(PixPayload.crc16(withoutCrc), '1D3D');
  });

  test('builds a code with amount, sanitized name and city', () {
    final code = PixPayload(
      key: 'chave@exemplo.com',
      name: 'José da Silva',
      city: 'Brasília',
      amount: 10,
    ).toString();

    expect(code, startsWith('000201'));
    expect(code, contains('0014br.gov.bcb.pix0117chave@exemplo.com'));
    expect(code, contains('540510.00'));
    expect(code, contains('5913JOSE DA SILVA'));
    expect(code, contains('6008BRASILIA'));
    expect(code.substring(code.length - 8, code.length - 4), '6304');
    expect(code.substring(code.length - 4),
        PixPayload.crc16(code.substring(0, code.length - 4)));
  });

  test('omits the amount field for "outro valor"', () {
    final code = PixPayload(key: 'k', name: 'N', city: 'C').toString();
    expect(code, isNot(contains('5303986' '54')));
  });

  test('truncates name and city to the spec limits', () {
    final payload = PixPayload(
        key: 'k', name: 'A' * 40, city: 'Cidade Muito Comprida Demais');
    expect(payload.name.length, 25);
    expect(payload.city.length, 15);
  });
}
