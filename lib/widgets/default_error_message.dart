import 'package:flutter/material.dart';

import '../color_palette.dart';

class DefaultErrorMessage extends StatelessWidget {
  final Function action;

  DefaultErrorMessage({required this.action});

  @override
  Widget build(BuildContext context) {
    Size _screenSize = MediaQuery.of(context).size;

    return Center(
      child: Column(
        children: [
          Text(
            'Deu erraaaado...',
            style: TextStyle(
                fontSize: _screenSize.height * 0.017,
                color: ColorPalette.primary),
          ),
          OutlinedButton(
            onPressed: () => this.action,
            child: Text('tentar de novo'),
            style: OutlinedButton.styleFrom(
                foregroundColor: ColorPalette.secondary, side: BorderSide(width: 1, color: ColorPalette.secondary),
                backgroundColor: Colors.transparent,
                textStyle: TextStyle(
                  fontSize: _screenSize.height * 0.02,
                )),
          ),
        ],
      ),
    );
  }
}
