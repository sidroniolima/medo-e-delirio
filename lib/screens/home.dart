import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:http/http.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:medo_e_delirio_app/models/audio.dart';

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
        body: CustomScrollView(slivers: [
          SliverAppBar(
              pinned: false,
              expandedHeight: 150.0,
              titleSpacing: 20,
              flexibleSpace: FlexibleSpaceBar(
                background: Image.asset(
                  'assets/images/med_full_logo.png',
                  fit: BoxFit.fitWidth,
                ),
              )),
          SliverGrid.count(
              crossAxisCount: 3,
              children: Audio.inserts
                  .map((Audio audio) => MediaPanel(
                        author: audio.author,
                        isPlaying: actualIdPlayind == audio.id,
                        onLongPress: () async {
                          Uint8List bytes = await readBytes(
                              'http://sidroniolima.com.br/med/mp3/${audio.fileName}');
                          await Share.file('Sound', audio.fileName,
                              bytes.buffer.asUint8List(), 'audio/*');
                        },
                        onPress: () async {
                          setState(() {
                            this.actualIdPlayind = audio.id;
                          });

                          Uint8List bytes = await readBytes(
                              'http://sidroniolima.com.br/med/mp3/${audio.fileName}');
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
    );
  }
}

class MediaPanel extends StatelessWidget {
  const MediaPanel({
    Key key,
    @required this.onPress,
    @required this.screenSize,
    @required this.label,
    @required this.isPlaying,
    @required this.author,
    this.onLongPress,
  }) : super(key: key);

  final Function onPress;
  final Size screenSize;
  final String label;
  final String author;
  final bool isPlaying;
  final Function onLongPress;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: this.onPress,
      onLongPress: this.onLongPress,
      child: Container(
        margin: EdgeInsets.symmetric(
            vertical: screenSize.width * .01,
            horizontal: screenSize.width * .01),
        padding: EdgeInsets.all(screenSize.width * .02),
        width: screenSize.width * .35,
        height: screenSize.height * .1,
        decoration: BoxDecoration(
            color: Color(0XFF629460), borderRadius: BorderRadius.circular(8.0)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              this.label,
              overflow: TextOverflow.clip,
            ),
            Spacer(),
            Padding(
              padding: EdgeInsets.only(bottom: screenSize.width * .02),
              child: Text(
                this.author,
                overflow: TextOverflow.clip,
                style: TextStyle(fontSize: 12.0, color: Colors.yellow),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: isPlaying
                  ? SizedBox(
                      width: 12,
                      height: 12,
                      child: Center(
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.white,
                          strokeWidth: 1.0,
                        ),
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                            child: FaIcon(
                              FontAwesomeIcons.shareAlt,
                              size: 12,
                              color: Colors.white,
                            ),
                            onTap: this.onLongPress),
                        FaIcon(
                          FontAwesomeIcons.play,
                          size: 12.0,
                          color: Colors.white,
                        ),
                      ],
                    ),
            )
          ],
        ),
      ),
    );
  }
}
