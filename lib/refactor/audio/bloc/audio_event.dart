part of 'audio_bloc.dart';

sealed class AudioEvent extends Equatable {
  const AudioEvent();

  @override
  List<Object> get props => [];
}

final class AudioFetchAllRequested extends AudioEvent {}

final class AudioFetchFavoritesRequested extends AudioEvent {}

final class AudioFavorited extends AudioEvent {
  final Comma audio;

  AudioFavorited(this.audio);
}
