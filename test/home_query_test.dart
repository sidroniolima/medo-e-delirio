import 'package:comma_api/comma_api.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medo_e_delirio_app/home/models/home_query.dart';

const _comma = Comma(
    id: 1,
    fileName: 'a.mp3',
    author: 'Damares',
    label: 'Medo e Delírio em Brasília',
    type: 'AUDIO');

void main() {
  test('ignores accents and case', () {
    expect('delirio'.apply(_comma), isTrue);
    expect('BRASÍLIA'.apply(_comma), isTrue);
    expect('damáres'.apply(_comma), isTrue);
  });

  test('ignores surrounding spaces', () {
    expect('  medo '.apply(_comma), isTrue);
  });

  test('does not match unrelated text', () {
    expect('cloroquina'.apply(_comma), isFalse);
  });
}
