import 'package:comma_api/comma_api.dart';

const _accents = 'áàâãäéèêëíìîïóòôõöúùûüçñ';
const _plain = 'aaaaaeeeeiiiiooooouuuucn';

/// Lowercases and strips accents, so "delirio" matches "Delírio".
String normalize(String text) {
  final lower = text.toLowerCase();
  final buffer = StringBuffer();

  for (final char in lower.split('')) {
    final index = _accents.indexOf(char);
    buffer.write(index == -1 ? char : _plain[index]);
  }

  return buffer.toString();
}

extension Query on String {
  bool apply(Comma comma) {
    final query = normalize(this.trim());

    return normalize(comma.author).contains(query) ||
        normalize(comma.label).contains(query);
  }

  Iterable<Comma> applyAll(Iterable<Comma> commas) {
    return commas.where(apply);
  }
}
