# BenchGecko Dart SDK

Official Dart client for the [BenchGecko](https://benchgecko.ai) API. Query AI model data, benchmark scores, and run side-by-side comparisons from Dart and Flutter applications.

BenchGecko tracks every major AI model, benchmark, and provider. This package wraps the public REST API with strongly typed Dart classes, async/await patterns, and injectable HTTP clients for testability.

## Installation

```yaml
dependencies:
  benchgecko: ^0.1.0
```

Then run `dart pub get`.

## Quick Start

```dart
import 'package:benchgecko/benchgecko.dart';

void main() async {
  final client = BenchGeckoClient();

  // List all tracked AI models
  final models = await client.models();
  print('Tracking ${models.length} models');

  // List all benchmarks
  final benchmarks = await client.benchmarks();
  for (final b in benchmarks.take(5)) {
    print(b.name);
  }

  // Compare two models head-to-head
  final comparison = await client.compare(['gpt-4o', 'claude-opus-4']);
  print('Compared ${comparison.models?.length} models');

  client.close();
}
```

## API Reference

### `BenchGeckoClient({String baseUrl, http.Client? httpClient})`

Create a new BenchGecko client. The default base URL is `https://benchgecko.ai`. Pass a custom `http.Client` for testing.

### `client.models()`

Fetch all AI models. Returns `Future<List<BgModel>>` with name, provider, slug, and extensible metadata.

### `client.benchmarks()`

Fetch all benchmarks. Returns `Future<List<BgBenchmark>>` with name, category, slug, and metadata.

### `client.compare(List<String> modelSlugs)`

Compare two or more models. Pass a list of model slugs (minimum 2). Returns `Future<ComparisonResult>` with per-model data.

## Error Handling

API errors throw `BenchGeckoException` with message and HTTP status code:

```dart
try {
  final models = await client.models();
} on BenchGeckoException catch (e) {
  print('API error (${e.statusCode}): ${e.message}');
}
```

## Data Attribution

Data provided by [BenchGecko](https://benchgecko.ai). Model benchmark scores are sourced from official evaluation suites. Pricing data is updated daily from provider APIs.

## Links

- [BenchGecko](https://benchgecko.ai) - AI model benchmarks, pricing, and rankings
- [API Documentation](https://benchgecko.ai/api-docs)
- [GitHub Repository](https://github.com/BenchGecko/benchgecko-dart)

## License

MIT
