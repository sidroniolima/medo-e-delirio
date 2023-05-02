// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audio.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Audio _$AudioFromJson(Map<String, dynamic> json) => Audio(
      json['id'] as int,
      json['fileName'] as String,
      json['author'] as String,
      json['label'] as String,
      json['type'] as String,
      DateTime.parse(json['date'] as String),
    );

Map<String, dynamic> _$AudioToJson(Audio instance) => <String, dynamic>{
      'id': instance.id,
      'fileName': instance.fileName,
      'author': instance.author,
      'label': instance.label,
      'type': instance.type,
      'date': instance.date.toIso8601String(),
    };
