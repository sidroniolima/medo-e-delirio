import 'dart:async';

import 'package:audio_repository/audio_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'audio_event.dart';
part 'audio_state.dart';

class AudioBloc extends Bloc<AudioEvent, AudioState> {
  AudioBloc({required AudioRepository audioRepository})
      : _audioRepository = audioRepository,
        super(const AudioState()) {
    on<AudioFetchAllRequested>(_onAudioFetchAllRequested);
    on<AudioFetchFavoritesRequested>(_onAudioFetchFavoritesRequested);
    on<AudioFavorited>(_onAudioFavorited);
  }

  final AudioRepository _audioRepository;

  Future<void> _onAudioFetchAllRequested(
      AudioFetchAllRequested event, Emitter<AudioState> emit) async {
    emit(state.copyWith(status: AudioStatus.loading));

    try {
      final commas = await _audioRepository.fetchCommas();

      emit(state.copyWith(commas: commas, status: AudioStatus.success));
    } on Exception {
      emit(state.copyWith(status: AudioStatus.failure));
    }
  }

  FutureOr<void> _onAudioFetchFavoritesRequested(
      AudioFetchFavoritesRequested event, Emitter<AudioState> emit) {}

  FutureOr<void> _onAudioFavorited(
      AudioFavorited event, Emitter<AudioState> emit) {}
}
