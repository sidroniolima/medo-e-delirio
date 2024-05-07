part of 'home_tab_cubit.dart';

enum HomeTab { all, favorite, music }

final class HomeTabState extends Equatable {
  const HomeTabState({this.tab = HomeTab.all});

  final HomeTab tab;

  @override
  List<Object> get props => [tab];
}
