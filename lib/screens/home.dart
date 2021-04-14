import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:medo_e_delirio_app/models/audio.dart';
import 'package:medo_e_delirio_app/widgets/media_panel.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/audio.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  AudioPlayer audioPlayer;
  int actualIdPlayind = -1;
  bool opened = false;
  List<Audio> audios = Audio.inserts;
  String order = 'Descrição';
  String search = '';
  final searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
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
    Size screenSize = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            CustomScrollView(
              slivers: [
                SliverAppBar(
                  pinned: false,
                  expandedHeight: screenSize.height * .25,
                  toolbarHeight: 60.0,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Image.asset(
                      'assets/images/med_full_logo.png',
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                  automaticallyImplyLeading: true,
                  actions: [
                    Container(
                      margin: EdgeInsets.only(top: 20.0),
                      decoration: BoxDecoration(
                          color: Color(0XFF629460), shape: BoxShape.circle),
                      child: Center(
                        child: IconButton(
                          onPressed: () {
                            this.setState(() {
                              opened = !opened;
                            });
                          },
                          icon: Icon(FontAwesomeIcons.cog,
                              color: Colors.yellow, size: 22.0),
                          highlightColor: Colors.red,
                        ),
                      ),
                    )
                  ],
                  //bottom: PreferredSize(child: IconButton(onPressed: () {}, icon: Icon(FontAwesomeIcons.bars, color: Color(0XFF243119), size: 25.0)), preferredSize: Size.fromHeight(90.0)),
                ),
                /*SliverAppBar(
                    pinned: false,
                    expandedHeight: screenSize.height * .02,
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: Icon(FontAwesomeIcons.cog, color: Colors.yellow, size: 22.0),
                          highlightColor: Colors.red,
                        ),
                        */ /*DropdownButton<String>(
                          value: dropdownValue,
                          icon: const Icon(Icons.arrow_downward, color: Color(0XFF629460),),
                          iconSize: 24,
                          elevation: 16,
                          style: const TextStyle(color: Color(0XFF629460)),
                          underline: Container(
                            height: 0,
                          ),
                          onChanged: (String newValue) {
                            setState(() {
                              dropdownValue = newValue;
                            });
                          },
                          items: <String>['Título', 'Autor', 'Mais novos'].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),

                            );
                          }).toList(),
                        ),*/ /*
                      ],
                    )),*/
                SliverGrid.count(
                    crossAxisCount: 3,
                    children: this
                        .audios
                        .map((Audio audio) => MediaPanel(
                              author: audio.author,
                              isFavorite: false,
                              favoriteAction: () {},
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
                SliverAppBar(
                  pinned: false,
                  expandedHeight: screenSize.height * .05,
                  centerTitle: true,
                  title: Text(
                    'criado por @sidroniolima',
                    style: TextStyle(fontSize: screenSize.width * .032),
                  ),
                ),
              ],
            ),
            AnimatedPositioned(
              duration: Duration(milliseconds: 250),
              top: screenSize.height * .255,
              left: this.opened ? 0 : screenSize.width,
              curve: Curves.easeInCirc,
              child: Container(
                width: screenSize.width,
                height: screenSize.height - screenSize.height * .285,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: Color(0XFF629460),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 16.0, horizontal: 12.0),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 16.0,
                      ),
                      InputDecorator(
                        decoration: InputDecoration(
                          labelText: 'Ordenação',
                          labelStyle: Theme.of(context)
                              .primaryTextTheme
                              .caption
                              .copyWith(
                                  color: Color(0XFF243119), fontSize: 16.0),
                          border: const OutlineInputBorder(),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton(
                            isExpanded: true,
                            isDense: true,
                            // Reduces the dropdowns height by +/- 50%
                            icon: Icon(Icons.keyboard_arrow_down,
                                color: Color(0XFF243119)),
                            value: this.order,
                            items: <String>[
                              'Descrição',
                              'Autor',
                              'Mais recentes'
                            ].map((item) {
                              return DropdownMenuItem(
                                value: item,
                                child: Text(item),
                              );
                            }).toList(),
                            onChanged: (selectedItem) => setState(
                              () => order = selectedItem,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 16.0,
                      ),
                      TextField(
                        controller: this.searchController,
                        decoration: const InputDecoration(
                            hintText: 'digite sua pesquisa',
                            labelText: 'Pesquisa',
                            border: const OutlineInputBorder(),
                            focusedBorder: const OutlineInputBorder()),
                      ),
                      SizedBox(
                        height: 16.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          OutlinedButton(
                            onPressed: () {
                              this.setState(() {
                                this.search = '';
                                this.searchController.clear();
                                this.order = 'Descrição';
                                this.audios = Audio.inserts;
                                this.opened = false;
                              });
                            },
                            child: Text('limpar'),
                            style: OutlinedButton.styleFrom(
                                primary: Color(0XFF243119),
                                side: BorderSide(
                                    width: 1, color: Color(0XFF243119)),
                                backgroundColor: Colors.transparent,
                                textStyle: TextStyle(
                                  fontSize: 14,
                                )),
                          ),
                          SizedBox(
                            width: screenSize.width * .01,
                          ),
                          TextButton(
                            onPressed: () {
                              FocusScopeNode currentFocus = FocusScope.of(context);

                              if (!currentFocus.hasPrimaryFocus) {
                                currentFocus.unfocus();
                              }

                              this.setState(() {
                                this.audios = Audio.inserts;

                                if (this.searchController.text.isNotEmpty) {
                                  this.audios = this
                                      .audios
                                      .where((Audio audio) =>
                                          audio.label.toLowerCase().contains(
                                              this
                                                  .searchController
                                                  .text
                                                  .toLowerCase()) ||
                                          audio.author.toLowerCase().contains(
                                              this
                                                  .searchController
                                                  .text
                                                  .toLowerCase()))
                                      .toList();
                                }

                                switch (this.order) {
                                  case 'Descrição':
                                    this.audios.sort((Audio a, Audio b) =>
                                        a.label.compareTo(b.label));
                                    break;
                                  case 'Autor':
                                    this.audios.sort((Audio a, Audio b) =>
                                        a.author.compareTo(b.author));
                                    break;
                                  case 'Mais recentes':
                                    this.audios.sort((Audio a, Audio b) =>
                                        b.id.compareTo(a.id));
                                    break;
                                  default:
                                }

                                this.opened = false;
                              });
                            },
                            child: Text('filtrar'),
                            style: TextButton.styleFrom(
                                primary: Colors.yellow,
                                backgroundColor: Color(0XFF243119),
                                textStyle: TextStyle(
                                  fontSize: 14,
                                )),
                          ),
                        ],
                      ),
                      Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            FontAwesomeIcons.question,
                            color: Color(0XFF243119),
                            size: 32,
                          ),
                          Container(
                              width: screenSize.width * .8,
                              child: Text(
                                'Toque no Card para ouvir e mantenha pressionado para compartilhar.',
                                style: TextStyle(
                                    fontSize: 14.0, color: Color(0XFF243119)),
                              ))
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
