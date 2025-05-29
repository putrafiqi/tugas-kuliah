import 'package:json_annotation/json_annotation.dart';

part 'resepi.g.dart';

@JsonSerializable()
class Resepi {
  final int id;
  final String nama;
  final String imageUrl;
  final String deskripsi;
  final int porsi;
  final List<String> bahan;
  final List<String> langkah;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Resepi({
    required this.id,
    required this.nama,
    required this.imageUrl,
    required this.porsi,
    required this.deskripsi,
    required this.bahan,
    required this.langkah,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Resepi.fromJson(Map<String, dynamic> json) => _$ResepiFromJson(json);

  Map<String, dynamic> toJson() => _$ResepiToJson(this);
}
