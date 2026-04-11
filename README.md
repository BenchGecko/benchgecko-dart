# BenchGecko for Dart

Official Dart/Flutter SDK for [BenchGecko](https://benchgecko.ai), the data layer of the AI economy.

Thousands of models with cross-provider pricing and daily price history. Hundreds of companies with valuations, funding timelines, and revenue estimates. Benchmark scores, developer adoption signals, agent leaderboards, and a changelog that captures every price drop, every launch, every deprecation as it happens.

If it moved in AI today, it is already on BenchGecko.

## Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  benchgecko: ^1.0.0
```

Then run `dart pub get`.

## Quick Start

```dart
import 'package:benchgecko/benchgecko.dart';

Future<void> main() async {
  final client = BenchGeckoClient();

  // List top models by score
  final models = await client.getModels(sort: 'score', limit: 10);
  for (final model in models) {
    print('${model['name']} (${model['provider']})');
  }

  client.dispose();
}
```

## API Key

BenchGecko is free to query without an API key for light usage. For higher rate limits, pass an API key:

```dart
final client = BenchGeckoClient(apiKey: 'your_api_key');
```

## Model Lookup

```dart
final model = await client.getModel('claude-3-5-sonnet');
print(model['name']);
print(model['pricing']);
print(model['benchmarks']);
```

## Cross-Provider Comparison

Compare two to six models side by side with benchmark scores and pricing delta:

```dart
final result = await client.compare([
  'gpt-4o',
  'claude-3-5-sonnet',
  'gemini-2-0-flash',
]);
print(result);
```

## Benchmark Catalog

```dart
// All benchmarks
final all = await client.getBenchmarks();

// Filter by category
final reasoning = await client.getBenchmarks(category: 'reasoning');
```

## Filtering Models

```dart
// Open-source models only
final openModels = await client.getModels(openSource: true);

// Models from a specific provider
final anthropicModels = await client.getModels(provider: 'anthropic');

// Sort options: score, price, context, recent
final cheapest = await client.getModels(sort: 'price', limit: 20);
```

## Resources

- [BenchGecko](https://benchgecko.ai) - Full platform
- [API Docs](https://benchgecko.ai/api-docs) - REST API reference
- [Brand](https://benchgecko.ai/brand) - Press kit and brand voice
- [Source](https://github.com/BenchGecko/benchgecko-dart) - Contributions welcome

## License

MIT License.
