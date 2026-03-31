# BenchGecko for Dart

**The CoinGecko for AI.** Dart client for accessing AI model benchmarks, comparing language models, estimating inference costs, and discovering AI agents.

BenchGecko tracks 300+ AI models across 50+ providers with real benchmark scores, latency metrics, and transparent pricing. This package gives you structured access to that data in idiomatic Dart with strong typing, null safety, and zero external dependencies.

## Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  benchgecko: ^0.1.0
```

Then run `dart pub get`.

## Quick Start

```dart
import 'package:benchgecko/benchgecko.dart';

void main() {
  // Look up any model
  final model = BenchGecko.getModel('claude-3.5-sonnet');
  print(model?.name);       // Claude 3.5 Sonnet
  print(model?.provider);   // Anthropic
  print(model?.score('MMLU'));  // 88.7

  // List all tracked models
  for (final id in BenchGecko.listModels()) {
    print(id);
  }
}
```

## Comparing Models

The comparison engine returns strongly-typed results with benchmark differences and pricing ratios. Positive diff values mean the first model scores higher:

```dart
final result = BenchGecko.compareModels('gpt-4o', 'claude-3.5-sonnet');
if (result != null) {
  print('Cheaper: ${result.cheaper}');       // gpt-4o
  print('Cost ratio: ${result.costRatio}');  // 0.69

  result.benchmarkDiff.forEach((bench, diff) {
    if (diff != null) {
      final winner = diff >= 0 ? 'GPT-4o' : 'Claude 3.5 Sonnet';
      print('$bench: $winner by ${diff.abs()} pts');
    }
  });
}
```

## Cost Estimation

Estimate inference costs before committing to a provider. All prices are per million tokens:

```dart
final cost = BenchGecko.estimateCost(
  'gpt-4o',
  inputTokens: 2000000,
  outputTokens: 500000,
);

if (cost != null) {
  print('Input:  \$${cost.inputCost}');   // $5.0
  print('Output: \$${cost.outputCost}');  // $5.0
  print('Total:  \$${cost.total}');       // $10.0
}
```

## Finding the Right Model

Filter models by benchmark performance with type-safe results:

```dart
// All models scoring 87+ on MMLU, sorted by score
final topReasoners = BenchGecko.topModels('MMLU', minScore: 87.0);
for (final model in topReasoners) {
  print('${model.name}: ${model.score("MMLU")}');
}

// Cheapest model above a quality threshold
final budgetPick = BenchGecko.cheapestAbove('MMLU', 85.0);
if (budgetPick != null) {
  print('${budgetPick.name} at \$${budgetPick.costPerMillion}/M tokens');
}
```

## Benchmark Categories

BenchGecko organizes 40+ benchmarks into categories covering reasoning, coding, math, instruction following, safety, multimodal, multilingual, and long context evaluation:

```dart
BenchGecko.benchmarkCategories().forEach((key, category) {
  print('${category.name}: ${category.benchmarks.join(", ")}');
  print('  ${category.description}');
});
```

## Built-in Model Catalog

The package ships with a curated catalog of major models from OpenAI, Anthropic, Google, Meta, Mistral, and DeepSeek. Each entry includes benchmark scores, parameter counts, context window sizes, and per-token pricing. All data is compiled into the package with zero runtime dependencies.

```dart
final model = BenchGecko.getModel('deepseek-v3');
print(model?.parameters);      // 671.0
print(model?.contextWindow);   // 128000
print(model?.costPerMillion);  // 0.685
```

## Type Safety

Every class uses Dart null safety. Model lookups return `Model?`, cost estimates return `CostEstimate?`, and comparisons return `ComparisonResult?`. Benchmark scores use `double?` to distinguish missing data from zero scores.

```dart
final model = BenchGecko.getModel('unknown-model');
// model is null -- no runtime exceptions

final score = BenchGecko.getModel('gpt-4o')?.score('NonExistentBench');
// score is null -- benchmark not tracked for this model
```

## Resources

- [BenchGecko](https://benchgecko.ai) -- Full platform with interactive comparisons
- [Source Code](https://github.com/BenchGecko/benchgecko-dart) -- Contributions welcome

## License

MIT License. See [LICENSE](LICENSE) for details.
