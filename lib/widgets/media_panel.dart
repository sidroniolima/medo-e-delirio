import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:medo_e_delirio_app/color_palette.dart';

class MediaPanel extends StatelessWidget {
  const MediaPanel({
    required this.onPress,
    required this.screenSize,
    required this.label,
    required this.isPlaying,
    required this.author,
    required this.isFavorite,
    required this.favoriteAction,
    this.isLoading = false,
    this.isMusic = false,
  });

  final Function onPress;
  final Size screenSize;
  final String label;
  final String author;
  final bool isPlaying;
  final bool isLoading;
  final bool isFavorite;
  final bool isMusic;
  final Function favoriteAction;

  bool get _isCurrent => isPlaying || isLoading;

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(8.0);

    return Material(
      color: ColorPalette.secondary,
      shape: RoundedRectangleBorder(
        borderRadius: borderRadius,
        side: _isCurrent
            ? BorderSide(color: ColorPalette.tertiary, width: 2.0)
            : BorderSide.none,
      ),
      child: InkWell(
        borderRadius: borderRadius,
        onTap: () {
          this.onPress();
        },
        child: Padding(
          padding: EdgeInsets.all(screenSize.width * .02),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  this.label,
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: screenSize.width * .036,
                      color: Colors.white,
                      fontWeight: FontWeight.w500),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: screenSize.width * .02),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        this.author,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: screenSize.width * .032,
                            color: ColorPalette.tertiary,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                    ..._buildIndicators(),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildIndicators() {
    final icons = <Widget>[
      if (isLoading)
        SizedBox(
          width: 12.0,
          height: 12.0,
          child: CircularProgressIndicator(
            strokeWidth: 1.5,
            color: ColorPalette.tertiary,
          ),
        )
      else if (isPlaying)
        Icon(FontAwesomeIcons.volumeHigh,
            color: ColorPalette.tertiary, size: 12.0),
      if (isMusic)
        Icon(FontAwesomeIcons.music, color: Colors.white70, size: 12.0),
      if (isFavorite)
        Icon(FontAwesomeIcons.solidHeart,
            color: ColorPalette.tertiary, size: 12.0),
    ];

    return [
      for (final icon in icons) ...[SizedBox(width: 4.0), icon]
    ];
  }
}
