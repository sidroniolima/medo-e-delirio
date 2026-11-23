part of 'player_cubit.dart';

enum PlayerStatus {
  loading,
  playing,
  paused,
  resumed,
  stopped,
  crashed,
}

/// Kept apart from [PlayerStatus] so sharing doesn't affect playback state.
enum ShareStatus { idle, sharingAudio, sharingVideo }

final class PlayerState extends Equatable {
  const PlayerState(
      {this.duration = Duration.zero,
      this.audio = Comma.empty,
      this.status = PlayerStatus.stopped,
      this.share = ShareStatus.idle});

  final Duration duration;
  final Comma audio;
  final PlayerStatus status;
  final ShareStatus share;

  PlayerState copyWith(
      {Duration? duration,
      Comma? audio,
      PlayerStatus? status,
      ShareStatus? share,
      bool? favorite}) {
    return PlayerState(
        duration: duration ?? this.duration,
        status: status ?? this.status,
        share: share ?? this.share,
        audio: audio ?? this.audio);
  }

  @override
  List<Object> get props => [duration, audio, status, share];
}
