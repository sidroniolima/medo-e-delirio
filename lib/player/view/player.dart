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
      padding: const EdgeInsets.all(16.0),
      child: Container(
        padding: EdgeInsets.all(16.0),
        height: 120.0,
        width: double.infinity,
        decoration: BoxDecoration(
            color: ColorPalette.quaternary,
            borderRadius: BorderRadius.circular(8.0)),
        child: BlocBuilder<PlayerCubit, PlayerState>(
          builder: (context, state) {
            return Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    state.audio.label,
                    style: TextStyle(color: Colors.white, fontSize: 16.0),
                  ),
                  IconButton.filled(
                    onPressed: () => context.read<PlayerCubit>().playSelected(),
                    icon: Icon(
                      FontAwesomeIcons.play,
                      color: Colors.white,
                      size: 32.0,
                    ),
                  )
                ]);
          },
        ),
      ),
    );
  }
}
