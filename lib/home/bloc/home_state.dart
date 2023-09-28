part of 'home_bloc.dart';

enum HomeStatus { initial, loading, success, failure }

extension HomeStatusX on HomeStatus {
  bool get isInitial => this == HomeStatus.initial;
  bool get isLoading => this == HomeStatus.loading;
  bool get isSuccess => this == HomeStatus.success;
  bool get isFailure => this == HomeStatus.failure;
}

final class HomeState extends Equatable {
  final List<Comma> commas;
  final HomeStatus status;
  final bool showPlayer;

  const HomeState(
      {this.commas = const [],
      this.status = HomeStatus.initial,
      this.showPlayer = false});

  HomeState copyWith(
      {List<Comma>? commas, HomeStatus? status, bool? showPlayer}) {
    return HomeState(
        commas: commas ?? this.commas,
        status: status ?? this.status,
        showPlayer: showPlayer ?? this.showPlayer);
  }

  @override
  List<Object> get props => [commas, status, showPlayer];
}
