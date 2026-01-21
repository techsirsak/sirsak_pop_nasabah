import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'env_config.g.dart';

/// Environment configuration state
class EnvConfig {
  const EnvConfig({
    required this.baseApiUrl,
    required this.env,
  });

  final String baseApiUrl;
  final String env;
}

/// Global variable to hold env config (set during bootstrap)
/// This is necessary because bootstrap runs before ProviderScope
EnvConfig? _envConfig;

/// Initialize environment config (called from bootstrap)
void initEnvConfig({
  required String baseApiUrl,
  required String env,
}) {
  _envConfig = EnvConfig(baseApiUrl: baseApiUrl, env: env);
}

/// Provider for accessing environment configuration
@riverpod
EnvConfig envConfig(Ref ref) {
  if (_envConfig == null) {
    throw StateError(
      'EnvConfig not initialized. Call initEnvConfig() in bootstrap.',
    );
  }
  return _envConfig!;
}
