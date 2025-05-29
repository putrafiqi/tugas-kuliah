// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'resepi.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Resepi _$ResepiFromJson(Map<String, dynamic> json) => Resepi(
  id: (json['id'] as num).toInt(),
  nama: json['nama'] as String,
  imageUrl: json['imageUrl'] as String,
  porsi: (json['porsi'] as num).toInt(),
  deskripsi: json['deskripsi'] as String,
  bahan: (json['bahan'] as List<dynamic>).map((e) => e as String).toList(),
  langkah: (json['langkah'] as List<dynamic>).map((e) => e as String).toList(),
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$ResepiToJson(Resepi instance) => <String, dynamic>{
  'id': instance.id,
  'nama': instance.nama,
  'imageUrl': instance.imageUrl,
  'deskripsi': instance.deskripsi,
  'porsi': instance.porsi,
  'bahan': instance.bahan,
  'langkah': instance.langkah,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
};
