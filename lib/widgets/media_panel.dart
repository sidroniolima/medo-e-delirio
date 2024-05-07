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
  });

  final Function onPress;
  final Size screenSize;
  final String label;
  final String author;
  final bool isPlaying;
  final bool isFavorite;
  final Function favoriteAction;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        this.onPress();
      },
      child: Container(
        padding: EdgeInsets.all(screenSize.width * .02),
        width: screenSize.width * .35,
        height: screenSize.height * .1,
        decoration: BoxDecoration(
            color: ColorPalette.secondary,
            borderRadius: BorderRadius.circular(8.0)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    this.label,
                    overflow: TextOverflow.clip,
                    style: TextStyle(
                        fontSize: screenSize.width * .036,
                        color: Colors.white,
                        fontWeight: FontWeight.w500),
                  ),
                  isPlaying
                      ? Align(
                          alignment: Alignment.center,
                          child: Container(
                            width: screenSize.height * 0.015,
                            height: screenSize.height * 0.015,
                            child: Center(
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                                strokeWidth: 1.0,
                              ),
                            ),
                          ))
                      : Container(),
                  Spacer(),
                  Padding(
                    padding: EdgeInsets.only(top: screenSize.width * .02),
                    child: Text(
                      this.author,
                      overflow: TextOverflow.clip,
                      style: TextStyle(
                          fontSize: screenSize.width * .032,
                          color: ColorPalette.tertiary,
                          fontWeight: FontWeight.w500),
                    ),
                  )
                ],
              ),
            ),
            isFavorite
                ? Icon(
                    FontAwesomeIcons.solidHeart,
                    color: ColorPalette.tertiary,
                    size: 12.0,
                  )
                : Container()
          ],
        ),
      ),
    );
  }
}
