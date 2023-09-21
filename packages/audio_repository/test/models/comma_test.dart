import 'package:audio_repository/src/models/models.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('comma ...', () {
    group('from json', () {
      test('returns correct Comma object', () {
        expect(
            Comma.fromJson(<String, dynamic>{
              'id': 1126,
              'fileName': 'lula-passarinhos.mpga',
              'author': 'Lula',
              'label': 'Ó o passarim cantando',
              'type': 'INSERT',
              'date': '2023-07-12T00:00:00.000'
            }),
            isA<Comma>()
                .having((w) => w.id, 'id', 1126)
                .having((w) => w.fileName, 'fileName', 'lula-passarinhos.mpga')
                .having((w) => w.author, 'author', 'Lula')
                .having((w) => w.date, 'date',
                    DateTime.parse('2023-07-12T00:00:00.000'))
                .having((w) => w.label, 'label', 'Ó o passarim cantando')
                .having((w) => w.words, 'words', '')
                .having((w) => w.type, 'type', 'INSERT'));
      });
    });
  });
}
