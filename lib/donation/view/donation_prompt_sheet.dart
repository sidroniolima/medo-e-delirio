import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medo_e_delirio_app/color_palette.dart';
import 'package:medo_e_delirio_app/player/cubit/player_cubit.dart';

import '../donation_config.dart';
import '../donation_prompt.dart';
import '../donation_tracker.dart';
import 'donate_dialog.dart';

/// Counts finished shares and plays, and asks for a donation at those
/// natural pauses once [DonationPrompt.shouldAsk] allows it.
class DonationPromptListener extends StatelessWidget {
  const DonationPromptListener({super.key, required this.child});

  final Widget child;

  Future<void> _register(
      BuildContext context, Future<void> Function(DonationPrompt) count) async {
    final prompt = context.read<DonationPrompt>();
    await count(prompt);

    if (context.mounted && prompt.shouldAsk) {
      _showPromptSheet(context, prompt);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<PlayerCubit, PlayerState>(
          listenWhen: (previous, current) =>
              previous.share != ShareStatus.idle &&
              current.share == ShareStatus.idle,
          listener: (context, _) =>
              _register(context, (prompt) => prompt.registerShare()),
        ),
        BlocListener<PlayerCubit, PlayerState>(
          listenWhen: (previous, current) =>
              previous.status == PlayerStatus.playing &&
              current.status == PlayerStatus.stopped,
          listener: (context, _) =>
              _register(context, (prompt) => prompt.registerPlay()),
        ),
      ],
      child: child,
    );
  }
}

void _showPromptSheet(BuildContext context, DonationPrompt prompt) {
  final tracker = context.read<DonationTracker>();

  prompt.snoozeAfterDismiss();
  tracker.promptShown();

  showModalBottomSheet(
    context: context,
    backgroundColor: ColorPalette.secondary,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
    ),
    builder: (sheetContext) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 12.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Curtindo as vírgulas?',
              style: TextStyle(
                fontFamily: 'PermanentMarker',
                color: ColorPalette.primary,
                fontSize: 22.0,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              'Tô vendo que você tá gostando do app e se divertindo com as '
              'vírgulas! O app é mantido por meio de doações. '
              'Que tal mandar um PIX de R\$ ${DonationConfig.promptAmount.toStringAsFixed(0)}?',
              style: TextStyle(color: ColorPalette.primary, fontSize: 15.0),
            ),
            SizedBox(height: 16.0),
            FilledButton(
              onPressed: () {
                Navigator.of(sheetContext).pop();
                showDonateDialog(context,
                    source: DonationSource.prompt,
                    amount: DonationConfig.promptAmount);
              },
              style: FilledButton.styleFrom(
                backgroundColor: ColorPalette.tertiary,
                foregroundColor: ColorPalette.primary,
                padding: const EdgeInsets.symmetric(vertical: 14.0),
              ),
              child: Text('bora!',
                  style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold)),
            ),
            TextButton(
              onPressed: () {
                tracker.promptDismissed();
                Navigator.of(sheetContext).pop();
              },
              style: TextButton.styleFrom(foregroundColor: Colors.white),
              child: Text('agora não'),
            ),
          ],
        ),
      ),
    ),
  );
}
