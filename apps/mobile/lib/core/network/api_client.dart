import 'package:dio/dio.dart';

import '../../app/config/app_config.dart';
import '../errors/error_handler.dart';
import '../storage/local_storage.dart';

class ApiClient {
  ApiClient({Dio? dio, LocalStorage? storage})
    : _dio =
          dio ??
          Dio(
            BaseOptions(
              baseUrl: AppConfig.apiBaseUrl,
              connectTimeout: AppConfig.apiTimeout,
              receiveTimeout: AppConfig.apiTimeout,
            ),
          ),
      _storage = storage ?? LocalStorage.instance {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final token = _storage.accessToken;
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          options.headers['Accept'] = 'application/json';
          return handler.next(options);
        },
      ),
    );
  }

  final Dio _dio;
  final LocalStorage _storage;

  Future<dynamic> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.get(path, queryParameters: queryParameters);
      return response.data;
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }

  Future<dynamic> post(String path, {Object? body}) async {
    try {
      final response = await _dio.post(path, data: body);
      return response.data;
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }

  Future<dynamic> patch(String path, {Object? body}) async {
    try {
      final response = await _dio.patch(path, data: body);
      return response.data;
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }

  Future<dynamic> delete(String path) async {
    try {
      final response = await _dio.delete(path);
      return response.data;
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }
}
