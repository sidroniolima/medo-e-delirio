import 'package:medo_e_delirio_app/models/audio.dart';
import 'package:medo_e_delirio_app/networking/AudioService.dart';
import 'package:flutter/foundation.dart';

class AudioListViewModel extends ChangeNotifier {
  List<Audio> audios = [];

  Future<void> fetchMovies(String keyword) async {
    final results = await Webservice().fetchAudios();
    this.audios = results;
    print(this.audios);
    notifyListeners();
  }
}
