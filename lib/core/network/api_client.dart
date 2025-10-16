import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../constants/api_constants.dart';

class ApiClient {
  final Dio _dio;

  ApiClient() : _dio = Dio() {
    _dio.options.baseUrl = dotenv.env['TMDB_BASE_URL'] ?? ApiConstants.baseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 10);
    _dio.options.receiveTimeout = const Duration(seconds: 10);
    _dio.options.headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${dotenv.env['TMDB_ACCESS_TOKEN']}',
    };
  }

  Future<dynamic> get(String endpoint, {Map<String, dynamic>? queryParameters}) async {
    try {
      final apiKey = dotenv.env['TMDB_API_KEY'] ?? ApiConstants.apiKey;
      final params = {
        ApiConstants.apiKeyParam: apiKey,
        ApiConstants.languageParam: ApiConstants.defaultLanguage,
        ...?queryParameters,
      };

      final response = await _dio.get(endpoint, queryParameters: params);
      return response.data;
    } on DioException catch (e) {
      _handleError(e);
    }
  }

  void _handleError(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      throw Exception('Tiempo de espera agotado. Por favor, verifica tu conexión a internet.');
    } else if (e.type == DioExceptionType.connectionError) {
      throw Exception('Error de conexión. Por favor, verifica tu conexión a internet.');
    } else {
      throw Exception('Ocurrió un error: ${e.message}');
    }
  }
}
