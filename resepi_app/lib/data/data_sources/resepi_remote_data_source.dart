import 'dart:convert';

import 'package:http/http.dart' as http;
import '../../common/constant.dart';
import '../../common/exception.dart';
import '../models/models.dart';

abstract interface class ResepiRemoteDataSource {
  Future<List<Resepi>> getAllResepi();
  Future<bool> addResepi({
    required String nama,
    required String deskripsi,
    required String imageUrl,
    required List<String> bahan,
    required List<String> langkah,
    required int porsi,
  });
  Future<Resepi> getResepiById({required int id});
  Future<bool> deleteResepiById({required int id});
  Future<bool> updateResepiById({
    required int id,
    required String nama,
    required String deskripsi,
    required String imageUrl,
    required List<String> bahan,
    required List<String> langkah,
    required int porsi,
  });
}

class ResepiRemoteDataSourceImpl implements ResepiRemoteDataSource {
  final http.Client _client;

  ResepiRemoteDataSourceImpl(http.Client? client)
    : _client = client ?? http.Client();

  @override
  Future<bool> addResepi({
    required String nama,
    required String deskripsi,
    required String imageUrl,
    required List<String> bahan,
    required List<String> langkah,
    required int porsi,
  }) async {
    final url = Uri.parse(baseURL);
    final response = await _client.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'nama': nama,
        'deskripsi': deskripsi,
        'imageUrl': imageUrl,
        'bahan': bahan,
        'langkah': langkah,
        'porsi': porsi,
      }),
    );
    if (response.statusCode != 201) {
      throw ServerException(response.body);
    }
    return true;
  }

  @override
  Future<bool> deleteResepiById({required int id}) async {
    final url = Uri.parse('$baseURL/$id');
    final response = await _client.delete(url);
    if (response.statusCode == 404) {
      throw ClientException('Tidak ada data resepi dengan id $id');
    } else if (response.statusCode >= 500) {
      throw ServerException();
    }
    return true;
  }

  @override
  Future<List<Resepi>> getAllResepi() async {
    final url = Uri.parse(baseURL);
    final response = await _client.get(url);
    if (response.statusCode != 200) {
      throw ServerException();
    }
    final data = jsonDecode(response.body) as Map<String, dynamic>;

    final List<dynamic> resepiList = data['data'];
    return resepiList.map((json) => Resepi.fromJson(json)).toList();
  }

  @override
  Future<Resepi> getResepiById({required int id}) async {
    final url = Uri.parse('$baseURL/$id');
    final response = await _client.get(url);
    if (response.statusCode == 404) {
      throw ClientException('Tidak ada data resepi dengan id $id');
    } else if (response.statusCode >= 500) {
      throw ServerException();
    }
    final data = jsonDecode(response.body) as Map<String, dynamic>;
    return Resepi.fromJson(data['data']);
  }

  @override
  Future<bool> updateResepiById({
    required int id,
    required String nama,
    required String deskripsi,
    required String imageUrl,
    required List<String> bahan,
    required List<String> langkah,
    required int porsi,
  }) async {
    final url = Uri.parse('$baseURL/$id');
    final response = await _client.put(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'nama': nama,
        'deskripsi': deskripsi,
        'imageUrl': imageUrl,
        'bahan': bahan,
        'langkah': langkah,
        'porsi': porsi,
      }),
    );
    if (response.statusCode == 404) {
      throw ClientException('Tidak ada data resepi dengan id $id');
    } else if (response.statusCode >= 500) {
      throw ServerException(response.body);
    } else if (response.statusCode != 200) {
      throw ServerException(response.body);
    }
    return true;
  }
}
