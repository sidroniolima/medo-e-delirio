class Audio {
  int _id;
  String _fileName;
  String _author;
  String _label;

  Audio(this._id, this._fileName, this._author, this._label);

  int get id => _id;
  String get fileName => _fileName;
  String get author => _author;
  String get label => _label;

  factory Audio.fromJson(Map<String, dynamic> json) {
    return Audio(json['id'], json['filename'], json['author'], json['label']);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Audio &&
          runtimeType == other.runtimeType &&
          _id == other._id &&
          _fileName == other._fileName &&
          _author == other._author &&
          _label == other._label;

  @override
  int get hashCode =>
      _id.hashCode ^ _fileName.hashCode ^ _author.hashCode ^ _label.hashCode;

  static List<Audio> inserts = [
    Audio(1, "Abraham Weintraub - odeio, odeio, odeio short.mp3",
        "Abraham Weintraub", "Odeio, odeio, odeio")
  ];
}
