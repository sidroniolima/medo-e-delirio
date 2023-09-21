import 'package:audio_repository/src/api/audio_api.dart';

import 'models/models.dart';

class AudioRepository {
  final AudioApi _audioApi;

  AudioRepository({required AudioApi audioApi}) : _audioApi = audioApi;

  Future<List<Comma>> fetchCommas() async {
    return await _audioApi.fetchCommas();
  }

  Future<void> favorite(Comma comma) async {
    return await _audioApi.favoriteComma(comma);
  }

  Future<List<Comma>> getFavoriteCommas() async {
    return await _audioApi.getFavoritedCommas();
  }
}
