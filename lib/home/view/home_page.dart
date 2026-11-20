import 'package:audio_repository/audio_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:medo_e_delirio_app/@shared/@shared.dart';

import 'package:medo_e_delirio_app/color_palette.dart';
import 'package:medo_e_delirio_app/player/cubit/player_cubit.dart';
import 'package:medo_e_delirio_app/player/view/player.dart';

import '../../widgets/widgets.dart';
import '../bloc/home_bloc.dart';
import '../models/models.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider(
        create: (context) =>
            HomeBloc(audioRepository: context.read<AudioRepository>())
              ..add(HomeSubscriptionRequested()),
      ),
      BlocProvider(
          create: (context) =>
              PlayerCubit(audioRepository: context.read<AudioRepository>())),
    ], child: HomePageView());
  }
}

class HomePageView extends StatelessWidget {
  const HomePageView({super.key});

  @override
  Widget build(BuildContext context) {
    // The AppBar paints behind the status bar (edge-to-edge since target SDK
    // 35), so SafeArea only guards the bottom navigation bar.
    return Scaffold(
      appBar: buildCustomAppBar(context, CustbomBarActionType.home),
      body: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.only(top: 12.0, left: 08.0, right: 8.0),
          child: Center(
            child: BlocBuilder<HomeBloc, HomeState>(builder: (context, state) {
              switch (state.status) {
                case HomeStatus.initial:
                  return Container();
                case HomeStatus.loading:
                  return DefaultProgressIndicator(message: 'Carregando...');
                case HomeStatus.failure:
                  return DefaultErrorMessage(
                      action: () =>
                          context.read<HomeBloc>().add(HomeRetryRequested()));
                case HomeStatus.success:
                  return Stack(children: [
                    Column(
                      children: [
                        _FilterChips(state: state),
                        SizedBox(
                          height: 6.0,
                        ),
                        _SearchField(),
                        SizedBox(
                          height: 12.0,
                        ),
                        Expanded(
                          flex: 1,
                          child: _buildAudioList(context, state),
                        ),
                      ],
                    ),
                    state.showPlayer
                        ? Align(
                            alignment: Alignment.bottomCenter, child: Player())
                        : Container(),
                  ]);
              }
            }),
          ),
        ),
      ),
    );
  }

  Widget _buildAudioList(BuildContext context, HomeState state) {
    final player = context.watch<PlayerCubit>().state;
    final audios = state.filteredAudios.toList();

    if (audios.isEmpty) {
      return _EmptyMessage(
        icon: state.query.isNotEmpty
            ? FontAwesomeIcons.magnifyingGlass
            : FontAwesomeIcons.heart,
        message: state.query.isNotEmpty
            ? 'Nada encontrado para "${state.query}".'
            : switch (state.filter) {
                HomeFilter.favorite =>
                  'Nenhum favorito ainda.\nToque no ♡ do player para favoritar.',
                _ => 'Nenhum áudio por aqui.',
              },
      );
    }

    return GridView.count(
      // Room to scroll the last items above the player.
      padding: EdgeInsets.only(
          bottom: state.showPlayer ? Player.overlayHeight : 0.0),
      crossAxisCount: 3,
      shrinkWrap: true,
      mainAxisSpacing: 8.0,
      crossAxisSpacing: 8.0,
      children: audios.map((Comma comma) {
        final isCurrent = player.audio.id == comma.id;

        return MediaPanel(
          author: comma.author,
          isFavorite: comma.favorite,
          isMusic: comma.type == 'MUSIC',
          favoriteAction: () {},
          isPlaying: isCurrent && player.status == PlayerStatus.playing,
          isLoading: isCurrent && player.status == PlayerStatus.loading,
          onPress: () {
            context.read<HomeBloc>().add(HomeShowPlayerRequested(comma: comma));

            context.read<PlayerCubit>().play(comma);
          },
          screenSize: MediaQuery.of(context).size,
          label: comma.label,
        );
      }).toList(),
    );
  }
}

class _EmptyMessage extends StatelessWidget {
  const _EmptyMessage({required this.icon, required this.message});

  final IconData icon;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: ColorPalette.secondary, size: 32.0),
            SizedBox(height: 12.0),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white70, fontSize: 15.0),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterChips extends StatelessWidget {
  const _FilterChips({required this.state});

  final HomeState state;

  static const _labels = {
    HomeFilter.all: 'todos',
    HomeFilter.favorite: 'favoritos',
    HomeFilter.music: 'músicas',
  };

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final filter in HomeFilter.values)
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: ChoiceChip(
                label: Text(
                    '${_labels[filter]}  ${filter.applyAll(state.audios).length}'),
                selected: state.filter == filter,
                showCheckmark: false,
                onSelected: (_) => context
                    .read<HomeBloc>()
                    .add(HomeFilterChanged(filter: filter)),
                labelStyle: TextStyle(
                  fontFamily: 'Montserrat',
                  color: ColorPalette.primary,
                  fontSize: 15.0,
                  fontWeight: state.filter == filter
                      ? FontWeight.bold
                      : FontWeight.w500,
                ),
                backgroundColor: ColorPalette.secondary,
                selectedColor: ColorPalette.tertiary,
                side: BorderSide.none,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _SearchField extends StatefulWidget {
  const _SearchField();

  @override
  State<_SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<_SearchField> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    setState(() {});
    context.read<HomeBloc>().add(HomeQueryChanged(query: value));
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      onChanged: _onChanged,
      textInputAction: TextInputAction.search,
      style: TextStyle(color: Colors.white, fontSize: 15.0),
      decoration: InputDecoration(
        isDense: true,
        filled: true,
        fillColor: ColorPalette.secondary.withValues(alpha: 0.25),
        hintText: 'buscar por autor ou descrição',
        hintStyle: TextStyle(color: Colors.white60, fontSize: 15.0),
        prefixIcon:
            Icon(Icons.search, color: ColorPalette.secondary, size: 22.0),
        suffixIcon: _controller.text.isEmpty
            ? null
            : IconButton(
                tooltip: 'limpar busca',
                icon: Icon(Icons.close, color: Colors.white70, size: 20.0),
                onPressed: () {
                  _controller.clear();
                  _onChanged('');
                },
              ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: ColorPalette.secondary),
        ),
      ),
    );
  }
}
