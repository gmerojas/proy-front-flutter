import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_bloc_one/config/storage.dart';
import 'package:flutter_bloc_one/core/errors/failure.dart';
import 'package:flutter_bloc_one/core/services/service_locator.dart';
import 'package:flutter_bloc_one/data/models/user_model.dart';
import 'package:flutter_bloc_one/data/services/auth_service.dart';

class AuthRepository {
  final AuthService authService;
  AuthRepository(this.authService);

  Future<Either<Failure, UserModel>> checkLogged() async {
    try{
      final isLogged = await sl<Storage>().getValue('isLogged');
      await Future.delayed(Duration(seconds: 2));

      if (isLogged != null && isLogged == 'true'){
        var token = await sl<Storage>().getToken();
        final user = await sl<Storage>().getValue('user');

        if (token != null && user != null) {
          final userLogged = UserModel.fromJson(jsonDecode(user));
          return Right(userLogged);
        } else {
          return Left(AuthFailure('No autenticado'));
        }
      } else {
        return Left(AuthFailure('No autenticado'));
      }
    } catch(e){
      return Left(AuthFailure('Error al verificar autenticado'));
    }
  }
  
  Future<Either<Failure, UserModel>> login(LoginParams params) async {
    try{
      final apiResponse = await authService.login(params.username, params.password);

      await sl<Storage>().setValue('isLogged','true');
      await sl<Storage>().setValue('access_token',apiResponse.token);
      await sl<Storage>().setValue('user',apiResponse.user.toJson());

      return Right(apiResponse.user);
    } on Failure catch(failure){
      return Left(failure);
    }
  }

  Future<Either<Failure, void>> logout() async {
    Storage().deleteValue('isLogged');
    return Right(null);
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