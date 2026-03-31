/// BenchGecko - The CoinGecko for AI
///
/// Dart client for accessing AI model benchmarks, comparing language models,
/// estimating inference costs, and discovering AI agents.
///
/// ```dart
/// import 'package:benchgecko/benchgecko.dart';
///
/// final model = BenchGecko.getModel('gpt-4o');
/// print(model?.name);       // GPT-4o
/// print(model?.provider);   // OpenAI
/// print(model?.score('MMLU')); // 88.7
/// ```
///
/// Full platform at [benchgecko.ai](https://benchgecko.ai).
library benchgecko;

/// Represents an AI model with benchmark scores, pricing, and metadata.
class Model {
  /// Unique model identifier (e.g., "gpt-4o", "claude-3.5-sonnet")
  final String id;

  /// Display name of the model
  final String name;

  /// Company that created the model
  final String provider;

  /// Number of parameters in billions (null if undisclosed)
  final double? parameters;

  /// Maximum context window in tokens
  final int? contextWindow;

  /// Price per million input tokens in USD
  final double? inputPrice;

  /// Price per million output tokens in USD
  final double? outputPrice;

  /// Benchmark name to score mapping
  final Map<String, double> benchmarks;

  /// Additional metadata
  final Map<String, dynamic> metadata;

  const Model({
    required this.id,
    required this.name,
    required this.provider,
    this.parameters,
    this.contextWindow,
    this.inputPrice,
    this.outputPrice,
    this.benchmarks = const {},
    this.metadata = const {},
  });

  /// Cost per million tokens (average of input and output pricing)
  double? get costPerMillion {
    if (inputPrice == null || outputPrice == null) return null;
    return double.parse(((inputPrice! + outputPrice!) / 2.0).toStringAsFixed(4));
  }

  /// Get the score for a specific benchmark
  double? score(String benchmarkName) => benchmarks[benchmarkName];

  /// Summary map suitable for comparison tables
  Map<String, dynamic> toSummary() => {
        'name': name,
        'provider': provider,
        'parameters': parameters,
        'contextWindow': contextWindow,
        'costPerMillion': costPerMillion,
      };

  @override
  String toString() => '$name ($provider) - ${parameters ?? "?"}B params';
}

/// Represents an AI agent with capabilities and evaluation scores.
class Agent {
  final String id;
  final String name;
  final String category;
  final String provider;
  final List<String> modelsUsed;
  final Map<String, double> scores;
  final List<String> capabilities;
  final Map<String, dynamic> metadata;

  const Agent({
    required this.id,
    required this.name,
    required this.category,
    required this.provider,
    this.modelsUsed = const [],
    this.scores = const {},
    this.capabilities = const [],
    this.metadata = const {},
  });

  /// Check if the agent supports a specific capability
  bool supports(String capability) => capabilities.contains(capability);

  @override
  String toString() => '$name ($category) by $provider';
}

/// Result of a model comparison.
class ComparisonResult {
  final Map<String, dynamic> modelA;
  final Map<String, dynamic> modelB;
  final Map<String, double?> benchmarkDiff;
  final String? cheaper;
  final double? costRatio;

  const ComparisonResult({
    required this.modelA,
    required this.modelB,
    required this.benchmarkDiff,
    this.cheaper,
    this.costRatio,
  });
}

/// Cost estimation result.
class CostEstimate {
  final String model;
  final int inputTokens;
  final int outputTokens;
  final double inputCost;
  final double outputCost;
  final double total;

  const CostEstimate({
    required this.model,
    required this.inputTokens,
    required this.outputTokens,
    required this.inputCost,
    required this.outputCost,
    required this.total,
  });
}

/// Benchmark category information.
class BenchmarkCategory {
  final String name;
  final List<String> benchmarks;
  final String description;

  const BenchmarkCategory({
    required this.name,
    required this.benchmarks,
    required this.description,
  });
}

/// BenchGecko - The CoinGecko for AI.
///
/// Provides model lookup, comparison, cost estimation, and benchmark filtering.
class BenchGecko {
  BenchGecko._();

  static final Map<String, Map<String, dynamic>> _models = {
    'gpt-4o': {
      'name': 'GPT-4o',
      'provider': 'OpenAI',
      'parameters': 200.0,
      'contextWindow': 128000,
      'inputPrice': 2.50,
      'outputPrice': 10.00,
      'benchmarks': {'MMLU': 88.7, 'HumanEval': 90.2, 'GSM8K': 95.8, 'GPQA': 53.6},
    },
    'claude-3.5-sonnet': {
      'name': 'Claude 3.5 Sonnet',
      'provider': 'Anthropic',
      'parameters': null,
      'contextWindow': 200000,
      'inputPrice': 3.00,
      'outputPrice': 15.00,
      'benchmarks': {'MMLU': 88.7, 'HumanEval': 92.0, 'GSM8K': 96.4, 'GPQA': 59.4},
    },
    'gemini-2.0-flash': {
      'name': 'Gemini 2.0 Flash',
      'provider': 'Google',
      'parameters': null,
      'contextWindow': 1000000,
      'inputPrice': 0.10,
      'outputPrice': 0.40,
      'benchmarks': {'MMLU': 85.2, 'HumanEval': 84.0, 'GSM8K': 92.1},
    },
    'llama-3.1-405b': {
      'name': 'Llama 3.1 405B',
      'provider': 'Meta',
      'parameters': 405.0,
      'contextWindow': 128000,
      'inputPrice': 3.00,
      'outputPrice': 3.00,
      'benchmarks': {'MMLU': 88.6, 'HumanEval': 89.0, 'GSM8K': 96.8, 'GPQA': 50.7},
    },
    'mistral-large': {
      'name': 'Mistral Large',
      'provider': 'Mistral',
      'parameters': 123.0,
      'contextWindow': 128000,
      'inputPrice': 2.00,
      'outputPrice': 6.00,
      'benchmarks': {'MMLU': 84.0, 'HumanEval': 82.0, 'GSM8K': 91.2},
    },
    'deepseek-v3': {
      'name': 'DeepSeek V3',
      'provider': 'DeepSeek',
      'parameters': 671.0,
      'contextWindow': 128000,
      'inputPrice': 0.27,
      'outputPrice': 1.10,
      'benchmarks': {'MMLU': 87.1, 'HumanEval': 82.6, 'GSM8K': 89.3, 'GPQA': 59.1},
    },
  };

  static final Map<String, BenchmarkCategory> _categories = {
    'reasoning': const BenchmarkCategory(
      name: 'Reasoning',
      benchmarks: ['MMLU', 'MMLU-Pro', 'ARC-Challenge', 'HellaSwag', 'WinoGrande', 'GPQA'],
      description: 'Logical reasoning, knowledge, and common sense',
    ),
    'coding': const BenchmarkCategory(
      name: 'Coding',
      benchmarks: ['HumanEval', 'MBPP', 'SWE-bench', 'LiveCodeBench', 'BigCodeBench'],
      description: 'Code generation, debugging, and software engineering',
    ),
    'math': const BenchmarkCategory(
      name: 'Mathematics',
      benchmarks: ['GSM8K', 'MATH', 'AIME', 'AMC', 'Competition-Math'],
      description: 'Mathematical problem solving from arithmetic to olympiad',
    ),
    'instruction': const BenchmarkCategory(
      name: 'Instruction Following',
      benchmarks: ['IFEval', 'MT-Bench', 'AlpacaEval', 'Chatbot-Arena'],
      description: 'Following complex instructions and conversational ability',
    ),
    'safety': const BenchmarkCategory(
      name: 'Safety',
      benchmarks: ['TruthfulQA', 'BBQ', 'ToxiGen', 'BOLD'],
      description: 'Truthfulness, bias, and safety alignment',
    ),
    'multimodal': const BenchmarkCategory(
      name: 'Multimodal',
      benchmarks: ['MMMU', 'MathVista', 'VQAv2', 'TextVQA', 'DocVQA'],
      description: 'Vision, document understanding, and cross-modal reasoning',
    ),
    'multilingual': const BenchmarkCategory(
      name: 'Multilingual',
      benchmarks: ['MGSM', 'XL-Sum', 'FLORES'],
      description: 'Performance across languages and translation',
    ),
    'longContext': const BenchmarkCategory(
      name: 'Long Context',
      benchmarks: ['RULER', 'NIAH', 'InfiniteBench', 'LongBench'],
      description: 'Retrieval and reasoning over long documents',
    ),
  };

  /// Retrieve a model by its identifier.
  ///
  /// Returns `null` if the model is not found in the catalog.
  ///
  /// ```dart
  /// final model = BenchGecko.getModel('gpt-4o');
  /// print(model?.name);     // GPT-4o
  /// print(model?.provider); // OpenAI
  /// ```
  static Model? getModel(String modelId) {
    final data = _models[modelId];
    if (data == null) return null;
    return Model(
      id: modelId,
      name: data['name'] as String,
      provider: data['provider'] as String,
      parameters: data['parameters'] as double?,
      contextWindow: data['contextWindow'] as int?,
      inputPrice: data['inputPrice'] as double?,
      outputPrice: data['outputPrice'] as double?,
      benchmarks: Map<String, double>.from(data['benchmarks'] as Map),
    );
  }

  /// List all available model identifiers.
  static List<String> listModels() => _models.keys.toList()..sort();

  /// Compare two models across benchmarks and pricing.
  ///
  /// Positive diff values mean model A scores higher.
  ///
  /// ```dart
  /// final result = BenchGecko.compareModels('gpt-4o', 'claude-3.5-sonnet');
  /// print(result?.cheaper);    // gpt-4o
  /// print(result?.costRatio);  // 0.69
  /// ```
  static ComparisonResult? compareModels(String idA, String idB) {
    final a = getModel(idA);
    final b = getModel(idB);
    if (a == null || b == null) return null;

    final allBenchmarks = {...a.benchmarks.keys, ...b.benchmarks.keys};
    final benchmarkDiff = <String, double?>{};

    for (final bench in allBenchmarks) {
      final sa = a.score(bench);
      final sb = b.score(bench);
      benchmarkDiff[bench] =
          (sa != null && sb != null) ? double.parse((sa - sb).toStringAsFixed(2)) : null;
    }

    final costA = a.costPerMillion;
    final costB = b.costPerMillion;
    String? cheaper;
    if (costA != null && costB != null) {
      cheaper = costA <= costB ? idA : idB;
    }
    final costRatio = (costA != null && costB != null && costB > 0)
        ? double.parse((costA / costB).toStringAsFixed(2))
        : null;

    return ComparisonResult(
      modelA: a.toSummary(),
      modelB: b.toSummary(),
      benchmarkDiff: benchmarkDiff,
      cheaper: cheaper,
      costRatio: costRatio,
    );
  }

  /// Estimate inference cost for a given token volume.
  ///
  /// ```dart
  /// final cost = BenchGecko.estimateCost('gpt-4o',
  ///   inputTokens: 1000000, outputTokens: 500000);
  /// print(cost?.total); // 7.5
  /// ```
  static CostEstimate? estimateCost(
    String modelId, {
    required int inputTokens,
    int outputTokens = 0,
  }) {
    final model = getModel(modelId);
    if (model == null || model.inputPrice == null || model.outputPrice == null) return null;

    final inputCost =
        double.parse((model.inputPrice! * inputTokens / 1000000.0).toStringAsFixed(4));
    final outputCost =
        double.parse((model.outputPrice! * outputTokens / 1000000.0).toStringAsFixed(4));

    return CostEstimate(
      model: model.name,
      inputTokens: inputTokens,
      outputTokens: outputTokens,
      inputCost: inputCost,
      outputCost: outputCost,
      total: double.parse((inputCost + outputCost).toStringAsFixed(4)),
    );
  }

  /// List all benchmark categories tracked by BenchGecko.
  static Map<String, BenchmarkCategory> benchmarkCategories() => _categories;

  /// Find models scoring above a threshold on a given benchmark.
  ///
  /// Results are sorted by score descending.
  ///
  /// ```dart
  /// final top = BenchGecko.topModels('MMLU', minScore: 87.0);
  /// for (final m in top) {
  ///   print('${m.name}: ${m.score("MMLU")}');
  /// }
  /// ```
  static List<Model> topModels(String benchmark, {double minScore = 0}) {
    final results = <Model>[];
    for (final id in _models.keys) {
      final model = getModel(id)!;
      final s = model.score(benchmark);
      if (s != null && s >= minScore) {
        results.add(model);
      }
    }
    results.sort((a, b) => (b.score(benchmark) ?? 0).compareTo(a.score(benchmark) ?? 0));
    return results;
  }

  /// Find the cheapest model meeting a minimum benchmark score.
  ///
  /// ```dart
  /// final pick = BenchGecko.cheapestAbove('MMLU', 85.0);
  /// print('${pick?.name} at \$${pick?.costPerMillion}/M tokens');
  /// ```
  static Model? cheapestAbove(String benchmark, double minScore) {
    final candidates =
        topModels(benchmark, minScore: minScore).where((m) => m.costPerMillion != null).toList();
    if (candidates.isEmpty) return null;
    candidates.sort((a, b) => a.costPerMillion!.compareTo(b.costPerMillion!));
    return candidates.first;
  }
}
