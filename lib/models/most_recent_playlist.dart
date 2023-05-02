import 'package:medo_e_delirio_app/models/playlist.dart';

import 'audio.dart';

class MostRecentPlaylist extends Playlist {
  Future<List<Audio>> load() async {
    await Future.delayed(Duration(seconds: 1));
    Audio.inserts.sort((a, b) => a.date.compareTo(b.date));
    return []..addAll(Audio.inserts.sublist(0, 10));
  }

  @override
  String get name => 'Mais recentes';
}
