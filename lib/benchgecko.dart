/// BenchGecko - AI Model Benchmark Data
///
/// Official Dart client for the BenchGecko API.
/// Compare AI model benchmarks, pricing, and performance.
///
/// Website: https://benchgecko.ai
/// API Docs: https://benchgecko.ai/api-docs
library benchgecko;

import 'dart:convert';
import 'package:http/http.dart' as http;

/// Client for the BenchGecko AI Model Intelligence API.
class BenchGeckoClient {
  static const String _baseUrl = 'https://benchgecko.ai/api/v1';
  final String? apiKey;
  final http.Client _client;

  BenchGeckoClient({this.apiKey}) : _client = http.Client();

  Map<String, String> get _headers => {
    'User-Agent': 'BenchGecko-Dart/1.0',
    if (apiKey != null) 'Authorization': 'Bearer $apiKey',
  };

  /// List AI models with optional filtering.
  Future<List<Map<String, dynamic>>> getModels({
    String? provider,
    bool? openSource,
    String sort = 'score',
    int limit = 50,
    int page = 1,
  }) async {
    final params = {
      'sort': sort,
      'limit': limit.toString(),
      'page': page.toString(),
      if (provider != null) 'provider': provider,
      if (openSource != null) 'open_source': openSource.toString(),
    };
    final uri = Uri.parse('$_baseUrl/models').replace(queryParameters: params);
    final response = await _client.get(uri, headers: _headers);
    final data = jsonDecode(response.body);
    return List<Map<String, dynamic>>.from(data['data'] ?? []);
  }

  /// Get detailed benchmark scores for a specific model.
  Future<Map<String, dynamic>> getModel(String slug) async {
    final response = await _client.get(
      Uri.parse('$_baseUrl/models/$slug'),
      headers: _headers,
    );
    return jsonDecode(response.body);
  }

  /// Compare 2-6 models side by side.
  Future<Map<String, dynamic>> compare(List<String> slugs) async {
    final uri = Uri.parse('$_baseUrl/compare')
        .replace(queryParameters: {'models': slugs.join(',')});
    final response = await _client.get(uri, headers: _headers);
    return jsonDecode(response.body);
  }

  /// List all benchmarks with top performers.
  Future<List<Map<String, dynamic>>> getBenchmarks({String? category}) async {
    final params = {if (category != null) 'category': category};
    final uri = Uri.parse('$_baseUrl/benchmarks')
        .replace(queryParameters: params.isEmpty ? null : params);
    final response = await _client.get(uri, headers: _headers);
    final data = jsonDecode(response.body);
    return List<Map<String, dynamic>>.from(data['data'] ?? []);
  }

  void dispose() => _client.close();
}
