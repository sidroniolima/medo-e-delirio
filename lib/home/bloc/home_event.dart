part of 'home_bloc.dart';

sealed class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

final class HomeFetchAllRequested extends HomeEvent {}

final class HomeFetchFavoritesRequested extends HomeEvent {}

final class HomeFavorited extends HomeEvent {
  final Comma comma;

  HomeFavorited({required this.comma});

  @override
  List<Object> get props => [comma];
}

final class HomeShowPlayerRequested extends HomeEvent {
  final Comma comma;

  HomeShowPlayerRequested({required this.comma});

  @override
  List<Object> get props => [comma];
}
