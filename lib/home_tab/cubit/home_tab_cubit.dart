import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'home_tab_state.dart';

class HomeTabCubit extends Cubit<HomeTabState> {
  HomeTabCubit() : super(const HomeTabState());

  void setTab(HomeTab tab) => emit(HomeTabState(tab: tab));
}
