part of 'home_bloc.dart';

sealed class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

final class HomeSubscriptionRequested extends HomeEvent {}

final class HomeFilterChanged extends HomeEvent {
  final HomeFilter filter;

  HomeFilterChanged({required this.filter});

  @override
  List<Object> get props => [filter];
}

final class HomeQueryChanged extends HomeEvent {
  final String query;

  HomeQueryChanged({required this.query});

  @override
  List<Object> get props => [query];
}

final class HomeFavoriteToggled extends HomeEvent {
  final Comma comma;

  HomeFavoriteToggled({required this.comma});

  @override
  List<Object> get props => [comma];
}

final class HomeShowPlayerRequested extends HomeEvent {
  final Comma comma;

  HomeShowPlayerRequested({required this.comma});

  @override
  List<Object> get props => [comma];
}
