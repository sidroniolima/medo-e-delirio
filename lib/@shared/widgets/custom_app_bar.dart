import 'package:flutter/material.dart';
import 'package:medo_e_delirio_app/about/about.dart';
import 'package:medo_e_delirio_app/color_palette.dart';

enum CustbomBarActionType { about, home }

buildCustomAppBar(BuildContext context, CustbomBarActionType actionType) =>
    AppBar(
      backgroundColor: ColorPalette.secondary,
      elevation: 0.0,
      toolbarHeight: 132.0,
      flexibleSpace: FlexibleSpaceBar(
        /*background: Image.asset(
          'assets/images/logo_sem_bozo.png',
          fit: BoxFit.fitWidth,
        ),*/
        background: FadeInImage(
          image: NetworkImage('https://sidroniolima.com.br/med/banner_app.png'),
          placeholder: AssetImage('assets/images/logo_sem_bozo.png'),
          fit: BoxFit.fitWidth,
        ),
      ),
      actions: [
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
