import 'dart:io';
import 'dart:typed_data';

import 'package:http/http.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:medo_e_delirio_app/models/audio.dart';
import 'package:medo_e_delirio_app/widgets/media_panel.dart';

import '../color_palette.dart';
import '../exceptions/custom_firebase_messaging_exception.dart';
import '../services/topic_subscription_service.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late AudioPlayer audioPlayer;
  int actualIdPlayind = -1;
  bool opened = false;
  List<Audio> audios = Audio.inserts.reversed.toList();
  String order = 'Mais recentes';
  String search = '';
  final searchController = TextEditingController();

  final TopicSubscriptionService subscriptionService =
      TopicSubscriptionService();

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

  Future<void> _init(BuildContext context) async {
    List<String> topics = ['all'];
    subscriptionService.subscribeIfAlreadyNot(topics);
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
          body: FutureBuilder(
        future: _init(context),
        builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return CircularProgressIndicator(
                backgroundColor: Color(0XFF243119),
                strokeWidth: 1.5,
              );
            default:
              if (snapshot.hasError) {
                if (snapshot.error is CustomFirebaseMessagingException) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text('Error')));
                }
                return Center(
                    child: Text('Problema. Tente novamente em instantes.'));
              } else {
                return Stack(
                  children: [
                    CustomScrollView(
                      slivers: [
                        SliverAppBar(
                          backgroundColor: Color(0XFF243119),
                          pinned: false,
                          expandedHeight: screenSize.height * .25,
                          toolbarHeight: screenSize.height * .1,
                          flexibleSpace: FlexibleSpaceBar(
                            background: Image.asset(
                              'assets/images/med_full_logo.png',
                              fit: BoxFit.fitHeight,
                            ),
                          ),
                          automaticallyImplyLeading: true,
                          actions: [
                            Container(
                              margin: EdgeInsets.only(
                                  top: screenSize.height * .004,
                                  right: screenSize.width * 0.05),
                              decoration: BoxDecoration(
                                  color: ColorPalette.primary,
                                  shape: BoxShape.circle),
                              child: Center(
                                child: IconButton(
                                  onPressed: () {
                                    this.setState(() {
                                      opened = !opened;
                                    });
                                  },
                                  icon: Icon(FontAwesomeIcons.search,
                                      color: ColorPalette.tertiary,
                                      size: screenSize.height * .03),
                                  highlightColor: Colors.red,
                                ),
                              ),
                            )
                          ],
                        ),
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
                                            Uri.https('sidroniolima.com.br',
                                                '/med/mp3/${audio.fileName}'));

                                        final temp =
                                            await getTemporaryDirectory();
                                        final path =
                                            '${temp.path}/${audio.fileName}';

                                        File(path).writeAsBytesSync(bytes);

                                        /*await Share.shareFiles([path],
                                            mimeTypes: ['audio/mpeg']);*/

                                        setState(() {
                                          this.actualIdPlayind = -1;
                                        });
                                      },
                                      onPress: () async {
                                        setState(() {
                                          this.actualIdPlayind = audio.id;
                                        });

                                        /*Uint8List bytes = await readBytes(Uri.https(
                                    'sidroniolima.com.br',
                                    '/med/mp3/${audio.fileName}'));*/

                                        audioPlayer.setVolume(1.0);
                                        audioPlayer.setUrl(
                                            'https://sidroniolima.com.br/med/mp3/${audio.fileName}');
                                        await audioPlayer.play();

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
                          backgroundColor: Color(0XFF243119),
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
                        padding: EdgeInsets.symmetric(
                            vertical: screenSize.height * 0.03,
                            horizontal: screenSize.width * 0.08),
                        width: screenSize.width,
                        height: screenSize.height - screenSize.height * .285,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          color: Color(0XFF629460),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Oh, cara. Pague uma cerveja ao desenvolvedor por PIX.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: screenSize.height * 0.02,
                                color: Colors.yellowAccent,
                              ),
                            ),
                            SizedBox(
                              height: screenSize.height * 0.025,
                            ),
                            SelectableText(
                              '10171295765',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                letterSpacing: 2,
                                fontSize: screenSize.height * 0.03,
                                color: Colors.yellowAccent,
                              ),
                            ),
                            SizedBox(
                              height: screenSize.height * 0.06,
                            ),
                            InputDecorator(
                              decoration: InputDecoration(
                                labelText: 'Ordenação',
                                labelStyle: Theme.of(context)
                                    .primaryTextTheme
                                    .bodySmall
                                    ?.copyWith(
                                        color: Color(0XFF243119),
                                        fontSize: screenSize.height * 0.025),
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
                                    () => order = 'Descrição',
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: screenSize.height * 0.025,
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
                              height: screenSize.height * 0.025,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                OutlinedButton(
                                  onPressed: () {
                                    this.setState(() {
                                      this.search = '';
                                      this.searchController.clear();
                                      this.order = 'Mais recentes';
                                      this.audios = Audio.inserts;
                                      this.audios.sort((Audio a, Audio b) =>
                                          b.id.compareTo(a.id));
                                      this.opened = false;
                                    });
                                  },
                                  child: Text('limpar'),
                                  style: OutlinedButton.styleFrom(
                                      foregroundColor: Color(0XFF243119),
                                      side: BorderSide(
                                          width: 1, color: Color(0XFF243119)),
                                      backgroundColor: Colors.transparent,
                                      textStyle: TextStyle(
                                        fontSize: screenSize.height * 0.02,
                                      )),
                                ),
                                SizedBox(
                                  width: screenSize.width * .01,
                                ),
                                TextButton(
                                  onPressed: () {
                                    FocusScopeNode currentFocus =
                                        FocusScope.of(context);

                                    if (!currentFocus.hasPrimaryFocus) {
                                      currentFocus.unfocus();
                                    }

                                    this.setState(() {
                                      this.audios = Audio.inserts;

                                      if (this
                                          .searchController
                                          .text
                                          .isNotEmpty) {
                                        String search = this
                                            .searchController
                                            .text
                                            .toLowerCase()
                                            .trim();

                                        this.audios = this
                                            .audios
                                            .where((Audio audio) =>
                                                audio.label
                                                    .toLowerCase()
                                                    .contains(search) ||
                                                audio.author
                                                    .toLowerCase()
                                                    .contains(search))
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
                                      foregroundColor: Colors.yellow,
                                      backgroundColor: Color(0XFF243119),
                                      textStyle: TextStyle(
                                        fontSize: screenSize.height * 0.02,
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
                                  size: screenSize.height * 0.05,
                                ),
                                Flexible(
                                  child: Text(
                                    'Toque no Card para ouvir e mantenha pressionado para compartilhar.',
                                    style: TextStyle(
                                        fontSize: screenSize.height * 0.02,
                                        color: Color(0XFF243119)),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }
          }
        },
      )),
    );
  }
}
