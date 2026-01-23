import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:sirsak_pop_nasabah/core/theme/app_fonts.dart';
import 'package:sirsak_pop_nasabah/features/auth/verify_email/verify_email_viewmodel.dart';
import 'package:sirsak_pop_nasabah/l10n/extension.dart';
import 'package:sirsak_pop_nasabah/shared/widgets/buttons.dart';

class VerifyEmailView extends ConsumerWidget {
  const VerifyEmailView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final l10n = context.l10n;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const Spacer(),
              const Gap(48),
              // Email Icon
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  PhosphorIcons.envelopeSimple(),
                  size: 64,
                  color: colorScheme.primary,
                ),
              ),
              const Gap(32),
              // Title
              Text(
                l10n.verifyEmailTitle,
                style: textTheme.titleLarge?.copyWith(
                  fontVariations: AppFonts.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const Gap(16),
              // Description
              Text(
                l10n.verifyEmailDescription,
                style: textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              // Open Email App Button
              SButton(
                onPressed: () => ref
                    .read(verifyEmailViewModelProvider.notifier)
                    .openEmailApp(),
                text: l10n.verifyEmailOpenEmail,
              ),
              const Gap(16),
              // Go to Login Button
              SButton(
                onPressed: () => ref
                    .read(verifyEmailViewModelProvider.notifier)
                    .navigateToLogin(),
                variant: ButtonVariant.outlined,
                text: l10n.verifyEmailGoToLogin,
              ),
              const Gap(48),
            ],
          ),
        ),
      ),
    );
  }
}
