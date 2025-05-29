import 'dart:io';
import 'package:resepi_app/common/exception.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:path/path.dart' as p;

abstract interface class ImageRemoteDataSource {
  Future<String> uploadImage({required File imageFile});
  Future<bool> deleteImage({required String imageUrl});
}

class SupabaseImageRemoteDataSourceImpl implements ImageRemoteDataSource {
  final SupabaseClient _client;
  final String _bucketName;

  SupabaseImageRemoteDataSourceImpl(
    this._client, {
    String bucketName = 'resepi-images',
  }) : _bucketName = bucketName;

  @override
  Future<String> uploadImage({required File imageFile}) async {
    try {
      final String fileName = p.basename(imageFile.path);
      final String uniquePath =
          '${DateTime.now().millisecondsSinceEpoch}_$fileName';

      await _client.storage
          .from(_bucketName)
          .upload(
            uniquePath,
            imageFile,
            fileOptions: const FileOptions(cacheControl: '3600', upsert: true),
          );

      final String fullPublicUrl = _client.storage
          .from(_bucketName)
          .getPublicUrl(uniquePath);
      return fullPublicUrl;
    } on StorageException catch (e) {
      throw ServerException('Failed to upload image to Supabase: ${e.message}');
    } catch (e) {
      throw ServerException(
        'An unexpected error occurred during Supabase image upload: $e',
      );
    }
  }

  @override
  Future<bool> deleteImage({required String imageUrl}) async {
    try {

      final Uri uri = Uri.parse(imageUrl);
      final List<String> pathSegments = uri.pathSegments;

      int publicIndex = pathSegments.indexOf('public');
      int bucketIndex = publicIndex + 1;

      if (publicIndex == -1 || bucketIndex >= pathSegments.length || pathSegments[bucketIndex] != _bucketName) {
        throw const ServerException('Invalid image URL format or bucket name mismatch.');
      }

      final String filePathInBucket = pathSegments.sublist(bucketIndex + 1).join('/');

      if (filePathInBucket.isEmpty) {
        throw const ServerException('File path in URL is empty. Cannot delete.');
      }


      await _client.storage.from(_bucketName).remove([filePathInBucket]);

      return true;
    } on StorageException catch (e) {
      throw ServerException('Failed to delete image from Supabase: ${e.message}');
    } catch (e) {
      throw ServerException(
        'An unexpected error occurred during Supabase image deletion: $e',
      );
    }
  }
}
