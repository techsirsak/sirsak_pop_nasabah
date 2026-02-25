import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:sirsak_pop_nasabah/core/constants/route_path.dart';
import 'package:sirsak_pop_nasabah/core/router/app_router.dart';
import 'package:sirsak_pop_nasabah/core/theme/app_fonts.dart';
import 'package:sirsak_pop_nasabah/l10n/extension.dart';
import 'package:sirsak_pop_nasabah/shared/widgets/buttons.dart';

/// Shows a bottom sheet prompting the user to log in to access a protected
/// feature.
///
/// This is used for features that require authentication (Scan QR, Wallet).
/// The bottom sheet provides options to log in, register, or dismiss.
Future<void> showLoginRequiredBottomSheet(
  BuildContext context,
  WidgetRef ref,
) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => _LoginRequiredBottomSheet(ref: ref),
  );
}

class _LoginRequiredBottomSheet extends StatelessWidget {
  const _LoginRequiredBottomSheet({required this.ref});

  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final l10n = context.l10n;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Gap(12),
              // Handle indicator and close button
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: colorScheme.onSurfaceVariant.withValues(
                    alpha: 0.4,
                  ),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const Gap(24),

              // Lock icon
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  PhosphorIcons.lock(),
                  size: 36,
                  color: colorScheme.primaryContainer,
                ),
              ),
              const Gap(20),

              // Title
              Text(
                l10n.authGuardLoginRequired,
                style: textTheme.titleLarge?.copyWith(
                  fontVariations: AppFonts.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const Gap(8),

              // Message
              Text(
                l10n.authGuardLoginMessage,
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              const Gap(32),

              // Login button
              SButton(
                text: l10n.authGuardLoginButton,
                onPressed: () {
                  Navigator.of(context).pop();
                  unawaited(ref.read(routerProvider).push(SAppRoutePath.login));
                },
                size: ButtonSize.large,
              ),
              const Gap(12),

              // Register button
              SButton(
                text: l10n.authGuardRegisterButton,
                onPressed: () {
                  Navigator.of(context).pop();
                  unawaited(
                    ref.read(routerProvider).push(SAppRoutePath.signUp),
                  );
                },
                variant: ButtonVariant.outlined,
                size: ButtonSize.large,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
