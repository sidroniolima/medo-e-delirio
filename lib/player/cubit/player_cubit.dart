import 'package:audio_repository/audio_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:just_audio/just_audio.dart';

part 'player_state.dart';

class PlayerCubit extends Cubit<PlayerState> {
  PlayerCubit({AudioPlayer? player})
      : _player = player ?? AudioPlayer(),
        super(PlayerState());

  final AudioPlayer _player;

  Future<void> play(Comma audio) async {
    try {
      if (state.status == PlayerStatus.paused) {
        emit(state.copyWith(status: PlayerStatus.playing));

        await _player.play();
      } else {
        emit(state.copyWith(audio: audio, status: PlayerStatus.loading));
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
}
