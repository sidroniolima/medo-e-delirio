import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:medo_e_delirio_app/about/about.dart';
import 'package:medo_e_delirio_app/color_palette.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'donate_dialog.dart';

enum CustbomBarActionType { about, home }

buildCustomAppBar(BuildContext context, CustbomBarActionType actionType) =>
    AppBar(
      backgroundColor: ColorPalette.secondary,
      elevation: 0.0,
      // No Material 3 tint when the list scrolls under, so the status bar
      // keeps the same green as the banner.
      scrolledUnderElevation: 0.0,
      surfaceTintColor: Colors.transparent,
      toolbarHeight: 132.0,
      // White status bar icons over the green bar.
      systemOverlayStyle: SystemUiOverlayStyle.light,
      // Keeps the banner below the status bar instead of under it.
      flexibleSpace: SafeArea(
        bottom: false,
        child: FlexibleSpaceBar(
          /*background: Image.asset(
          'assets/images/logo_sem_bozo.png',
          fit: BoxFit.fitWidth,
        ),*/
          background: FadeInImage(
            image:
                NetworkImage('https://sidroniolima.com.br/med/banner_app.png'),
            placeholder: AssetImage('assets/images/logo_sem_bozo.png'),
            fit: BoxFit.fitWidth,
          ),
        ),
      ),
      actions: [
        if (actionType == CustbomBarActionType.home)
          Container(
            margin: EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
                color: ColorPalette.primary, shape: BoxShape.circle),
            child: IconButton(
              tooltip: 'contribua',
              onPressed: () => showDonateDialog(context),
              icon: Icon(FontAwesomeIcons.handHoldingHeart,
                  color: ColorPalette.tertiary, size: 22),
              highlightColor: ColorPalette.primary,
            ),
          ),
        Container(
          margin: EdgeInsets.only(top: 0, right: 8),
          decoration: BoxDecoration(
              color: ColorPalette.primary, shape: BoxShape.circle),
          child: switch (actionType) {
            CustbomBarActionType.home => Center(
                child: IconButton(
                  onPressed: () {
                    Navigator.push(context, AboutPage.route());
                  },
                  icon: Icon(Icons.question_mark,
                      color: ColorPalette.tertiary, size: 28),
                  highlightColor: ColorPalette.primary,
                ),
              ),
            CustbomBarActionType.about => Center(
                child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon:
                      Icon(Icons.home, color: ColorPalette.tertiary, size: 28),
                  highlightColor: ColorPalette.primary,
                ),
              ),
          },
        ),
      ],
    );
