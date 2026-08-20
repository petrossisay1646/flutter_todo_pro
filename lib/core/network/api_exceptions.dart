import 'package:dio/dio.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic data;

  ApiException({
    required this.message,
    this.statusCode,
    this.data,
  });

  factory ApiException.fromDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return ApiException(
          message: 'Connection timed out. Please check your internet connection.',
          statusCode: error.response?.statusCode,
        );
      case DioExceptionType.badResponse:
        final response = error.response;
        String message = 'Something went wrong. Please try again.';
        if (response?.data is Map && response?.data['message'] != null) {
          message = response!.data['message'].toString();
        } else if (response?.statusCode == 401) {
          message = 'Session expired or invalid credentials. Please log in.';
        } else if (response?.statusCode == 404) {
          message = 'Requested resource not found.';
        } else if (response?.statusCode == 409) {
          message = 'Account or resource already exists.';
        } else if (response?.statusCode != null && response!.statusCode! >= 500) {
          message = 'Server is currently unavailable. Please try again later.';
        }
        return ApiException(
          message: message,
          statusCode: response?.statusCode,
          data: response?.data,
        );
      case DioExceptionType.connectionError:
        return ApiException(
          message: 'Unable to connect to server. Check your network or server status.',
        );
      case DioExceptionType.cancel:
        return ApiException(message: 'Request was cancelled.');
      default:
        return ApiException(
          message: error.message ?? 'An unexpected network error occurred.',
        );
    }
  }

  @override
  String toString() => message;
}
