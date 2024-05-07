import 'package:comma_api/comma_api.dart';

enum HomeFilter { all, favorite, music }

extension HomeFilterX on HomeFilter {
  bool apply(Comma comma) {
    switch (this) {
      case HomeFilter.all:
        return true;
      case HomeFilter.favorite:
        return comma.favorite;
      case HomeFilter.music:
        return comma.type == 'MUSIC';
    }
  }

  Iterable<Comma> applyAll(Iterable<Comma> commas) {
    return commas.where(apply);
  }
}
