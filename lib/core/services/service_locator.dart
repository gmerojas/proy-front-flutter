import 'package:dio/dio.dart';
import 'package:flutter_bloc_one/config/storage.dart';
import 'package:flutter_bloc_one/core/services/api_service.dart';
import 'package:flutter_bloc_one/data/data_source/auth_local_data_source.dart';
import 'package:flutter_bloc_one/data/repositories/auth_repository.dart';
import 'package:flutter_bloc_one/data/services/auth_service.dart';
import 'package:flutter_bloc_one/screens/auth/bloc/auth.dart';
import 'package:get_it/get_it.dart';
import 'package:local_auth/local_auth.dart';

final sl = GetIt.instance;

void init(){
  // CONFIG
  // flutter_secure_storage
  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton(() => Storage());
  sl.registerLazySingleton(() => ApiService(sl<Dio>()));
  sl.registerLazySingleton(() => LocalAuthentication());
  // AUTH
  // Bloc
  sl.registerLazySingleton(() => AuthBloc(sl()));
  sl.registerLazySingleton(() => AuthRepository(sl(),sl(),sl()));
  sl.registerLazySingleton(() => AuthService(sl()));
  sl.registerLazySingleton<AuthLocalDataSource>(() => AuthLocalDataSourceImpl(sl()));
}