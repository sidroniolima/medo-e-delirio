import 'package:audio_repository/audio_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medo_e_delirio_app/@shared/@shared.dart';

import 'package:medo_e_delirio_app/color_palette.dart';
import 'package:medo_e_delirio_app/home_tab/cubit/home_tab_cubit.dart';
import 'package:medo_e_delirio_app/player/cubit/player_cubit.dart';
import 'package:medo_e_delirio_app/player/view/player.dart';
import 'package:url_launcher/url_launcher.dart';

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

    return Scaffold(
      appBar: buildCustomAppBar(context, CustbomBarActionType.home),
      body: Padding(
        padding: const EdgeInsets.only(top: 12.0, left: 08.0, right: 8.0),
        child: Center(
          child: BlocBuilder<HomeBloc, HomeState>(builder: (context, state) {
            switch (state.status) {
              case HomeStatus.initial:
                return Container();
              case HomeStatus.loading:
                return DefaultProgressIndicator(message: 'Carregando...');
              case HomeStatus.failure:
                return DefaultErrorMessage(action: () => {});
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
                                    HomeFilterChanged(filter: HomeFilter.all));
                              },
                              label: 'todos'),
                          _buildActionButton(
                              value: HomeTab.favorite,
                              groupValue: selectedTab,
                              action: () {
                                context
                                    .read<HomeTabCubit>()
                                    .setTab(HomeTab.favorite);

                                context.read<HomeBloc>().add(HomeFilterChanged(
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

                                context.read<HomeBloc>().add(HomeFilterChanged(
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
                        child: GridView.count(
                          padding: EdgeInsets.zero,
                          crossAxisCount: 3,
                          shrinkWrap: true,
                          mainAxisSpacing: 8.0,
                          crossAxisSpacing: 8.0,
                          children: state.filteredAudios.map((Comma comma) {
                            return MediaPanel(
                              author: comma.author,
                              isFavorite: comma.favorite,
                              favoriteAction: () {},
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
