import 'audio.dart';

abstract class Playlist {
  String get name;

  Future<List<Audio>> load()  async {
    await Future.delayed(Duration(seconds: 1));
    return []..addAll(Audio.inserts);
  }

}