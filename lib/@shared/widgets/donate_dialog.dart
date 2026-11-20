import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:medo_e_delirio_app/color_palette.dart';

void showDonateDialog(BuildContext context) {
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: ColorPalette.secondary,
          title: Text(
            'Contribua para o APP',
            style: TextStyle(fontSize: 14.0, color: ColorPalette.primary),
          ),
          alignment: Alignment.center,
          content: RichText(
            text: TextSpan(
                text: 'Este aplicativo é uma criação ',
                style: TextStyle(color: ColorPalette.primary),
                children: [
                  TextSpan(
                      text: 'independente',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: ' e autorizada pela equipe do '),
                  TextSpan(
                      text: 'Medo e Delírio',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: '.'),
                  TextSpan(text: '\n\nSe você puder e quiser apoiar '),
                  TextSpan(
                      text: 'o desenvolvimento e a manutenção ',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: ' dele, '),
                  TextSpan(
                      text:
                          'copie a chave PIX abaixo, abra seu aplicativo bancário e contribua com a quantia desejada.'),
                  TextSpan(
                      text: '\n\n\Thank you!',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ]),
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: ColorPalette.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'doação é o caralh*',
                style: TextStyle(color: Colors.white),
              ),
            ),
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: ColorPalette.tertiary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () async {
                final messenger = ScaffoldMessenger.of(context);
                final navigator = Navigator.of(context);

                await Clipboard.setData(ClipboardData(
                  text: '77d6aecd-f99f-45a3-8852-9d9b91de1f9d',
                ));

                navigator.pop();
                messenger.showSnackBar(SnackBar(
                  content: Text('Chave PIX copiada!'),
                  backgroundColor: ColorPalette.secondary,
                ));
              },
              child: Text(
                'copiar chave PIX',
                style: TextStyle(color: ColorPalette.primary),
              ),
            ),
          ],
        );
      });
}
