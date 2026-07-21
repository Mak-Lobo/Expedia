import 'package:dio/dio.dart';

import '../configurations/backend_connect.dart';

class ApiService {
  ApiService({String? baseUrl})
    : _dio = Dio(
        BaseOptions(
          baseUrl: baseUrl ?? DbConnect().host,
          connectTimeout: const Duration(milliseconds: 7000),
          receiveTimeout: const Duration(milliseconds: 7000),
        ),
      );

  final Dio _dio;

  String _friendlyDioMessage(DioException error, String path) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.transformTimeout:
      case DioExceptionType.connectionError:
      case DioExceptionType.badCertificate:
        return 'Server is not reachable. Please make sure the backend is running and the base URL is correct.';
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final responseData = error.response?.data;
        final detail = responseData is Map<String, dynamic>
            ? responseData['detail']?.toString()
            : responseData?.toString();

        if (statusCode == 400 || statusCode == 422) {
          return detail ??
              'Bad request for $path. Check the request payload and stored procedure parameters.';
        }

        if (detail != null && detail.isNotEmpty) {
          return 'Request to $path failed with status $statusCode: $detail';
        }

        return 'Request to $path failed with status $statusCode.';
      case DioExceptionType.cancel:
        return 'Request to $path was cancelled.';
      case DioExceptionType.unknown:
        final message = error.message ?? error.error?.toString();
        if (message != null && message.isNotEmpty) {
          return 'Request to $path failed: $message';
        }
        return 'Request to $path failed due to an unknown network error.';
    }
  }

  Never _rethrowFriendly(DioException error, String path) {
    throw Exception(_friendlyDioMessage(error, path));
  }

  Options _authOptions({int? userId}) {
    if (userId == null) {
      return Options();
    }

    return Options(headers: {'X-User-Id': userId});
  }

  Future<List<dynamic>> getList(String path, {int? userId}) async {
    try {
      final response = await _dio.get(path, options: _authOptions(userId: userId));
      if (response.data is List) {
        return response.data as List<dynamic>;
      }
      throw Exception('Expected a list response from $path');
    } on DioException catch (error) {
      _rethrowFriendly(error, path);
    }
  }

  Future<dynamic> get(String path, {int? userId}) async {
    try {
      final response = await _dio.get(path, options: _authOptions(userId: userId));
      return response.data;
    } on DioException catch (error) {
      _rethrowFriendly(error, path);
    }
  }

  Future<dynamic> post(
    String path,
    dynamic data, {
    int? userId,
  }) async {
    try {
      final response = await _dio.post(
        path,
        data: data,
        options: _authOptions(userId: userId),
      );
      return response.data;
    } on DioException catch (error) {
      _rethrowFriendly(error, path);
    }
  }

  Future<dynamic> put(
    String path,
    dynamic data, {
    int? userId,
  }) async {
    try {
      final response = await _dio.put(
        path,
        data: data,
        options: _authOptions(userId: userId),
      );
      return response.data;
    } on DioException catch (error) {
      _rethrowFriendly(error, path);
    }
  }

  Future<dynamic> delete(String path, {int? userId}) async {
    try {
      final response = await _dio.delete(
        path,
        options: _authOptions(userId: userId),
      );
      return response.data;
    } on DioException catch (error) {
      _rethrowFriendly(error, path);
    }
  }
}
