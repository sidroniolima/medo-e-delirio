part of 'home_bloc.dart';

enum HomeStatus { initial, loading, success, failure }

extension HomeStatusX on HomeStatus {
  bool get isInitial => this == HomeStatus.initial;
  bool get isLoading => this == HomeStatus.loading;
  bool get isSuccess => this == HomeStatus.success;
  bool get isFailure => this == HomeStatus.failure;
}

final class HomeState extends Equatable {
  final List<Comma> audios;
  final HomeStatus status;
  final bool showPlayer;
  final HomeFilter filter;
  final String query;

  const HomeState(
      {this.audios = const [],
      this.status = HomeStatus.initial,
      this.showPlayer = false,
      this.filter = HomeFilter.all,
      this.query = ''});

  Iterable<Comma> get filteredAudios => query.applyAll(filter.applyAll(audios));

  HomeState copyWith(
      {List<Comma>? audios,
      HomeStatus? status,
      bool? showPlayer,
      HomeFilter? filter,
      String? query}) {
    return HomeState(
        audios: audios ?? this.audios,
        status: status ?? this.status,
        showPlayer: showPlayer ?? this.showPlayer,
        filter: filter ?? this.filter,
        query: query ?? this.query);
  }

  @override
  List<Object> get props => [audios, status, showPlayer, filter, query];
}
