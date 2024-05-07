import 'package:medo_e_delirio_app/models/playlist.dart';

import '../../models/audio.dart';

class Player {
  final Playlist _playlist;

  Player(this._playlist);

  void play(Audio audio) {
    print('Playind audio ${audio.label}...');
  }
}
