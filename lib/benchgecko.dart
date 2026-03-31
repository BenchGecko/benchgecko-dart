/// Official Dart SDK for the BenchGecko API.
///
/// Compare AI models, benchmarks, and pricing programmatically.
///
/// ```dart
/// import 'package:benchgecko/benchgecko.dart';
///
/// final client = BenchGeckoClient();
/// final models = await client.models();
/// print('Tracking ${models.length} models');
/// ```
library benchgecko;

export 'src/client.dart';
export 'src/models.dart';
