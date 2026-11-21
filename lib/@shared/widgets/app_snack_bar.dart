import 'package:flutter/material.dart';
import 'package:medo_e_delirio_app/color_palette.dart';

/// The app's floating message: yellow, so it stands out from the green
/// audio cards behind it, with an optional bold title above the body.
SnackBar appSnackBar({
  String? title,
  String? body,
  Duration duration = const Duration(seconds: 6),
}) {
  return SnackBar(
    behavior: SnackBarBehavior.floating,
    backgroundColor: ColorPalette.tertiary,
    duration: duration,
    showCloseIcon: true,
    closeIconColor: ColorPalette.primary,
    content: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null)
          Text(
            title,
            style: TextStyle(
                color: ColorPalette.primary,
                fontWeight: FontWeight.bold,
                fontSize: 15.0),
          ),
        if (body != null)
          Text(
            body,
            style: TextStyle(color: ColorPalette.primary, fontSize: 14.0),
          ),
      ],
    ),
  );
}
