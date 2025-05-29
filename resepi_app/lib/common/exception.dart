class ServerException implements Exception {
  final String message;

  const ServerException([this.message = 'Terjadi Kesalahan, coba lagi']);
}

class ClientException implements Exception {
  final String message;
  const ClientException([this.message = 'Terjadi Kesalahan, coba lagi']);
}
