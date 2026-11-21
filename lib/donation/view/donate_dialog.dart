import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medo_e_delirio_app/color_palette.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../donation_config.dart';
import '../donation_prompt.dart';
import '../donation_tracker.dart';
import '../pix_payload.dart';

void showDonateDialog(BuildContext context,
    {DonationSource source = DonationSource.appBar,
    double amount = DonationConfig.defaultAmount}) {
  context.read<DonationTracker>().dialogOpened(source);

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: ColorPalette.secondary,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
    ),
    builder: (_) => _DonateSheet(source: source, initialAmount: amount),
  );
}

class _DonateSheet extends StatefulWidget {
  const _DonateSheet({required this.source, required this.initialAmount});

  final DonationSource source;
  final double initialAmount;

  @override
  State<_DonateSheet> createState() => _DonateSheetState();
}

class _DonateSheetState extends State<_DonateSheet> {
  /// null means "outro valor": the payer types it in the bank app.
  late double? _amount = widget.initialAmount;

  String get _pixCode => DonationConfig.isReady
      ? PixPayload(
          key: DonationConfig.pixKey,
          name: DonationConfig.receiverName,
          city: DonationConfig.receiverCity,
          amount: _amount,
        ).toString()
      // Without name and city a valid code can't be built: fall back to the key.
      : DonationConfig.pixKey;

  Future<void> _copy() async {
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    await Clipboard.setData(ClipboardData(text: _pixCode));
    context.read<DonationTracker>().pixCopied(_amount ?? 0, widget.source);
    context.read<DonationPrompt>().snoozeAfterDonation();

    navigator.pop();
    messenger.showSnackBar(SnackBar(
      content: Text(DonationConfig.isReady
          ? 'Código copiado! No app do banco, escolha PIX copia e cola.'
          : 'Chave PIX copiada!'),
      backgroundColor: ColorPalette.secondary,
      duration: Duration(seconds: 5),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(color: ColorPalette.primary, fontSize: 15.0);

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20.0, 12.0, 20.0, 16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 40.0,
                height: 4.0,
                decoration: BoxDecoration(
                  color: ColorPalette.primary.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(2.0),
                ),
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Apoie o app',
              style: TextStyle(
                fontFamily: 'PermanentMarker',
                color: ColorPalette.primary,
                fontSize: 24.0,
              ),
            ),
            SizedBox(height: 8.0),
            RichText(
              text: TextSpan(style: textStyle, children: [
                TextSpan(text: 'Este aplicativo é uma criação '),
                TextSpan(
                    text: 'independente',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: ' e autorizada pela equipe do '),
                TextSpan(
                    text: 'Medo e Delírio',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(
                    text:
                        '. As doações são usadas para desenvolvimento e manutenção: '
                        'um PIX ajuda a manter tudo no ar.'),
              ]),
            ),
            SizedBox(height: 16.0),
            if (DonationConfig.isReady) ...[
              Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                alignment: WrapAlignment.center,
                children: [
                  for (final amount in DonationConfig.amounts)
                    _AmountChip(
                      label: 'R\$ ${amount.toStringAsFixed(0)}',
                      selected: _amount == amount,
                      onSelected: () => setState(() => _amount = amount),
                    ),
                  _AmountChip(
                    label: 'outro valor',
                    selected: _amount == null,
                    onSelected: () => setState(() => _amount = null),
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              Center(
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: QrImageView(data: _pixCode, size: 160.0),
                ),
              ),
              SizedBox(height: 16.0),
            ],
            FilledButton.icon(
              onPressed: _copy,
              icon: Icon(Icons.copy, size: 18.0),
              label: Text(DonationConfig.isReady
                  ? 'copiar PIX copia e cola'
                  : 'copiar chave PIX'),
              style: FilledButton.styleFrom(
                backgroundColor: ColorPalette.tertiary,
                foregroundColor: ColorPalette.primary,
                padding: const EdgeInsets.symmetric(vertical: 14.0),
                textStyle: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 4.0),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              style: TextButton.styleFrom(foregroundColor: Colors.white),
              child: Text('doação é o caralh*'),
            ),
          ],
        ),
      ),
    );
  }
}

class _AmountChip extends StatelessWidget {
  const _AmountChip({
    required this.label,
    required this.selected,
    required this.onSelected,
  });

  final String label;
  final bool selected;
  final VoidCallback onSelected;

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      showCheckmark: false,
      onSelected: (_) => onSelected(),
      labelStyle: TextStyle(
        fontFamily: 'Montserrat',
        color: selected ? ColorPalette.primary : Colors.white,
        fontSize: 15.0,
        fontWeight: selected ? FontWeight.bold : FontWeight.w500,
      ),
      backgroundColor: ColorPalette.primary,
      selectedColor: ColorPalette.tertiary,
      side: BorderSide.none,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
    );
  }
}
