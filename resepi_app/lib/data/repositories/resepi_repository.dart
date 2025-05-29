import 'dart:io';
import 'package:fpdart/fpdart.dart';

import '../../common/exception.dart';
import '../../common/failure.dart';
import '../data_sources/data_sources.dart';
import '../models/models.dart';

abstract class ResepiRepository {
  Future<Either<Failure, List<Resepi>>> getAllResepi();
  Future<Either<Failure, Resepi>> getResepiById(int id);
  Future<Either<Failure, bool>> addResepi({
    required String nama,
    required String deskripsi,
    required File imageFile,
    required List<String> bahan,
    required List<String> langkah,
    required int porsi,
  });
  Future<Either<Failure, bool>> updateResepiById({
    required int id,
    required String nama,
    required String deskripsi,
    required File imageFile,
    required List<String> bahan,
    required List<String> langkah,
    required int porsi,
  });
  Future<Either<Failure, bool>> deleteResepiById(int id);
}

class ResepiRepositoryImpl implements ResepiRepository {
  final ResepiRemoteDataSource remoteDataSource;
  final ImageRemoteDataSource imageRemoteDataSource;

  ResepiRepositoryImpl({
    required this.remoteDataSource,
    required this.imageRemoteDataSource,
  });

  @override
  Future<Either<Failure, List<Resepi>>> getAllResepi() async {
    try {
      final result = await remoteDataSource.getAllResepi();
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on ClientException catch (e) {
      return Left(ClientFailure(e.message));
    } on SocketException {
      return const Left(ConnectionFailure('Gagal terhubung ke internet'));
    } catch (e) {
      return Left(
        CommonFailure('Terjadi kesalahan tidak terduga: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, Resepi>> getResepiById(int id) async {
    try {
      final result = await remoteDataSource.getResepiById(id: id);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on ClientException catch (e) {
      return Left(ClientFailure(e.message));
    } on SocketException {
      return const Left(ConnectionFailure('Gagal terhubung ke internet'));
    } catch (e) {
      return Left(
        CommonFailure('Terjadi kesalahan tidak terduga: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, bool>> addResepi({
    required String nama,
    required String deskripsi,
    required File imageFile,
    required List<String> bahan,
    required List<String> langkah,
    required int porsi,
  }) async {
    try {
      final imageUrl = await imageRemoteDataSource.uploadImage(
        imageFile: imageFile,
      );

      final result = await remoteDataSource.addResepi(
        nama: nama,
        deskripsi: deskripsi,
        imageUrl: imageUrl,
        bahan: bahan,
        langkah: langkah,
        porsi: porsi,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on ClientException catch (e) {
      return Left(ClientFailure(e.message));
    } on SocketException {
      return const Left(ConnectionFailure('Gagal terhubung ke internet'));
    } catch (e) {
      return Left(
        CommonFailure(
          'Terjadi kesalahan tidak terduga saat menambah resep: ${e.toString()}',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, bool>> updateResepiById({
    required int id,
    required String nama,
    required String deskripsi,
    required File imageFile,
    required List<String> bahan,
    required List<String> langkah,
    required int porsi,
  }) async {
    try {
      final imageUrl = await imageRemoteDataSource.uploadImage(
        imageFile: imageFile,
      );

      final result = await remoteDataSource.updateResepiById(
        id: id,
        nama: nama,
        deskripsi: deskripsi,
        imageUrl: imageUrl,
        bahan: bahan,
        langkah: langkah,
        porsi: porsi,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on ClientException catch (e) {
      return Left(ClientFailure(e.message));
    } on SocketException {
      return const Left(ConnectionFailure('Gagal terhubung ke internet'));
    } catch (e) {
      return Left(
        CommonFailure(
          'Terjadi kesalahan tidak terduga saat memperbarui resep: ${e.toString()}',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, bool>> deleteResepiById(int id) async {
    try {
      final result = await remoteDataSource.deleteResepiById(id: id);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on ClientException catch (e) {
      return Left(ClientFailure(e.message));
    } on SocketException {
      return const Left(ConnectionFailure('Gagal terhubung ke internet'));
    } catch (e) {
      return Left(
        CommonFailure('Terjadi kesalahan tidak terduga: ${e.toString()}'),
      );
    }
  }
}
