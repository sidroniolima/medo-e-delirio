class Tip {
  int _id;
  DateTime _date;
  String _title;
  String _description;

  Tip(this._id, this._date, this._title, this._description);

  int get id => _id;

  set id(int value) {
    _id = value;
  }

  DateTime get date => _date;

  set date(DateTime value) {
    _date = value;
  }

  String get title => _title;

  String get description => _description;

  set description(String value) {
    _description = value;
  }

  set title(String value) {
    _title = value;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Tip &&
          runtimeType == other.runtimeType &&
          _id == other._id &&
          _date == other._date &&
          _title == other._title &&
          _description == other._description;

  @override
  int get hashCode => _id.hashCode ^ _date.hashCode ^ _title.hashCode ^ _description.hashCode;
}