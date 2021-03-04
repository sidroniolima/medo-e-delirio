import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MediaPanel extends StatelessWidget {
  const MediaPanel({
    Key key,
    @required this.onPress,
    @required this.screenSize,
    @required this.label,
    @required this.isPlaying,
    @required this.author,
    this.onLongPress,
  }) : super(key: key);

  final Function onPress;
  final Size screenSize;
  final String label;
  final String author;
  final bool isPlaying;
  final Function onLongPress;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: this.onPress,
      onLongPress: this.onLongPress,
      child: Container(
        margin: EdgeInsets.symmetric(
            vertical: screenSize.width * .01,
            horizontal: screenSize.width * .01),
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
            Padding(
              padding: EdgeInsets.only(top: screenSize.width * .02),
              child: Text(
                this.author,
                overflow: TextOverflow.clip,
                style: TextStyle(
                    fontSize: screenSize.width * .032, color: Colors.yellow),
              ),
            ),
            Spacer(),
            Align(
              alignment: Alignment.bottomCenter,
              child: isPlaying
                  ? SizedBox(
                      width: screenSize.height * 0.02,
                      height: screenSize.height * 0.02,
                      child: Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                          strokeWidth: 1.0,
                        ),
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                            child: FaIcon(
                              FontAwesomeIcons.shareAlt,
                              size: screenSize.height * 0.02,
                              color: Colors.white,
                            ),
                            onTap: this.onLongPress),
                        GestureDetector(
                            child: FaIcon(
                              FontAwesomeIcons.play,
                              size: screenSize.height * 0.02,
                              color: Colors.white,
                            ),
                            onTap: this.onPress),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
