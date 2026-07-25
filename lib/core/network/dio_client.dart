import 'package:dio/dio.dart';

/// Thin wrapper around [Dio] so the rest of the app never talks to
/// Dio directly. Makes it trivial to swap the HTTP client later
/// (e.g. for testing with a mock) without touching data sources.
class DioClient {
  DioClient({Dio? dio})
      : _dio = dio ??
            Dio(
              BaseOptions(
                connectTimeout: const Duration(seconds: 15),
                receiveTimeout: const Duration(seconds: 15),
                headers: const {'Content-Type': 'application/json'},
              ),
            );

  final Dio _dio;

  Future<Response<dynamic>> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    return _dio.get(path, queryParameters: queryParameters);
  }
}
