import 'dart:async';

import 'package:sirsak_pop_nasabah/main/bootstrap.dart';

void main() {
  unawaited(
    bootstrap(
      env: 'PROD',
      baseApiUrl: const String.fromEnvironment('baseApiUrl'),
    ),
  );
}
