import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart';
import 'package:just_audio/just_audio.dart';
import 'package:medo_e_delirio_app/screens/search_modal.dart';
import 'package:medo_e_delirio_app/widgets/default_error_message.dart';
import 'package:medo_e_delirio_app/widgets/default_progress_indicator.dart';
import 'package:medo_e_delirio_app/widgets/media_panel.dart';
import 'package:path_provider/path_provider.dart';

import '../color_palette.dart';
import '../models/audio.dart';
import '../services/topic_subscription_service.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final searchController = TextEditingController();
  late AudioPlayer audioPlayer;
  int actualIdPlayind = -1;

  final TopicSubscriptionService subscriptionService =
      TopicSubscriptionService();

  Future<List<Audio>> _init(String search) async {
    List<Audio> audios = [];

    await FirebaseFirestore.instance
        .collection('audios')
        .orderBy('id', descending: true)
        .get()
        .then((QuerySnapshot querySnapshot) => {
              querySnapshot.docs.forEach((document) {
                Map<String, dynamic> data =
                    document.data()! as Map<String, dynamic>;
                audios.add(Audio.fromJson(data));
              })
            });

    return audios;
  }

  @override
  void initState() {
    super.initState();
    List<String> topics = ['all'];
    subscriptionService.subscribeIfAlreadyNot(topics);
    audioPlayer = AudioPlayer();
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size _screenSize = MediaQuery.of(context).size;

    ScrollController _scrollController = ScrollController();
    return SafeArea(
      child: Scaffold(
        body: CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverAppBar(
              backgroundColor: Color(0XFF243119),
              pinned: false,
              expandedHeight: _screenSize.height * .25,
              toolbarHeight: _screenSize.height * .1,
              /*flexibleSpace: FlexibleSpaceBar(
                background: Image.asset(
                  'assets/images/med_full_logo.png',
                  fit: BoxFit.fitHeight,
                ),
              ),*/
              actions: [
                Container(
                  margin: EdgeInsets.only(
                      top: _screenSize.height * .004,
                      right: _screenSize.width * 0.05),
                  decoration: BoxDecoration(
                      color: ColorPalette.primary, shape: BoxShape.circle),
                  child: Center(
                    child: IconButton(
                      onPressed: () async {
                        List<String>? search = await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => SearchModal(),
                            fullscreenDialog: true,
                          ),
                        );
                      },
                      icon: Icon(FontAwesomeIcons.question,
                          color: ColorPalette.tertiary,
                          size: _screenSize.height * .025),
                      highlightColor: ColorPalette.primary,
                    ),
                  ),
                )
              ],
              automaticallyImplyLeading: true,
            ),
            SliverToBoxAdapter(
              child: FutureBuilder(
                future: _init(''),
                builder: (BuildContext context,
                    AsyncSnapshot<List<Audio>> snapshot) {
                  if (snapshot.hasError) {
                    return DefaultErrorMessage(action: () {
                      //this._search([]);
                      this.setState(() {});
                    });
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return DefaultProgressIndicator(
                        message: 'Calma, fdp. Calma!');
                  }

                  List<Audio> audios = snapshot.hasData ? snapshot.data! : [];

                  return Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(_screenSize.width * 0.02),
                        child: TextField(
                          style: TextStyle(
                              color: ColorPalette.secondary,
                              fontSize: _screenSize.width * 0.04),
                          controller: this.searchController,
                          decoration: InputDecoration(
                            labelStyle:
                                TextStyle(color: ColorPalette.secondary),
                            hintStyle: TextStyle(color: ColorPalette.secondary),
                            hintText: 'pesquisa rápida',
                            labelText: 'Pesquisa',
                            enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: ColorPalette.secondary)),
                            border: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: ColorPalette.secondary)),
                            focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: ColorPalette.secondary)),
                          ),
                        ),
                      ),
                      GridView.count(
                        controller: _scrollController,
                        crossAxisCount: 3,
                        shrinkWrap: true,
                        children: audios.map((Audio audio) {
                          return MediaPanel(
                            author: audio.author,
                            isFavorite: false,
                            favoriteAction: () {},
                            isPlaying: false,
                            onLongPress: () async {
                              setState(() {
                                //this.actualIdPlayind = audio.id;
                              });

                              Uint8List bytes = await readBytes(Uri.https(
                                  'sidroniolima.com.br',
                                  '/med/mp3/${audio.fileName}'));

                              final temp = await getTemporaryDirectory();
                              final path = '${temp.path}/${audio.fileName}';

                              File(path).writeAsBytesSync(bytes);

                              /*await Share.shareFiles([path],
                                  mimeTypes: ['audio/mpeg']);
                                  */

                              setState(() {
                                //this.actualIdPlayind = -1;
                              });
                            },
                            onPress: () async {
                              setState(() {
                                //this.actualIdPlayind = audio.id;
                              });
                              audioPlayer.setVolume(1.0);
                              audioPlayer.setUrl(
                                  'https://sidroniolima.com.br/med/mp3/${audio.fileName}');
                              await audioPlayer.play();

                              setState(() {
                                this.actualIdPlayind = -1;
                              });
                            },
                            screenSize: _screenSize,
                            label: audio.label,
                          );
                        }).toList(),
                      ),
                    ],
                  );
                },
              ),
            ),
            SliverAppBar(
              pinned: false,
              backgroundColor: Color(0XFF243119),
              expandedHeight: _screenSize.height * .05,
              centerTitle: true,
              title: Text(
                'criado por @sidroniolima',
                style: TextStyle(
                    fontSize: _screenSize.width * .032,
                    color: ColorPalette.secondary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
