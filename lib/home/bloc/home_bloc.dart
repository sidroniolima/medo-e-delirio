import 'dart:async';

import 'package:audio_repository/audio_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:medo_e_delirio_app/home/models/home_query.dart';

import '../models/models.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc({required AudioRepository audioRepository})
      : _audioRepository = audioRepository,
        super(const HomeState()) {
    on<HomeSubscriptionRequested>(_onHomeSubscriptionRequested);
    on<HomeRetryRequested>(_onHomeRetryRequested);
    on<HomeFilterChanged>(_onHomeFilterChanged);
    on<HomeQueryChanged>(_onHomeQueryChanged);
    on<HomeFavoriteToggled>(_onHomeFavoriteToggled);
    on<HomeShowPlayerRequested>(_onHomeShowPlayerRequested);
  }

  final AudioRepository _audioRepository;

  void _onHomeQueryChanged(HomeQueryChanged event, Emitter<HomeState> emit) {
    emit(state.copyWith(query: event.query));
  }

  void _onHomeFilterChanged(HomeFilterChanged event, Emitter<HomeState> emit) {
    emit(state.copyWith(filter: event.filter));
  }

  Future<void> _onHomeSubscriptionRequested(
      HomeSubscriptionRequested event, Emitter<HomeState> emit) async {
    emit(state.copyWith(status: HomeStatus.loading));

    await emit.forEach<List<Comma>>(this._audioRepository.getAudios(),
        onData: (commas) =>
            state.copyWith(audios: commas, status: HomeStatus.success),
        onError: (_, __) => state.copyWith(status: HomeStatus.failure));
  }

  Future<void> _onHomeRetryRequested(
      HomeRetryRequested event, Emitter<HomeState> emit) async {
    emit(state.copyWith(status: HomeStatus.loading));
    try {
      await this._audioRepository.fetchCommas(0, 10000, '');
    } catch (_) {
      emit(state.copyWith(status: HomeStatus.failure));
    }
  }

  // The repository stream emits the updated list, so no status change here.
  Future<void> _onHomeFavoriteToggled(
      HomeFavoriteToggled event, Emitter<HomeState> emit) async {
    try {
      await this._audioRepository.toggleFavorite('', event.comma);
    } on Exception {
      emit(state.copyWith(status: HomeStatus.failure));
    }
  }

  Future<void> _onHomeShowPlayerRequested(
      HomeShowPlayerRequested event, Emitter<HomeState> emit) async {
    emit(state.copyWith(
      showPlayer: true,
    ));
  }

/*
  Future<void> _onHomeQueryRequested(
      HomeQueryRequested event, Emitter<HomeState> emit) async {
    final query = event.query;

    if (query.length < 3) {
      return;
    }

    emit(state.copyWith(status: HomeStatus.loading));

    List<Comma> filtered = this
        .state
        .audios
        .where((comma) =>
            comma.author.toLowerCase().contains(query) ||
            comma.label.toLowerCase().contains(query))
        .toList();

    if (filtered.isNotEmpty) {
      emit(state.copyWith(audios: [...filtered]));
    }

    emit(state.copyWith(status: HomeStatus.success));
  }
  */
}
