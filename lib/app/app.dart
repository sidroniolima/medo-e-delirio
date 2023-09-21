import 'package:audio_repository/audio_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medo_e_delirio_app/home/view/home_page.dart';

import '../color_palette.dart';

class App extends StatelessWidget {
  const App({required this.audioRepository});

  final AudioRepository audioRepository;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: audioRepository,
      child: const AppView(),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = ThemeData(
      brightness: Brightness.light,
      fontFamily: 'Montserrat',
      textTheme: TextTheme(
        bodyMedium: TextStyle(color: Colors.white, fontSize: 14),
      ),
    );

    return MaterialApp(
        title: 'Medo e Delírio',
        theme: theme.copyWith(
          textSelectionTheme:
              TextSelectionThemeData(cursorColor: ColorPalette.secondary),
          primaryColor: ColorPalette.primary,
          scaffoldBackgroundColor: ColorPalette.primary,
          colorScheme: theme.colorScheme.copyWith(
            secondary: ColorPalette.secondary,
          ),
        ),
        debugShowCheckedModeBanner: false,
        home: const HomePage());
  }
}
