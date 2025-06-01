import 'dart:convert';

import 'package:flutter_bloc_one/config/storage.dart';
import 'package:flutter_bloc_one/data/models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<bool> isLogged();
  Future<UserModel?> getLoggedUser();
  Future<String?> getToken();
  Future<void> persistLoginData({
    required String token,
    required UserModel user,
  });
  Future<void> clearSession();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final Storage storage;

  AuthLocalDataSourceImpl(this.storage);

  @override
  Future<UserModel?> getLoggedUser() async {
    final userJson = await storage.getValue('user');
    if (userJson == null) return null;
    return UserModel.fromJson(jsonDecode(userJson));
  }

  @override
  Future<bool> isLogged() async {
    final value = await storage.getValue('isLogged');
    return value == 'true';
  }
  
  @override
  Future<String?> getToken() async {
    return await storage.getValue('access_token');
  }
  
  @override
  Future<void> persistLoginData({
    required String token,
    required UserModel user,
  }) async {
    await storage.setValue('isLogged', 'true');
    await storage.setValue('access_token', token);
    await storage.setValue('user', user.toJson());
  }
  
  @override
  Future<void> clearSession() async {
    await storage.deleteValue('isLogged');
    //await storage.deleteValue('access_token'); // todo:
    //await storage.deleteValue('user'); // todo: 
  }
}