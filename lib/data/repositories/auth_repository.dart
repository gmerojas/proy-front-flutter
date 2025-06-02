import 'package:dartz/dartz.dart';
import 'package:flutter_bloc_one/core/errors/failure.dart';
import 'package:flutter_bloc_one/data/data_source/auth_local_data_source.dart';
import 'package:flutter_bloc_one/data/models/user_model.dart';
import 'package:flutter_bloc_one/data/services/auth_service.dart';
import 'package:local_auth/local_auth.dart';

class AuthRepository {
  final AuthService authService;
  final LocalAuthentication localAuth;
  final AuthLocalDataSource localDataSource;
  AuthRepository(this.authService, this.localAuth, this.localDataSource);

  Future<Either<Failure, UserModel>> checkLogged() async {
    try{
      final isLogged = await localDataSource.isLogged();
      await Future.delayed(Duration(seconds: 2));

      if (!isLogged) return Left(AuthFailure.unauthenticated());

      final userLogged = await localDataSource.getLoggedUser();
      if(userLogged == null) return Left(AuthFailure.unauthenticated());
      
      var token = await localDataSource.getToken();
      if (token == null) return Left(AuthFailure.unauthenticated());

      return Right(userLogged);
    } catch(e){
      return Left(AuthFailure('Error al verificar autenticado'));
    }
  }
  
  Future<Either<Failure, UserModel>> login(LoginParams params) async {
    try{
      final apiResponse = await authService.login(params.username, params.password);

      await localDataSource.persistLoginData(token: apiResponse.token, user: apiResponse.user);

      return Right(apiResponse.user);
    } on Failure catch(failure){
      return Left(failure);
    }
  }

  Future<Either<Failure, void>> logout() async {
    try {
      await localDataSource.clearSession();
      return Right(null);
    } catch (_) {
      return Left(AuthFailure('Error al cerrar sesión'));
    }
  }

    Future<Either<Failure, UserModel>> checkOldAuth() async {
    try{
      final canCheck = await localAuth.canCheckBiometrics;
      final supported = await localAuth.isDeviceSupported();
      if (!canCheck || !supported) return Left(AuthFailure('Biometría no soportada'));

      final authenticated = await localDataSource.authenticate();
      if (!authenticated) return Left(AuthFailure('Cancelado'));

      final token = await localDataSource.getToken();
      final userLogged = await localDataSource.getLoggedUser();
      if (token == null || userLogged == null) return Left(AuthFailure('No autenticado'));

      return Right(userLogged);
    } on Failure catch(failure){
      return Left(failure);
    }
  }
}

class LoginParams {
  final String username;
  final String password;

  LoginParams({
    required this.username, 
    required this.password
  });
}