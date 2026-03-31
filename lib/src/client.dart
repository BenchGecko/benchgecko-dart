import 'dart:convert';
import 'package:http/http.dart' as http;
import 'models.dart';

/// Client for the BenchGecko API.
///
/// Provides methods to query AI models, benchmarks, and perform
/// side-by-side model comparisons.
///
/// ```dart
/// final client = BenchGeckoClient();
/// final models = await client.models();
/// ```
class BenchGeckoClient {
  /// API base URL.
  final String baseUrl;

  /// HTTP client instance.
  final http.Client _httpClient;

  /// Create a new BenchGecko client.
  ///
  /// [baseUrl] defaults to `https://benchgecko.ai`.
  /// [httpClient] can be provided for testing.
  BenchGeckoClient({
    this.baseUrl = 'https://benchgecko.ai',
    http.Client? httpClient,
  }) : _httpClient = httpClient ?? http.Client();

  Future<dynamic> _request(String path, {Map<String, String>? params}) async {
    final uri = Uri.parse('$baseUrl$path').replace(queryParameters: params);
    final response = await _httpClient.get(
      uri,
      headers: {
        'User-Agent': 'benchgecko-dart/0.1.0',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw BenchGeckoException(
        'API error: ${response.body}',
        statusCode: response.statusCode,
      );
    }

    return jsonDecode(response.body);
  }

  /// List all AI models tracked by BenchGecko.
  ///
  /// Returns a list of [BgModel] objects with metadata,
  /// benchmark scores, and pricing information.
  Future<List<BgModel>> models() async {
    final data = await _request('/api/v1/models') as List;
    return data.map((e) => BgModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  /// List all benchmarks tracked by BenchGecko.
  ///
  /// Returns a list of [BgBenchmark] objects with name,
  /// category, and description.
  Future<List<BgBenchmark>> benchmarks() async {
    final data = await _request('/api/v1/benchmarks') as List;
    return data.map((e) => BgBenchmark.fromJson(e as Map<String, dynamic>)).toList();
  }

  /// Compare two or more AI models side by side.
  ///
  /// [modelSlugs] must contain at least 2 model slugs.
  Future<ComparisonResult> compare(List<String> modelSlugs) async {
    if (modelSlugs.length < 2) {
      throw ArgumentError('At least 2 models are required for comparison.');
    }
    final data = await _request('/api/v1/compare', params: {
      'models': modelSlugs.join(','),
    }) as Map<String, dynamic>;
    return ComparisonResult.fromJson(data);
  }

  /// Close the HTTP client.
  void close() => _httpClient.close();
}
