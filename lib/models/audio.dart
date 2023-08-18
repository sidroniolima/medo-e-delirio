import 'package:json_annotation/json_annotation.dart';

part 'audio.g.dart';

@JsonSerializable()
class Audio {
  int _id;
  String _fileName;
  String _author;
  String _label;
  String _type;
  DateTime _date;

  Audio(int id, String fileName, String author, String label, String type,
      DateTime date)
      : this._id = id,
        this._fileName = fileName,
        this._author = author,
        this._label = label,
        this._type = type,
        this._date = date;

  factory Audio.fromJson(Map<String, dynamic> data) => _$AudioFromJson(data);

  Map<String, dynamic> toJson() => _$AudioToJson(this);
  static List<Audio> inserts = [];

  List<String> get index {
    List<String> sub = (label.replaceAll(',', '')).split(' ');
    sub.removeWhere((element) => element.length <= 3);
    sub.add(author);
    return sub;
  }

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

  DateTime get date => _date;

  set date(DateTime value) {
    _date = value;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Audio &&
          runtimeType == other.runtimeType &&
          _id == other._id &&
          _fileName == other._fileName &&
          _author == other._author &&
          _label == other._label &&
          _type == other._type &&
          _date == other._date;

  @override
  int get hashCode =>
      _id.hashCode ^
      _fileName.hashCode ^
      _author.hashCode ^
      _label.hashCode ^
      _type.hashCode ^
      _date.hashCode;
}
