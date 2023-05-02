import 'package:flutter/material.dart';

import '../color_palette.dart';

class DefaultProgressIndicator extends StatelessWidget {
  final String message;

  DefaultProgressIndicator({required this.message});

  @override
  Widget build(BuildContext context) {
    Size _screenSize = MediaQuery.of(context).size;

    return Container(
      height: _screenSize.height * .6,
      width: _screenSize.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            this.message,
            style: TextStyle(
                fontSize: _screenSize.height * 0.02,
                color: ColorPalette.secondary),
          ),
          SizedBox(
            height: _screenSize.height * .04,
          ),
          CircularProgressIndicator(
            strokeWidth: 1.0,
            color: ColorPalette.primary,
            valueColor: AlwaysStoppedAnimation<Color>(ColorPalette.secondary),
          )
        ],
      ),
    );
  }
}
