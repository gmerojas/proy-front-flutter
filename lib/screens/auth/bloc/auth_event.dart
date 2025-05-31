import 'package:equatable/equatable.dart';
import 'package:flutter_bloc_one/data/repositories/auth_repository.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AuthStarted extends AuthEvent {}

class AuthLogout extends AuthEvent {}

class BiometricLoginRequested extends AuthEvent {}

class LoginRequested extends AuthEvent {
  final LoginParams params;

  const LoginRequested(this.params);

  @override
  List<Object> get props => [params];
}
