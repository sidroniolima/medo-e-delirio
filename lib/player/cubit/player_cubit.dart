import 'dart:io';
import 'dart:typed_data';

import 'package:audio_repository/audio_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:just_audio/just_audio.dart';
import 'package:share_plus/share_plus.dart';

import 'package:path_provider/path_provider.dart';

part 'player_state.dart';

class PlayerCubit extends Cubit<PlayerState> {
  PlayerCubit({required AudioRepository audioRepository, AudioPlayer? player})
      : _player = player ?? AudioPlayer(),
        _audioRepository = audioRepository,
        super(PlayerState());

  final AudioPlayer _player;
  final AudioRepository _audioRepository;

  Future<void> toggleFavorite(String userId, Comma comma) async {
    await this._audioRepository.toggleFavorite(userId, comma);
    emit(state.copyWith(audio: comma.copyWith(favorite: !comma.favorite)));
  }

  Future<void> play(Comma audio) async {
    try {
      if (state.status == PlayerStatus.paused && state.audio == audio) {
        emit(state.copyWith(status: PlayerStatus.playing));

        await _player.play();
      } else {
        emit(state.copyWith(
            audio: audio,
            status: PlayerStatus.loading,
            favorite: audio.favorite));

        await _player
            .setUrl('https://sidroniolima.com.br/med/mp3/${audio.fileName}');

        emit(state.copyWith(status: PlayerStatus.playing));

        await _player.play();
      }

      _player.playerStateStream.listen((playerState) {
        if (playerState.processingState == ProcessingState.completed) {
          emit(state.copyWith(status: PlayerStatus.stopped));
        }
      });
    } catch (ex) {
      emit(state.copyWith(status: PlayerStatus.crashed));
    }
  }

  void pause() async {
    try {
      if (_player.playerState.playing) {
        _player.pause();
        emit(state.copyWith(status: PlayerStatus.paused));
      }
    } catch (ex) {
      emit(state.copyWith(status: PlayerStatus.crashed));
    }
  }

  void playSelected() async {
    if (state.audio == Comma.empty) {
      return emit(state.copyWith(status: PlayerStatus.crashed));
    }

    try {
      emit(state.copyWith(status: PlayerStatus.loading));
      await _player.setUrl(
          'https://sidroniolima.com.br/med/mp3/${state.audio.fileName}');

      emit(state.copyWith(status: PlayerStatus.playing));

      await _player.play();
      emit(state.copyWith(status: PlayerStatus.stopped));
    } catch (_) {
      emit(state.copyWith(status: PlayerStatus.crashed));
    }
  }

  Future<void> shareSelected() async {
    try {
      emit(state.copyWith(status: PlayerStatus.sharing));

      Uint8List bytes = await http.readBytes(
          Uri.https('sidroniolima.com.br', '/med/mp3/${state.audio.fileName}'));

      final temp = await getTemporaryDirectory();

      final path = '${temp.path}/${state.audio.fileName}';

      File(path).writeAsBytesSync(bytes);

      await Share.shareXFiles([XFile(path)]);

      emit(state.copyWith(status: PlayerStatus.shared));
    } catch (_) {
      emit(state.copyWith(status: PlayerStatus.crashed));
    }
  }
}
