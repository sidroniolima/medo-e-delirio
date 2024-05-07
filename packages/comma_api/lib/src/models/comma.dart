import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'comma.g.dart';

///
/// A single Comma. It can be an audio inset or a music.
///
@immutable
@JsonSerializable()
class Comma extends Equatable {
  /// The Comma identifier
  final int id;

  /// The Comma fileName
  final String fileName;

  final String author;
  final String label;
  final String type;

  final String date;

  final String? words;

  final bool favorite;

  /// {@macro Comma}
  const Comma(
      {required this.id,
      required this.fileName,
      required this.author,
      required this.label,
      required this.type,
      this.date = '',
      this.words = '',
      this.favorite = false});

  Comma copyWith(
      {int? id,
      String? fileName,
      String? author,
      String? label,
      String? type,
      String? date,
      String? words,
      bool? favorite}) {
    return Comma(
        id: id ?? this.id,
        fileName: fileName ?? this.fileName,
        author: author ?? this.author,
        label: label ?? this.label,
        type: type ?? this.type,
        date: date ?? this.date,
        words: words ?? this.words,
        favorite: favorite ?? this.favorite);
  }

  static const empty =
      Comma(author: '', label: '', type: '', id: -1, fileName: '');

  static Comma fromJson(Map<String, dynamic> json) => _$CommaFromJson(json);
  Map<String, dynamic> toJson() => _$CommaToJson(this);

  @override
  List<Object?> get props =>
      [id, fileName, author, label, type, date, words, favorite];

  @override
  bool get stringify => true;
}
