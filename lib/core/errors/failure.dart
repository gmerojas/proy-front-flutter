abstract class Failure {
  final String message;

  Failure(this.message);
}

class ServerFailure extends Failure {
  ServerFailure(super.message);
}

class NetworkFailure extends Failure {
  NetworkFailure() : super('Sin conexión a internet');
}

class AuthFailure extends Failure {
  AuthFailure(super.message);

  factory AuthFailure.unauthenticated() => AuthFailure('No autenticado');

  factory AuthFailure.unexpected() => AuthFailure('Error inesperado');
}

class ResponseFailure extends Failure {
  ResponseFailure(super.message);
}

class UnexpectedFailure extends Failure {
  UnexpectedFailure() : super('Ha ocurrido un error inesperado');
}