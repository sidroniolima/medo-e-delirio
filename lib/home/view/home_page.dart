import 'package:audio_repository/audio_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:medo_e_delirio_app/@shared/@shared.dart';

import 'package:medo_e_delirio_app/color_palette.dart';
import 'package:medo_e_delirio_app/home_tab/cubit/home_tab_cubit.dart';
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
      BlocProvider(
        create: (context) => HomeTabCubit(),
      ),
    ], child: HomePageView());
  }
}

class HomePageView extends StatelessWidget {
  const HomePageView({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedTab = context.select((HomeTabCubit cubit) => cubit.state.tab);

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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildActionButton(
                                value: HomeTab.all,
                                groupValue: selectedTab,
                                action: () {
                                  context
                                      .read<HomeTabCubit>()
                                      .setTab(HomeTab.all);

                                  context.read<HomeBloc>().add(
                                      HomeFilterChanged(
                                          filter: HomeFilter.all));
                                },
                                label: 'todos'),
                            _buildActionButton(
                                value: HomeTab.favorite,
                                groupValue: selectedTab,
                                action: () {
                                  context
                                      .read<HomeTabCubit>()
                                      .setTab(HomeTab.favorite);

                                  context.read<HomeBloc>().add(
                                      HomeFilterChanged(
                                          filter: HomeFilter.favorite));
                                },
                                label: 'favoritos'),
                            _buildActionButton(
                                value: HomeTab.music,
                                groupValue: selectedTab,
                                action: () {
                                  context
                                      .read<HomeTabCubit>()
                                      .setTab(HomeTab.music);

                                  context.read<HomeBloc>().add(
                                      HomeFilterChanged(
                                          filter: HomeFilter.music));
                                },
                                label: 'músicas'),
                            _buildDonateDialog(context),
                          ],
                        ),
                        SizedBox(
                          height: 6.0,
                        ),
                        TextField(
                          style: TextStyle(
                              color: ColorPalette.secondary, fontSize: 14),
                          onChanged: (value) {
                            context
                                .read<HomeBloc>()
                                .add(HomeQueryChanged(query: value));
                          },
                          decoration: InputDecoration(
                            labelStyle: TextStyle(
                                color: ColorPalette.secondary, fontSize: 14.0),
                            hintStyle: TextStyle(color: ColorPalette.secondary),
                            hintText: 'autor ou descrição',
                            labelText: 'digite sua pesquisa',
                            enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: ColorPalette.secondary)),
                            border: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: ColorPalette.secondary)),
                            focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: ColorPalette.secondary)),
                          ),
                        ),
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

  TextButton _buildDonateDialog(BuildContext context) {
    return TextButton(
      onPressed: () async {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                backgroundColor: ColorPalette.secondary,
                title: Text(
                  'Contribua para o APP',
                  style: TextStyle(fontSize: 14.0, color: ColorPalette.primary),
                ),
                alignment: Alignment.center,
                content: RichText(
                  text: TextSpan(
                      text: 'Este aplicativo é uma criação ',
                      style: TextStyle(color: ColorPalette.primary),
                      children: [
                        TextSpan(
                            text: 'independente',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(text: ' e autorizada pela equipe do '),
                        TextSpan(
                            text: 'Medo e Delírio',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(text: '.'),
                        TextSpan(text: '\n\nSe você puder e quiser apoiar '),
                        TextSpan(
                            text: 'o desenvolvimento e a manutenção ',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(text: ' dele, '),
                        TextSpan(
                            text:
                                'copie a chave PIX abaixo, abra seu aplicativo bancário e contribua com a quantia desejada.'),
                        TextSpan(
                            text: '\n\n\Thank you!',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ]),
                ),
                actions: [
                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: ColorPalette.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'doação é o caralh*',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: ColorPalette.tertiary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () async {
                      await Clipboard.setData(ClipboardData(
                        text: '77d6aecd-f99f-45a3-8852-9d9b91de1f9d',
                      ));
                    },
                    child: Text(
                      'copiar chave PIX',
                      style: TextStyle(color: ColorPalette.primary),
                    ),
                  ),
                ],
              );
            });
      },
      child: Text(
        'contribua',
        style: TextStyle(
          color: ColorPalette.tertiary,
          fontSize: 16.0,
        ),
      ),
      style: TextButton.styleFrom(
        backgroundColor: ColorPalette.primary,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: ColorPalette.tertiary),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  _buildActionButton(
      {required HomeTab value,
      required HomeTab groupValue,
      required Function() action,
      required String label}) {
    return TextButton(
      onPressed: action,
      child: Text(
        label,
        style: TextStyle(
          color: ColorPalette.primary,
          fontSize: 16.0,
        ),
      ),
      style: TextButton.styleFrom(
        backgroundColor: (value == groupValue)
            ? ColorPalette.tertiary
            : ColorPalette.secondary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
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
