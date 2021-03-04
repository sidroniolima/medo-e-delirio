import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:http/http.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:medo_e_delirio_app/models/audio.dart';
import 'package:medo_e_delirio_app/widgets/media_panel.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  AudioPlayer audioPlayer;
  int actualIdPlayind = -1;

  @override
  void initState() {
    super.initState();
    audioPlayer = AudioPlayer();
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
        body: Column(
          children: [
            Container(
              height: screenSize.height * .945,
              child: CustomScrollView(slivers: [
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
                SliverGrid.count(
                    crossAxisCount: 3,
                    children: Audio.inserts
                        .map((Audio audio) => MediaPanel(
                              author: audio.author,
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
                        .toList()),
              ]),
            ),
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(8.0),
                      bottomRight: Radius.circular(8.0))),
              child: Text(
                'criado por @sidroniolima',
                style: TextStyle(
                  fontSize: screenSize.width * .03,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
