import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sirsak_pop_nasabah/features/auth/verify_email/verify_email_viewmodel.dart';
import 'package:sirsak_pop_nasabah/l10n/extension.dart';
import 'package:sirsak_pop_nasabah/shared/widgets/email_sent_success_view.dart';

class VerifyEmailView extends ConsumerWidget {
  const VerifyEmailView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.read(verifyEmailViewModelProvider.notifier);
    final l10n = context.l10n;

    return EmailSentSuccessView(
      title: l10n.verifyEmailTitle,
      description: l10n.verifyEmailDescription,
      primaryButtonText: l10n.verifyEmailOpenEmail,
      secondaryButtonText: l10n.verifyEmailGoToLogin,
      onPrimaryPressed: viewModel.openEmailApp,
      onSecondaryPressed: viewModel.navigateToLogin,
    );
  }
}
