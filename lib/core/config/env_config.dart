import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'env_config.g.dart';

/// Environment configuration state
class EnvConfig {
  const EnvConfig({
    required this.baseApiUrl,
    required this.env,
    required this.sentryDsn,
    required this.qrEncryptionKey,
  });

  final String baseApiUrl;
  final String env;
  final String sentryDsn;
  final String qrEncryptionKey;
}

/// Global variable to hold env config (set during bootstrap)
/// This is necessary because bootstrap runs before ProviderScope
EnvConfig? _envConfig;

/// Initialize environment config (called from bootstrap)
void initEnvConfig({
  required String baseApiUrl,
  required String env,
  required String sentryDsn,
  required String qrEncryptionKey,
}) {
  _envConfig = EnvConfig(
    baseApiUrl: baseApiUrl,
    env: env,
    sentryDsn: sentryDsn,
    qrEncryptionKey: qrEncryptionKey,
  );
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
