import 'package:dio/dio.dart';
import 'package:flutter_bloc_one/config/constants.dart';
import 'package:flutter_bloc_one/config/storage.dart';
import 'package:flutter_bloc_one/core/errors/failure.dart';
import 'package:flutter_bloc_one/core/services/service_locator.dart';
import 'package:flutter_bloc_one/data/models/error_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logger/logger.dart';

class ApiService {
  final logger = Logger();
  final Dio dio;
  ApiService(this.dio) {
    final apiBase = dotenv.env['API_URL'] ?? 'https://www.example.com';
    dio.options.baseUrl = apiBase;
    dio.options.connectTimeout = Duration(seconds: 10);
    dio.options.receiveTimeout = Duration(seconds: 10);
    dio.options.headers = {'Content-Type':'application/json'};

    dio.interceptors.add(InterceptorsWrapper(
          onRequest: (options, handler) async {
            final requestPath = '${options.baseUrl}${options.path}';
            logger.i('${options.method} request ==> $requestPath');
            final token = await sl<Storage>().getToken();
            if(token != null){
              options.headers['Authorization'] = 'Bearer $token';
            }
            return handler.next(options);
          },
          onError: (error, handler) {
            return handler.next(error);
          },
        ));
  }

  // 🔁 Método POST genérico
  Future<T> post<T>(
    String endpoint,
    dynamic data,
    T Function(dynamic json) fromJson,
  ) async {
    try {
      final response = await dio.post(endpoint, data: data);
      await Future.delayed(Duration(milliseconds: 500));
      if(response.statusCode == 200){
        if (response.data['status'] != null &&
            response.data['status'] == ResponseStatus.success) {
          return fromJson(response.data['data']);
        } else {
          if (response.data['error'] != null) {
            ErrorModel error = ErrorModel.fromJson(response.data['error']);
            throw ResponseFailure(error.message);
          } else {
            throw UnexpectedFailure();
          }
        }
      }else {
        if (response.data['error'] != null) {
          ErrorModel error = ErrorModel.fromJson(response.data['error']);
          throw ResponseFailure(error.message);
        } else {
          throw UnexpectedFailure();
        }
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch(e){
      throw ServerFailure(e.toString());
    }
  }

  // 🟦 Método GET genérico
  Future<T> get<T>(
    String endpoint,
    T Function(dynamic json) fromJson, {
    Map<String, dynamic>? queryParams,
  }) async {
    try {
      final response = await dio.get(endpoint, queryParameters: queryParams);
      await Future.delayed(Duration(milliseconds: 500));
      if(response.statusCode == 200){
        if (response.data['status'] != null &&
            response.data['status'] == ResponseStatus.success) {
          return fromJson(response.data);
        } else {
          if (response.data['error'] != null) {
            ErrorModel error = ErrorModel.fromJson(response.data['error']);
            throw ResponseFailure(error.message);
          } else {
            throw UnexpectedFailure();
          }
        }
      }else {
        if (response.data['error'] != null) {
          ErrorModel error = ErrorModel.fromJson(response.data['error']);
          throw ResponseFailure(error.message);
        } else {
          throw UnexpectedFailure();
        }
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch(e){
      throw ServerFailure(e.toString());
    }
  }

  Exception _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        throw ServerFailure('Tiempo de conexión agotado');
      case DioExceptionType.sendTimeout:
        throw ServerFailure('Tiempo de envío agotado');
      case DioExceptionType.receiveTimeout:
        throw ServerFailure('Tiempo de recepción agotado');
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        switch (statusCode) {
          case 401:
            throw AuthFailure('Credenciales inválidas');
          case 403:
            throw AuthFailure('No autorizado');
          default:
            throw ServerFailure('Error HTTP: $statusCode');
        }
      case DioExceptionType.cancel:
        throw ServerFailure('Solicitud cancelada');
      case DioExceptionType.unknown:
      default:
        throw ServerFailure('Error inesperado: ${e.message}');
    }
  }
}