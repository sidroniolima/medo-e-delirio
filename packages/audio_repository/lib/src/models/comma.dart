import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'comma.g.dart';

@immutable
@JsonSerializable()
class Comma extends Equatable {
  final int id;
  final String fileName;
  final String author;
  final String label;
  final String type;

  final String date;

  final String? words;

  const Comma(
      {required this.id,
      required this.fileName,
      required this.author,
      required this.label,
      required this.type,
      this.date = '',
      this.words = ''});

  static const empty =
      Comma(author: '', label: '', type: '', words: '', id: -1, fileName: '');

  static Comma fromJson(Map<String, dynamic> json) => _$CommaFromJson(json);
  Map<String, dynamic> toJson() => _$CommaToJson(this);

  @override
  List<Object?> get props => [id, fileName, author, label, type, date, words];

  @override
  bool get stringify => true;
}
