import 'package:comma_api/comma_api.dart';

extension Query on String {
  bool apply(Comma comma) {
    return comma.author.toLowerCase().contains(this.toLowerCase()) ||
        comma.label.toLowerCase().contains(this.toLowerCase());
  }

  Iterable<Comma> applyAll(Iterable<Comma> commas) {
    return commas.where(apply);
  }
}
