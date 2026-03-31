/// Represents an AI model tracked by BenchGecko.
class BgModel {
  final String? id;
  final String? name;
  final String? slug;
  final String? provider;
  final Map<String, dynamic> extra;

  BgModel({this.id, this.name, this.slug, this.provider, this.extra = const {}});

  factory BgModel.fromJson(Map<String, dynamic> json) {
    return BgModel(
      id: json['id'] as String?,
      name: json['name'] as String?,
      slug: json['slug'] as String?,
      provider: json['provider'] as String?,
      extra: json,
    );
  }

  @override
  String toString() => 'BgModel(name: $name, provider: $provider)';
}

/// Represents a benchmark tracked by BenchGecko.
class BgBenchmark {
  final String? id;
  final String? name;
  final String? slug;
  final String? category;
  final Map<String, dynamic> extra;

  BgBenchmark({this.id, this.name, this.slug, this.category, this.extra = const {}});

  factory BgBenchmark.fromJson(Map<String, dynamic> json) {
    return BgBenchmark(
      id: json['id'] as String?,
      name: json['name'] as String?,
      slug: json['slug'] as String?,
      category: json['category'] as String?,
      extra: json,
    );
  }

  @override
  String toString() => 'BgBenchmark(name: $name, category: $category)';
}

/// Result of comparing two or more AI models.
class ComparisonResult {
  final List<dynamic>? models;
  final Map<String, dynamic> extra;

  ComparisonResult({this.models, this.extra = const {}});

  factory ComparisonResult.fromJson(Map<String, dynamic> json) {
    return ComparisonResult(
      models: json['models'] as List<dynamic>?,
      extra: json,
    );
  }
}

/// Exception thrown when the BenchGecko API returns an error.
class BenchGeckoException implements Exception {
  final String message;
  final int? statusCode;

  BenchGeckoException(this.message, {this.statusCode});

  @override
  String toString() => 'BenchGeckoException: $message (status: $statusCode)';
}
