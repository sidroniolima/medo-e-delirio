part of 'player_cubit.dart';

enum PlayerStatus { loading, playing, paused, resumed, stopped, crashed }

final class PlayerState extends Equatable {
  const PlayerState(
      {this.duration = Duration.zero,
      this.audio = Comma.empty,
      this.status = PlayerStatus.stopped});

  final Duration duration;
  final Comma audio;
  final PlayerStatus status;

  PlayerState copyWith(
      {Duration? duration, Comma? audio, PlayerStatus? status}) {
    return PlayerState(
        duration: duration ?? this.duration,
        status: status ?? this.status,
        audio: audio ?? this.audio);
  }

  @override
  List<Object> get props => [duration, audio, status];
}
