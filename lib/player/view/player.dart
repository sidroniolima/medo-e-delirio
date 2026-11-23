import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:medo_e_delirio_app/color_palette.dart';
import 'package:medo_e_delirio_app/player/cubit/player_cubit.dart';

class Player extends StatelessWidget {
  const Player({super.key});

  static const double _height = 124.0;
  static const double _verticalPadding = 16.0;

  /// Total height the player covers over the content behind it.
  static const double overlayHeight = _height + _verticalPadding * 2;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: _verticalPadding),
      child: Container(
        height: _height,
        width: double.infinity,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  color: ColorPalette.primary.withValues(alpha: 0.7),
                  spreadRadius: 2.0,
                  blurRadius: 6.0,
                  offset: Offset(0, 0))
            ],
            color: ColorPalette.secondary,
            borderRadius: BorderRadius.circular(8.0)),
        child: BlocBuilder<PlayerCubit, PlayerState>(
          builder: (context, state) {
            final cubit = context.read<PlayerCubit>();

            return Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 6.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            _PlayButton(state: state),
                            SizedBox(width: 12.0),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    state.audio.label,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    state.audio.author,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        color: ColorPalette.tertiary,
                                        fontSize: 13.0),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              tooltip: state.audio.favorite
                                  ? 'remover dos favoritos'
                                  : 'favoritar',
                              onPressed: () =>
                                  cubit.toggleFavorite('', state.audio),
                              icon: Icon(
                                state.audio.favorite
                                    ? FontAwesomeIcons.solidHeart
                                    : FontAwesomeIcons.heart,
                                color: state.audio.favorite
                                    ? ColorPalette.tertiary
                                    : Colors.white,
                                size: 24.0,
                              ),
                            ),
                          ],
                        ),
                        Spacer(),
                        Row(
                          children: [
                            Expanded(
                              child: _ShareButton(
                                label: 'enviar áudio',
                                icon: FontAwesomeIcons.shareNodes,
                                loading:
                                    state.share == ShareStatus.sharingAudio,
                                enabled: state.share == ShareStatus.idle,
                                onPressed: cubit.shareSelected,
                              ),
                            ),
                            SizedBox(width: 8.0),
                            Expanded(
                              child: _ShareButton(
                                label: 'enviar vídeo',
                                icon: FontAwesomeIcons.fileVideo,
                                loading:
                                    state.share == ShareStatus.sharingVideo,
                                enabled: state.share == ShareStatus.idle,
                                onPressed: cubit.shareVideoForSelected,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                StreamBuilder<double>(
                  stream: cubit.progressStream,
                  builder: (context, snapshot) => LinearProgressIndicator(
                    value: snapshot.data ?? 0.0,
                    minHeight: 3.0,
                    color: ColorPalette.tertiary,
                    backgroundColor:
                        ColorPalette.primary.withValues(alpha: 0.3),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _PlayButton extends StatelessWidget {
  const _PlayButton({required this.state});

  final PlayerState state;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<PlayerCubit>();

    return SizedBox(
      width: 44.0,
      height: 44.0,
      child: switch (state.status) {
        PlayerStatus.loading => Padding(
            padding: const EdgeInsets.all(10.0),
            child: CircularProgressIndicator(
              strokeWidth: 2.0,
              color: Colors.white,
            ),
          ),
        PlayerStatus.playing => IconButton.filled(
            tooltip: 'pausar',
            onPressed: cubit.pause,
            style: _style,
            icon: Icon(FontAwesomeIcons.pause, size: 18.0),
          ),
        _ => IconButton.filled(
            tooltip: 'tocar',
            onPressed: () => cubit.play(state.audio),
            style: _style,
            icon: Icon(FontAwesomeIcons.play, size: 18.0),
          ),
      },
    );
  }

  ButtonStyle get _style => IconButton.styleFrom(
        backgroundColor: ColorPalette.tertiary,
        foregroundColor: ColorPalette.primary,
      );
}

class _ShareButton extends StatelessWidget {
  const _ShareButton({
    required this.label,
    required this.icon,
    required this.loading,
    required this.enabled,
    required this.onPressed,
  });

  final String label;
  final IconData icon;
  final bool loading;
  final bool enabled;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: enabled ? onPressed : null,
      icon: loading
          ? SizedBox(
              width: 14.0,
              height: 14.0,
              child: CircularProgressIndicator(
                strokeWidth: 2.0,
                color: Colors.white,
              ),
            )
          : Icon(icon, size: 14.0),
      label: Text(loading ? 'preparando...' : label),
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.white,
        disabledForegroundColor: Colors.white70,
        side: BorderSide(color: Colors.white54),
        padding: const EdgeInsets.symmetric(vertical: 6.0),
        minimumSize: Size(0, 34.0),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        textStyle: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 13.0,
            fontWeight: FontWeight.w500),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(17.0),
        ),
      ),
    );
  }
}
