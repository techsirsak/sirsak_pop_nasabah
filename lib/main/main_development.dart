import 'dart:async';

import 'package:sirsak_pop_nasabah/main/bootstrap.dart';

void main() {
  unawaited(
    bootstrap(
      env: 'DEV',
      baseApiUrl: const String.fromEnvironment('baseApiUrl'),
      sentryDsn: const String.fromEnvironment('sentryDsn'),
      qrEncryptionKey: const String.fromEnvironment('qrEncryptionKey'),
      hmacKey: const String.fromEnvironment('hmacKey'),
    ),
  );
}
