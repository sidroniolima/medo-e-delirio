import 'package:flutter/material.dart';

class MediaPanel extends StatelessWidget {
  const MediaPanel({
    required this.onPress,
    required this.screenSize,
    required this.label,
    required this.isPlaying,
    required this.author,
    required this.isFavorite,
    required this.favoriteAction,
    required this.onLongPress,
  });

  final Function onPress;
  final Size screenSize;
  final String label;
  final String author;
  final bool isPlaying;
  final bool isFavorite;
  final Function onLongPress;
  final Function favoriteAction;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        this.onPress();
      },
      onLongPress: () {
        this.onLongPress();
      }, // this.onLongPress,
      child: Container(
        padding: EdgeInsets.all(screenSize.width * .02),
        width: screenSize.width * .35,
        height: screenSize.height * .1,
        decoration: BoxDecoration(
            color: Color(0XFF629460), borderRadius: BorderRadius.circular(8.0)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              this.label,
              overflow: TextOverflow.clip,
              style: TextStyle(
                  fontSize: screenSize.width * .036, color: Colors.white),
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
                    fontSize: screenSize.width * .032, color: Colors.yellow),
              ),
            ),

            /*GestureDetector(
                  child: FaIcon(
                    this.isFavorite
                        ? FontAwesomeIcons.solidStar
                        : FontAwesomeIcons.star,
                    size: screenSize.height * 0.020,
                    color: Colors.white,
                  ),
                  onTap: this.favoriteAction),*/
          ],
        ),
      ),
    );
  }
}
