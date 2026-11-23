import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:medo_e_delirio_app/about/about.dart';
import 'package:medo_e_delirio_app/color_palette.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:medo_e_delirio_app/donation/donation.dart';

enum CustbomBarActionType { about, home }

const double _bannerHeight = 132.0;

buildCustomAppBar(BuildContext context, CustbomBarActionType actionType) =>
    AppBar(
      backgroundColor: ColorPalette.secondary,
      elevation: 0.0,
      // No Material 3 tint when the list scrolls under, so the status bar
      // keeps the same green as the banner.
      scrolledUnderElevation: 0.0,
      surfaceTintColor: Colors.transparent,
      toolbarHeight: _bannerHeight,
      // White status bar icons over the green bar.
      systemOverlayStyle: SystemUiOverlayStyle.light,
      // Keeps the banner below the status bar instead of under it.
      flexibleSpace: SafeArea(
        bottom: false,
        child: FlexibleSpaceBar(background: _Banner()),
      ),
      actions: _buildActions(context, actionType),
    );

/// Same bar as [buildCustomAppBar], but the banner shrinks and fades into a
/// title as the content scrolls. Meant for a [NestedScrollView] header.
buildCustomSliverAppBar(
        BuildContext context, CustbomBarActionType actionType) =>
    SliverAppBar(
      pinned: true,
      expandedHeight: _bannerHeight,
      backgroundColor: ColorPalette.secondary,
      elevation: 0.0,
      scrolledUnderElevation: 0.0,
      surfaceTintColor: Colors.transparent,
      systemOverlayStyle: SystemUiOverlayStyle.light,
      flexibleSpace: LayoutBuilder(builder: (context, constraints) {
        final topPadding = MediaQuery.paddingOf(context).top;
        final collapsedHeight = kToolbarHeight + topPadding;
        final expandedHeight = _bannerHeight + topPadding;

        // 1.0 fully expanded, 0.0 fully collapsed.
        final expanded = ((constraints.maxHeight - collapsedHeight) /
                (expandedHeight - collapsedHeight))
            .clamp(0.0, 1.0);

        return SafeArea(
          bottom: false,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Opacity(opacity: expanded, child: _Banner()),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Opacity(
                    opacity: 1.0 - expanded,
                    child: Text(
                      'Medo e Delírio',
                      style: TextStyle(
                        fontFamily: 'PermanentMarker',
                        color: ColorPalette.tertiary,
                        fontSize: 22.0,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
      actions: _buildActions(context, actionType),
    );

class _Banner extends StatelessWidget {
  const _Banner();

  @override
  Widget build(BuildContext context) {
    return FadeInImage(
      image: NetworkImage('https://sidroniolima.com.br/med/banner_app.png'),
      placeholder: AssetImage('assets/images/logo_sem_bozo.png'),
      fit: BoxFit.fitWidth,
    );
  }
}

List<Widget> _buildActions(
        BuildContext context, CustbomBarActionType actionType) =>
    [
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
        decoration:
            BoxDecoration(color: ColorPalette.primary, shape: BoxShape.circle),
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
                icon: Icon(Icons.home, color: ColorPalette.tertiary, size: 28),
                highlightColor: ColorPalette.primary,
              ),
            ),
        },
      ),
    ];
