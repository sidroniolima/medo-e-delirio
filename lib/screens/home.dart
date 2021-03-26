import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:http/http.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:medo_e_delirio_app/models/audio.dart';
import 'package:medo_e_delirio_app/widgets/media_panel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  AudioPlayer audioPlayer;
  int actualIdPlayind = -1;
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  Future<List<String>> _favorites;
  String _PREFNAME = 'MED';

  @override
  void initState() {
    super.initState();
    audioPlayer = AudioPlayer();
    _favorites = _prefs.then((SharedPreferences prefs) {
      return (prefs.getStringList(_PREFNAME) ?? []);
    });
  }

  Future<void> _favorite(int id) async {
    final SharedPreferences prefs = await _prefs;
    final List<String> favorites = (prefs.getStringList(_PREFNAME)) ?? [];

    if (favorites.contains(id.toString())) {
      favorites.remove(id.toString());
    } else {
      favorites.add(id.toString());
    }


    //await Future.delayed(Duration(milliseconds: 5000), () {});
    setState(() {
      _favorites =
          prefs.setStringList(_PREFNAME, favorites).then((bool success) {
        return favorites;
      });
    });
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        body: FutureBuilder(
            future: _favorites,
            builder:
                (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return const CircularProgressIndicator();
                default:
                  Widget sliverFuture;
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                          'oops! Não foi possível retornar os áudios. Tente novamente mais tarde.'),
                    );
                  } else {
                    sliverFuture = SliverGrid.count(
                        crossAxisCount: 3,
                        children: Audio.inserts
                            .map((Audio audio) => MediaPanel(
                                  author: audio.author,
                                  isFavorite: snapshot.data
                                      .contains(audio.id.toString()),
                                  favoriteAction: () async {
                                    await _favorite(audio.id);
                                  },
                                  isPlaying: actualIdPlayind == audio.id,
                                  onLongPress: () async {
                                    setState(() {
                                      this.actualIdPlayind = audio.id;
                                    });

                                    Uint8List bytes = await readBytes(
                                        'https://sidroniolima.com.br/med/mp3/${audio.fileName}');
                                    await Share.file('Sound', audio.fileName,
                                        bytes.buffer.asUint8List(), 'audio/*');

                                    setState(() {
                                      this.actualIdPlayind = -1;
                                    });
                                  },
                                  onPress: () async {
                                    setState(() {
                                      this.actualIdPlayind = audio.id;
                                    });

                                    Uint8List bytes = await readBytes(
                                        'https://sidroniolima.com.br/med/mp3/${audio.fileName}');

                                    audioPlayer.setVolume(1.0);
                                    await audioPlayer.playBytes(bytes);

                                    setState(() {
                                      this.actualIdPlayind = -1;
                                    });
                                  },
                                  screenSize: screenSize,
                                  label: audio.label,
                                ))
                            .toList());
                  }
                  return CustomScrollView(slivers: [
                    SliverAppBar(
                        pinned: false,
                        expandedHeight: screenSize.height * .25,
                        toolbarHeight: 0,
                        flexibleSpace: FlexibleSpaceBar(
                          background: Image.asset(
                            'assets/images/med_full_logo.png',
                            fit: BoxFit.fitHeight,
                          ),
                        )),
                    sliverFuture,
                    SliverAppBar(
                      pinned: false,
                      expandedHeight: screenSize.height * .05,
                      centerTitle: true,
                      title: Text(
                        'criado por @sidroniolima',
                        style: TextStyle(fontSize: screenSize.width * .032),
                      ),
                    ),
                  ]);
              }
            }),
      ),
    );
  }
}
