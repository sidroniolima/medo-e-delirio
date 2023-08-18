import 'package:audio_repository/src/api/audio_api.dart';

import 'models/models.dart';

class AudioRepository {
  final AudioApi audioApi;

  AudioRepository(this.audioApi);

  Future<List<Comma>> fetchCommas() async {
    return await this.audioApi.fetchCommas();
  }
}
