// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comma.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Comma _$CommaFromJson(Map<String, dynamic> json) => Comma(
      id: json['id'] as int,
      fileName: json['fileName'] as String,
      author: json['author'] as String,
      label: json['label'] as String,
      type: json['type'] as String,
      date: json['date'] as String? ?? '',
      words: json['words'] as String? ?? '',
    );

Map<String, dynamic> _$CommaToJson(Comma instance) => <String, dynamic>{
      'id': instance.id,
      'fileName': instance.fileName,
      'author': instance.author,
      'label': instance.label,
      'type': instance.type,
      'date': instance.date,
      'words': instance.words,
    };
