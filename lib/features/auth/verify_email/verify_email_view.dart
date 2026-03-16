import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sirsak_pop_nasabah/core/constants/route_path.dart';
import 'package:sirsak_pop_nasabah/core/router/app_router.dart';
import 'package:sirsak_pop_nasabah/l10n/extension.dart';
import 'package:sirsak_pop_nasabah/services/url_launcher_service.dart';
import 'package:sirsak_pop_nasabah/shared/widgets/email_sent_success_view.dart';

class VerifyEmailView extends ConsumerWidget {
  const VerifyEmailView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;

    return EmailSentSuccessView(
      title: l10n.verifyEmailTitle,
      description: l10n.verifyEmailDescription,
      primaryButtonText: l10n.verifyEmailOpenEmail,
      secondaryButtonText: l10n.verifyEmailGoToLogin,
      onPrimaryPressed: () {
        unawaited(ref.read(urlLauncherServiceProvider).openEmailApp());
      },
      onSecondaryPressed: () =>
          ref.read(routerProvider).go(SAppRoutePath.login),
    );
  }
}
