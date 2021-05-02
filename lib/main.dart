import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import 'package:provider/provider.dart';
import 'package:medo_e_delirio_app/screens/home.dart';
import 'package:medo_e_delirio_app/viewModels/audio_list_view_model.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        brightness: Brightness.light,
        fontFamily: 'Montserrat',
        primaryColor: Color(0XFF243119),
        scaffoldBackgroundColor: Color(0XFF243119),
        accentColor: Color(0XFF629460),
        textTheme: TextTheme(
          bodyText2: TextStyle(color: Colors.white, fontSize: 14),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: ChangeNotifierProvider(
        create: (context) => AudioListViewModel(),
        child: Home(),
      ),
    );
  }
}
