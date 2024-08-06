import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:medo_e_delirio_app/color_palette.dart';
import 'package:medo_e_delirio_app/player/cubit/player_cubit.dart';

class Player extends StatelessWidget {
  const Player({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
      child: Container(
        padding: EdgeInsets.all(8.0),
        height: 100.0,
        width: double.infinity,
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  color: ColorPalette.primary,
                  spreadRadius: 4.0,
                  blurRadius: 14.0,
                  offset: Offset(0, 0))
            ],
            color: //Color(0xFF7eb77f),
                ColorPalette.secondary,
            //ColorPalette.tertiary,
            //ColorPalette.primary,
            borderRadius: BorderRadius.circular(8.0)),
        child: BlocBuilder<PlayerCubit, PlayerState>(
          builder: (context, state) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ...switch (state.status) {
                  PlayerStatus.playing => [
                      InkWell(
                        onTap: () {
                          context.read<PlayerCubit>().pause();
                        },
                        child: Icon(
                          FontAwesomeIcons.pause,
                          color: Colors.white,
                          size: 28.0,
                        ),
                      ),
                    ],
                  PlayerStatus.loading => [
                      SizedBox(
                        width: 28.0,
                        height: 28.0,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.0,
                          color: Colors.white,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    ],
                  _ => [
                      InkWell(
                        onTap: () async {
                          await context.read<PlayerCubit>().play(state.audio);
                        },
                        child: Icon(
                          FontAwesomeIcons.play,
                          color: Colors.white,
                          size: 28.0,
                        ),
                      ),
                    ]
                },
                Container(
                  width: 210.0,
                  child: RichText(
                    text: TextSpan(children: [
                      TextSpan(
                          text: state.audio.label,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold)),
                      TextSpan(
                          text: '\n${state.audio.author}',
                          style:
                              TextStyle(color: Colors.white, fontSize: 14.0)),
                    ]),
                  ),
                ),
                InkWell(
                  onTap: () {
                    context.read<PlayerCubit>().toggleFavorite('', state.audio);
                  },
                  child: Icon(
                    state.audio.favorite
                        ? FontAwesomeIcons.solidHeart
                        : FontAwesomeIcons.heart,
                    color: Colors.white,
                    size: 28.0,
                  ),
                ),
                state.status == PlayerStatus.sharing
                    ? SizedBox(
                        width: 28.0,
                        height: 28.0,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.0,
                          color: Colors.white,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : InkWell(
                        onTap: () async {
                          await context.read<PlayerCubit>().shareSelected();
                        },
                        child: Icon(
                          FontAwesomeIcons.shareNodes,
                          color: Colors.white,
                          size: 28.0,
                        ),
                      ),
                state.status == PlayerStatus.sharingVideo
                    ? SizedBox(
                        width: 28.0,
                        height: 28.0,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.0,
                          color: Colors.white,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : InkWell(
                        onTap: () async {
                          await context
                              .read<PlayerCubit>()
                              .shareVideoForSelected();
                        },
                        child: Icon(
                          FontAwesomeIcons.fileVideo,
                          color: Colors.white,
                          size: 28.0,
                        ),
                      ),
                /*InkWell(
                  onTap: () {
                    context.read<PlayerCubit>().generateVideoBytes();
                  },
                  child: Icon(
                    FontAwesomeIcons.video,
                    color: ColorPalette.primary,
                    size: 28.0,
                  ),
                ),*/
              ],
            );
          },
        ),
      ),
    );
  }
}

/*

Text(
                    state.audio.label,
                    style: TextStyle(color: Colors.white, fontSize: 16.0),
                  ),
                  IconButton.filled(
                    onPressed: () {
                      switch (state.status) {
                        case PlayerStatus.loading:
                          context.read<PlayerCubit>().playSelected();
                        case PlayerStatus.playing:
                          context.read<PlayerCubit>().playSelected();
                        default:
                          break;
                      }
                    },
                    icon: Icon(
                      state.status == PlayerStatus.playing
                          ? FontAwesomeIcons.pause
                          : FontAwesomeIcons.play,
                      color: Colors.white,
                      size: 28.0,
                    ),
                  )*/
