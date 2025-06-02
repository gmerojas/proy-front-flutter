import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_bloc_one/config/storage.dart';
import 'package:flutter_bloc_one/data/models/user_model.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth/error_codes.dart' as auth_error;
import 'package:local_auth_android/local_auth_android.dart';
import 'package:local_auth_darwin/local_auth_darwin.dart';
import 'package:logger/logger.dart';

abstract class AuthLocalDataSource {
  Future<bool> isLogged();
  Future<UserModel?> getLoggedUser();
  Future<String?> getToken();
  Future<void> persistLoginData({
    required String token,
    required UserModel user,
  });
  Future<void> clearSession();
  Future<bool> authenticate();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final Storage storage;
  final LocalAuthentication localAuth;
  final Logger logger = Logger();

  AuthLocalDataSourceImpl(this.storage, this.localAuth);

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

  @override
  Future<bool> authenticate() async {
    try {
      final canAuthenticate = await localAuth.canCheckBiometrics || await localAuth.isDeviceSupported();

      if (!canAuthenticate) {
        logger.e('Biometría no disponible en este dispositivo.');
        return false;
      }

      final didAuthenticate = await localAuth.authenticate(
        localizedReason: 'Por favor autentícate para continuar',
        options: const AuthenticationOptions(
          biometricOnly: true,
          useErrorDialogs: true,
          stickyAuth: false,
        ),
        authMessages: const <AuthMessages>[
          AndroidAuthMessages(
            signInTitle: 'Autenticación requerida',
            cancelButton: 'Cancelar',
            biometricHint: 'Escanea tu huella digital',
            biometricNotRecognized: 'Huella no reconocida',
          ),
          IOSAuthMessages(
            cancelButton: 'Cancelar',
            goToSettingsButton: 'Ir a ajustes',
            goToSettingsDescription: 'Configura Face ID o Touch ID',
          ),
        ],
      ).timeout(
        const Duration(seconds: 20),
        onTimeout: () => false, // devuelve false si se tarda más de 10 seg
      );

      return didAuthenticate;
    } on PlatformException catch (e) {
      if (e.code == auth_error.notAvailable) {
        logger.e('Hardware de autenticación no disponible.');
      } else if (e.code == auth_error.notEnrolled) {
        logger.e('No hay biometría configurada en el dispositivo.');
      } else if (e.code == auth_error.lockedOut ||
                e.code == auth_error.permanentlyLockedOut) {
        logger.e('Autenticación bloqueada temporal o permanentemente.');
      } else {
        logger.e('Error desconocido de autenticación: ${e.message}');
      }

      return false;
    }
  }
}