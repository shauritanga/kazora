import 'package:dio/dio.dart';

import 'failures.dart';

Failure mapDioException(DioException exception) {
  switch (exception.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
    case DioExceptionType.transformTimeout:
      return const NetworkFailure('The request timed out. Please try again.');
    case DioExceptionType.connectionError:
      return const NetworkFailure();
    case DioExceptionType.badCertificate:
      return const ServerFailure('Unsafe connection.');
    case DioExceptionType.badResponse:
      final status = exception.response?.statusCode;
      final message = _serverMessage(exception.response?.data);
      if (status == 401 || status == 403) {
        return AuthorizationFailure(
          message ?? 'Your session has expired. Please sign in again.',
        );
      }
      if (status == 402 || status == 409) {
        return const CreditLimitFailure();
      }
      return ServerFailure(
        message ?? 'Something went wrong (${status ?? 'unknown'}).',
        statusCode: status,
      );
    case DioExceptionType.cancel:
      return const ServerFailure('Request cancelled.');
    case DioExceptionType.unknown:
      return const NetworkFailure();
  }
}

String? _serverMessage(dynamic data) {
  if (data is Map<String, dynamic>) {
    final raw = data['message'];
    if (raw is String && raw.isNotEmpty) return raw;
    if (raw is List) {
      final parts = raw.whereType<String>().toList();
      if (parts.isNotEmpty) return parts.join(' ');
    }
  }
  return null;
}
