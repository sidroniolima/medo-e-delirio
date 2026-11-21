import 'package:audio_repository/audio_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medo_e_delirio_app/donation/donation.dart';
import 'package:medo_e_delirio_app/home/view/home_page.dart';

import '../color_palette.dart';

class App extends StatelessWidget {
  const App({
    required this.audioRepository,
    required this.donationPrompt,
    required this.donationTracker,
  });

  final AudioRepository audioRepository;
  final DonationPrompt donationPrompt;
  final DonationTracker donationTracker;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: audioRepository),
        RepositoryProvider.value(value: donationPrompt),
        RepositoryProvider.value(value: donationTracker),
      ],
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
