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

  const HomeState({this.commas = const [], this.status = HomeStatus.initial});

  HomeState copyWith({List<Comma>? commas, HomeStatus? status}) {
    return HomeState(
        commas: commas ?? this.commas, status: status ?? this.status);
  }

  @override
  List<Object> get props => [commas, status];
}
