abstract class Failure {
  final String message;

  Failure(this.message);
}

class ServerFailure extends Failure {
  ServerFailure(String message) : super(message);
}

class NetworkFailure extends Failure {
  NetworkFailure() : super('Sin conexión a internet');
}

class AuthFailure extends Failure {
  AuthFailure(String message) : super(message);
}

class ResponseFailure extends Failure {
  ResponseFailure(String message) : super(message);
}

class UnexpectedFailure extends Failure {
  UnexpectedFailure() : super('Ha ocurrido un error inesperado');
}