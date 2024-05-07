import 'package:flutter/material.dart';
import 'package:medo_e_delirio_app/@shared/@shared.dart';
import 'package:medo_e_delirio_app/color_palette.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  static Route<void> route() {
    return MaterialPageRoute(builder: (context) => AboutPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildCustomAppBar(context, CustbomBarActionType.about),
      body: Container(
        width: double.infinity,
        padding: EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () async {
                final Uri toLaunch = Uri(
                    scheme: 'https',
                    host: 'www.sidroniolima.com.br',
                    path: 'med/politica-de-privacidade.html');

                await launchUrl(toLaunch);
              },
              child: Text(
                'política de privacidade',
                style: TextStyle(
                  color: ColorPalette.primary,
                  fontSize: 16.0,
                ),
              ),
              style: TextButton.styleFrom(
                backgroundColor: ColorPalette.secondary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            SizedBox(
              height: 64.0,
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Column(
                children: [
                  Icon(
                    Icons.home,
                    color: ColorPalette.tertiary,
                    size: 80,
                  ),
                  Text(
                    'voltar',
                    style: TextStyle(color: ColorPalette.tertiary),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 64.0,
            ),
            Column(
              children: [
                Text(
                  'criado por @sidroniolima',
                  style: TextStyle(
                    color: ColorPalette.secondary,
                    fontSize: 16.0,
                  ),
                ),
                Text(
                  'colaboradores',
                  style: TextStyle(
                    color: ColorPalette.secondary,
                    fontSize: 16.0,
                  ),
                ),
                Text(
                  'UI/UX: Juliana Penna',
                  style: TextStyle(
                    color: ColorPalette.secondary,
                    fontSize: 16.0,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
