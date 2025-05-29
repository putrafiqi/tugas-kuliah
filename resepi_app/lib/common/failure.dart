abstract class Failure {
  final String message;
  const Failure(this.message);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Failure && other.message == message;
  }

  @override
  int get hashCode => message.hashCode;
}

class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

class ConnectionFailure extends Failure {
  const ConnectionFailure(super.message);
}

class ClientFailure extends Failure {
  const ClientFailure(super.message);
}

class CommonFailure extends Failure {
  const CommonFailure(super.message);
}
