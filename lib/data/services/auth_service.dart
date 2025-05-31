import 'package:flutter_bloc_one/config/constants.dart';
import 'package:flutter_bloc_one/core/services/api_service.dart';
import 'package:flutter_bloc_one/data/models/user_model.dart';

class AuthService {
  final ApiService apiService;
  AuthService(this.apiService);

  Future<LoginResponse> login(String username, String password) async {
    final result = await apiService.post<LoginResponse>(ConstantPath.login, {
      'username': username,
      'password': password,
    }, (json) => LoginResponse.fromJson(json));

    return result;
  }

}

class LoginResponse {
  final String token;
  final UserModel user;

  LoginResponse({
    required this.token,
    required this.user,
  });

  factory LoginResponse.fromJson(Map<String,dynamic> json){
    return LoginResponse(
      token: json['token'],
      user: UserModel.fromJson(json['user']),
    );
  }

  Map<String,dynamic> toJson() => {
    "token": token,
    "user": user.toJson(),
  };
}