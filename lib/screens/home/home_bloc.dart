import 'dart:async';

import 'package:medo_e_delirio_app/screens/home/home_model.dart';

import '../../models/audio.dart';

class HomeBloc {
  final List<Audio> audios;
  HomeModel _model = HomeModel();

  HomeBloc({required this.audios}) {
    this._model = HomeModel(audios: audios, audiosOriginalList: audios);
  }

  StreamController<HomeModel> _modelController = StreamController<HomeModel>();

  Stream<HomeModel> get modelStream => _modelController.stream;

  void dispose() {
    _modelController.close();
  }

  void _updateWith(
      {bool? isLoading,
      List<Audio>? audios,
      String? search,
      List<Audio>? audiosOriginalList}) {
    _model = _model.copyWith(
        isLoading: isLoading,
        audios: audios,
        search: search,
        audiosOriginalList: audiosOriginalList);

    _modelController.add(_model);
  }

  Future<void> refreshAudios() async {
    this._updateWith(
        isLoading: false,
        audios: [...this._model.audiosOriginalList],
        search: null);
  }

  Future<void> search(String search) async {
    this._updateWith(
        isLoading: true,
        search: search);

    if (this._model.audios.isEmpty) {
      this._updateWith(
          audios: [...this._model.audiosOriginalList]);
    }

    List<Audio> originals = [...this._model.audiosOriginalList];

    List<Audio> finds = originals
        .where((audio) =>
            audio.label
                .toString()
                .toUpperCase()
                .contains(search.toUpperCase()) ||
            audio.author
                .toString()
                .toUpperCase()
                .contains(search.toUpperCase()))
        .toList();

    print('achou ${finds.length}');

    this._updateWith(audios: [...finds], isLoading: false, search: search);
  }
}
