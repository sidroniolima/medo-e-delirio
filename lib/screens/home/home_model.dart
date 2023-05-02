import '../../models/audio.dart';

class HomeModel {
  final bool isLoading;
  final List<Audio> audios;
  final List<Audio> audiosOriginalList;
  final String search;

  HomeModel({this.isLoading = false, this.audios = const [], this.search = '', this.audiosOriginalList = const []});

  HomeModel copyWith({bool? isLoading, List<Audio>? audios, String? search, List<Audio>? audiosOriginalList}) {
    return HomeModel(
        isLoading: isLoading ?? this.isLoading,
        audios: audios ?? this.audios,
        search: search ?? this.search,
        audiosOriginalList: audiosOriginalList ?? this.audiosOriginalList);
  }
}
