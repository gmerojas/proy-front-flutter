import 'package:dio/dio.dart';
import 'package:flutter_bloc_one/config/storage.dart';
import 'package:flutter_bloc_one/core/services/api_service.dart';
import 'package:flutter_bloc_one/data/repositories/auth_repository.dart';
import 'package:flutter_bloc_one/data/services/auth_service.dart';
import 'package:flutter_bloc_one/screens/auth/bloc/auth.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

void init(){
  // CONFIG
  // flutter_secure_storage
  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton(() => Storage());
  sl.registerLazySingleton(() => ApiService(sl<Dio>()));
  // AUTH
  // Bloc
  sl.registerLazySingleton(() => AuthBloc(sl()));
  sl.registerLazySingleton(() => AuthRepository(sl()));
  sl.registerLazySingleton(() => AuthService(sl()));
}