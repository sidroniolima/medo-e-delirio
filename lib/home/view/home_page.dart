import 'package:audio_repository/audio_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:medo_e_delirio_app/color_palette.dart';
import 'package:medo_e_delirio_app/player/cubit/player_cubit.dart';
import 'package:medo_e_delirio_app/player/view/player.dart';

import '../../widgets/widgets.dart';
import '../bloc/home_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider(
        create: (context) =>
            HomeBloc(audioRepository: context.read<AudioRepository>())
              ..add(HomeFetchAllRequested()),
      ),
      BlocProvider(create: (context) => PlayerCubit()),
    ], child: HomePageView());
  }
}

class HomePageView extends StatelessWidget {
  const HomePageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorPalette.secondary,
        elevation: 0.0,
        toolbarHeight: 120.0,
        flexibleSpace: FlexibleSpaceBar(
          background: Image.asset(
            'assets/images/med_full_logo.png',
            fit: BoxFit.fitHeight,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 08.0),
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
                        context.read<HomeBloc>().add(HomeFetchAllRequested()));
              case HomeStatus.success:
                return Stack(children: [
                  Column(
                    children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildActionButton(
                                action: () => context
                                    .read<HomeBloc>()
                                    .add(HomeFetchAllRequested()),
                                label: 'Audios'),
                            /*_buildActionButton(
                                action: () => context
                                    .read<HomeBloc>()
                                    .add(HomeFetchAllRequested()),
                                label: 'Recentes'),*/
                            _buildActionButton(
                                action: () => context
                                    .read<HomeBloc>()
                                    .add(HomeFetchFavoritesRequested()),
                                label: 'Favoritos'),
                            _buildActionButton(
                                action: () async {
                                  await Clipboard.setData(ClipboardData(
                                    text:
                                        '77d6aecd-f99f-45a3-8852-9d9b91de1f9d',
                                  )).then((value) => {
                                        ScaffoldMessenger.of(context)
                                          ..hideCurrentSnackBar()
                                          ..showSnackBar(
                                            SnackBar(
                                              content: Center(
                                                child: Text(
                                                  'Chave PIX copiada, boca de leite!',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 16),
                                                ),
                                              ),
                                              backgroundColor:
                                                  ColorPalette.primary,
                                              elevation: 0,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(08),
                                                    topRight:
                                                        Radius.circular(08)),
                                              ),
                                            ),
                                          ),
                                      });
                                },
                                label: 'Doar por PIX',
                                color: ColorPalette.tertiary)
                          ]),
                      SizedBox(
                        height: 8.0,
                      ),
                      Expanded(
                        flex: 1,
                        child: GridView.count(
                          padding: EdgeInsets.zero,
                          crossAxisCount: 3,
                          shrinkWrap: true,
                          mainAxisSpacing: 8.0,
                          crossAxisSpacing: 8.0,
                          children: state.commas.map((Comma comma) {
                            return MediaPanel(
                              author: comma.author,
                              isFavorite: false,
                              favoriteAction: () {
                                context
                                    .read<HomeBloc>()
                                    .add(HomeFavorited(comma: comma));
                              },
                              isPlaying: false,
                              onPress: () {
                                context
                                    .read<HomeBloc>()
                                    .add(HomeShowPlayerRequested(comma: comma));

                                context.read<PlayerCubit>().play(comma);
                              },
                              screenSize: MediaQuery.of(context).size,
                              label: comma.label,
                            );
                          }).toList(),
                        ),
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
    );
  }

  _buildActionButton(
      {required Function() action, required String label, Color? color}) {
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
        backgroundColor: color ?? ColorPalette.secondary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
