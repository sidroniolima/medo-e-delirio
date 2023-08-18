import 'package:json_annotation/json_annotation.dart';

part 'comma.g.dart';

@JsonSerializable()
class Comma {
  final int id;
  final String fileName;
  final String author;
  final String label;
  final String type;

  @JsonKey(name: 'date')
  final DateTime createdAt;

  final String? words;

  Comma(this.id, this.fileName, this.author, this.label, this.type,
      this.createdAt, this.words);

  factory Comma.fromJson(Map<String, dynamic> json) => _$CommaFromJson(json);
}
