class Audio {
  int _id;
  String _fileName;
  String _author;
  String _label;
  String _type;

  Audio(this._id, this._fileName, this._author, this._label, this._type);

  static List<Audio> inserts = [
    Audio(1, "Abraham Weintraub - odeio, odeio, odeio short.mp3", "Abraham Weintraub", "Odeio, odeio, odeio", "INSERT"),
    Audio(2, "ADY - oh não mais um crime de responsabilidade.mp3", "ADY", "Mais um crime", "INSERT"),
    Audio(3, "Aham sei short.mp3", "", "Aham, sei", "INSERT"),
    Audio(4, "Alborgeti - Que Merda Hein  MEME short.mp3", "Alborgeti", "Que merda hem", "INSERT"),
    Audio(5, "Away - nao fode mermão short.mp3", "Away", "Não fode mermão", "INSERT"),
    Audio(6, "Away - Para com essa porra aí mermão short.mp3", "Away", "Pára com essa porra", "INSERT"),
    Audio(7, "BENDER Ahh, agora eu entendi short.mp3", "Bender", "Ah! Agora eu entendi", "INSERT"),
    Audio(8, "Boldo - Carrralho caralho.mp3", "Boldo", "Carrralho caralho", "INSERT"),
    Audio(9, "Boldo - Deixa com a cara magoada.mp3", "Boldo", "Deixa com a cara magoada", "INSERT"),
    Audio(10, "Boldo - Esse é o boldo bão.mp3", "Boldo", "Esse é o boldo bão", "INSERT"),
    Audio(11, "Boldo - Muito bom, muito bom.mp3", "Boldo", "Muito bom, muito bom", "INSERT"),
    Audio(12, "Boldo - Parece até que um helicóptero pousou em cima da tua cara.mp3", "Boldo", "Helicóptero", "INSERT"),
    Audio(13, "Boldo - Puta que pariu marquinho.mp3", "Boldo", "PQP, Marquinho", "INSERT"),
    Audio(14, "Boldo - Que boldo bão.mp3", "Boldo", "Que boldo bão", "INSERT"),
    Audio(15, "Bolsonaro - E daí.mp3", "Bolsonaro", "E daí?", "INSERT"),
    Audio(16, "Bolsonaro - Eu não errei nenhuma.mp3", "Bolsonaro", "Eu não errei nenhuma", "INSERT"),
    Audio(17, "Bolsonaro - Lamento, quer que eu faça o que.mp3", "Bolsonaro", "Lamento, quer q eu faça oq?", "INSERT"),
    Audio(18, "Bolsonaro - Não tem como não dar errado vai dar errado.mp3", "Bolsonaro", "Ñ tem com ñ dar errado", "INSERT"),
    Audio(19, "Bolsonaro - Porra.mp3", "Bolsonaro", "Porra", "INSERT"),
    Audio(20, "Bolsonaro - Problemas.mp3", "Bolsonaro", "Problemas", "INSERT"),
    Audio(21, "Bolsonaro - Será que eu tô errando ao falar isso daí.mp3", "Bolsonaro", "Será que eu tô errando?", "INSERT"),
    Audio(22, "Bonitinha mas ordinária - É mentira dele meme short.mp3", "", "É mentira dele", "INSERT"),
    Audio(23, "Bonitinha mas ordinária - Mentira.mp3", "", "Mentira", "INSERT"),
    Audio(24, "BORA (Bam Bam).mp3", "Bam Bam", "Bora", "INSERT"),
    Audio(25, "Boulos Porra short.mp3", "Boulos", "Porra!", "INSERT"),
    Audio(26, "Brizola - Filhotes da ditadura.mp3", "Brizola", "Filhotes da ditadura", "INSERT"),
    Audio(27, "Caetano - Não short.mp3", "Caetano", "Não", "INSERT"),
    Audio(28, "Caetano - Que loucura, que coisa absurda short.mp3", "Caetano", "Que loucura", "INSERT"),
    Audio(29, "CARLA BORA - Bora.mp3", "Carla", "Bora", "INSERT"),
    Audio(30, "Carmina burana trecho.mp3", "Carmina Burana", "Carmina Burana", "INSERT"),
    Audio(31, "Choque de Cultura - Cabô cabô cabô já tá desvirtuando já short.mp3", "Choque", "Ta desvirtuando já", "INSERT"),
    Audio(32, "Choque de Cultura - Falo com tranquilidade.mp3", "Choque", "Falo com tranquilidade", "INSERT"),
    Audio(33, "Choque de Cultura - Renan - é Paradoxo que chama isso aí.mp3", "Choque", "Paradoxo", "INSERT"),
    Audio(34, "Choque de Cultura - Renan - Vamos fazer essa crítica aí.mp3", "Choque", "Vamos fazer essa crítica aí", "INSERT"),
    Audio(35, "Choque de Cultura - Rogerinho - Aqui tem informação.mp3", "Choque", "Aqui tem informação", "INSERT"),
    Audio(36, "CHOQUE DE CULTURA - Rogerinho Às vezes o ódio é a única emoção possível short.mp3", "Choque", "Óidio é a única opção", "INSERT"),
    Audio(37, "Choque de cultura - Rogerinho - Não vamos falar de pornô aqui não.mp3", "Choque", "Não vamos falar de pornô", "INSERT"),
    Audio(38, "Choque de Cultura - Rogerinho - Ó a informação aí.mp3", "Choque", "Olha a informação aí", "INSERT"),
    Audio(39, "Cidade Oculta - Você fala isso porque é a putinha do bozo.mp3", "Cidade Oculta", "Putinha do Bozo", "INSERT"),
    Audio(40, "Ciro Gomes  - Atenção Paulo Guedes.mp3", "Ciro Gomes", "Atenção, Paulo Guedes", "INSERT"),
    Audio(41, "Ciro Gomes - Conspirador filho da puta.mp3", "Ciro Gomes", "Conspirador, FDP", "INSERT"),
    Audio(42, "CIRO GOMES - Paulo Guedes mentiroso tá enganando a rapaeada paulo guedes.mp3", "Ciro Gomes", "Paulo Guedes mentiroso", "INSERT"),
    Audio(43, "Ciro Gomes - Que isso, francamente.mp3", "Ciro Gomes", "Que isso, francamente", "INSERT"),
    Audio(44, "Ciro Gomes - Veja bem, se eu estiver errado me corrija.mp3", "Ciro Gomes", "Veja bem", "INSERT"),
    Audio(45, "com certeza cerginho da perera nunes short.mp3", "Serginho", "Com certeza", "INSERT"),
    Audio(46, "COMUNISTA DO INFERNO meme.mp3", "Doida varrida", "Comunista do inferno", "INSERT"),
    Audio(47, "COMUNISTA MEME.mp3", "Doida varrida", "Comunista", "INSERT"),
    Audio(48, "Costinha - Se fudeu short.mp3", "Costinha", "Se fudeu", "INSERT"),
    Audio(49, "Craque Neto - E cuidado com a cueca hein, cuidado com a cueca.mp3", "Craque Neto", "Cuidado com a cueca, hem", "INSERT"),
    Audio(50, "Drauzio - É verdade quer dizer as vezes não meme short.mp3", "Dráuzio", "É verdade", "INSERT"),
    Audio(51, "Dráuzio - procura um psiquiatra, você não tá legal.mp3", "Dráuzio", "Procura um psiquiatra", "INSERT"),
    Audio(52, "Fernando Collor - Isso é uma mentira uma pantomima uma patuscada short.mp3", "Collor", "Pantomima, pastucada", "INSERT"),
    Audio(53, "Fernando Collor - três vezes dizendo que é mentira.mp3", "Collor", "Três vezes que é mentira", "INSERT"),
    Audio(54, "Fred cê tá falando sério.mp3", "Frec", "Vc ta falando sério?", "INSERT"),
    Audio(55, "Futurama - Então tudo bem short.mp3", "Futurama", "Então tudo bem", "INSERT"),
    Audio(56, "General Mourão Bom Dia short.mp3", "Mourão", "Bom dia", "INSERT"),
    Audio(57, "Gustavo mendes dilma todo mundo se fudeu.mp3", "Gustavo Mendes", "Todo mundo se fudeu", "INSERT"),
    Audio(58, "Hassum - Nem fodendo.mp3", "Hassum", "Nem fodendo", "INSERT"),
    Audio(59, "Hassum - PUTA QUE PARIU.mp3", "Hassum", "Puta que pariu", "INSERT"),
    Audio(60, "Ivete Sangalo - Chupa Toda short meme.mp3", "Ivete Sangalo", "Chupa toda", "INSERT"),
    Audio(61, "Leo Stronda Porra.mp3", "Leo Stronda", "Porra", "INSERT"),
    Audio(62, "Mermão na moral short.mp3", "Futurama", "Mermão na moral", "INSERT"),
    Audio(63, "Michel Temer - Pigarro.mp3", "Michel Temer", "Pigarro", "INSERT"),
    Audio(64, "Michel Temer - Tem que pedir uma pastilha.mp3", "Michel Temer", "Pastilha", "INSERT"),
    Audio(65, "MIDCAST - Teu cu.mp3", "Midcast", "Teu cu", "INSERT"),
  ];

  int get id => _id;

  set id(int value) {
    _id = value;
  }

  String get fileName => _fileName;

  set fileName(String value) {
    _fileName = value;
  }

  String get author => _author;

  set author(String value) {
    _author = value;
  }

  String get label => _label;

  set label(String value) {
    _label = value;
  }

  String get type => _type;

  set type(String value) {
    _type = value;
  }
}
