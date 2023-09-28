import 'dart:async';

import 'package:audio_repository/audio_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc({required AudioRepository audioRepository})
      : _audioRepository = audioRepository,
        super(const HomeState()) {
    on<HomeFetchAllRequested>(_onHomeFetchAllRequested);
    on<HomeFetchFavoritesRequested>(_onHomeFetchFavoritesRequested);
    on<HomeFavorited>(_onHomeFavorited);
    on<HomeShowPlayerRequested>(_onHomeShowPlayerRequested);
  }

  final AudioRepository _audioRepository;

  Future<void> _onHomeFetchAllRequested(
      HomeFetchAllRequested event, Emitter<HomeState> emit) async {
    emit(state.copyWith(status: HomeStatus.loading));

    try {
      final commas = await _audioRepository.fetchCommas();

      emit(state.copyWith(commas: commas, status: HomeStatus.success));
    } on Exception {
      emit(state.copyWith(status: HomeStatus.failure));
    }
  }

  Future<void> _onHomeFetchFavoritesRequested(
      HomeFetchFavoritesRequested event, Emitter<HomeState> emit) async {
    emit(state.copyWith(status: HomeStatus.loading));

    try {
      final commas = await _audioRepository.getFavoriteCommas();

      emit(state.copyWith(commas: commas, status: HomeStatus.success));
    } on Exception {
      emit(state.copyWith(status: HomeStatus.failure));
    }
  }

  FutureOr<void> _onHomeFavorited(
      HomeFavorited event, Emitter<HomeState> emit) async {
    try {
      await _audioRepository.favorite(event.comma);
      final commas = await _audioRepository.getFavoriteCommas();

      emit(state.copyWith(commas: commas, status: HomeStatus.success));
    } on Exception {
      emit(state.copyWith(status: HomeStatus.failure));
    }
  }

  Future<void> _onHomeShowPlayerRequested(
      HomeShowPlayerRequested event, Emitter<HomeState> emit) async {
    emit(state.copyWith(showPlayer: true, ));
  }
}
