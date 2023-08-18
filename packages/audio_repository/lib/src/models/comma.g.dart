// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comma.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Comma _$CommaFromJson(Map<String, dynamic> json) => Comma(
      json['id'] as int,
      json['fileName'] as String,
      json['author'] as String,
      json['label'] as String,
      json['type'] as String,
      DateTime.parse(json['date'] as String),
      json['words'] as String?,
    );

Map<String, dynamic> _$CommaToJson(Comma instance) => <String, dynamic>{
      'id': instance.id,
      'fileName': instance.fileName,
      'author': instance.author,
      'label': instance.label,
      'type': instance.type,
      'date': instance.createdAt.toIso8601String(),
      'words': instance.words,
    };
