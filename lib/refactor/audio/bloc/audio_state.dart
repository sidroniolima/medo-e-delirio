part of 'audio_bloc.dart';

enum AudioStatus { initial, loading, success, failure }

extension AudioStatusX on AudioStatus {
  bool get isInitial => this == AudioStatus.initial;
  bool get isLoading => this == AudioStatus.loading;
  bool get isSuccess => this == AudioStatus.success;
  bool get isFailure => this == AudioStatus.failure;
}

final class AudioState extends Equatable {
  final List<Comma> commas;
  final AudioStatus status;

  const AudioState({this.commas = const [], this.status = AudioStatus.initial});

  AudioState copyWith({List<Comma>? commas, AudioStatus? status}) {
    return AudioState(
        commas: commas ?? this.commas, status: status ?? this.status);
  }

  @override
  List<Object> get props => [commas, status];
}
