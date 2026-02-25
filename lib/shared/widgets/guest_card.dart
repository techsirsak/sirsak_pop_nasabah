import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:sirsak_pop_nasabah/core/constants/route_path.dart';
import 'package:sirsak_pop_nasabah/core/router/app_router.dart';
import 'package:sirsak_pop_nasabah/core/theme/app_colors.dart';
import 'package:sirsak_pop_nasabah/l10n/extension.dart';
import 'package:sirsak_pop_nasabah/shared/widgets/buttons.dart';

class GuestCard extends ConsumerWidget {
  const GuestCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final l10n = context.l10n;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: colorScheme.pointsCardGradient,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.guestProfileMessage,
              style: textTheme.bodyLarge?.copyWith(
                color: Colors.white,
              ),
            ),
            const Gap(24),
            // Login button
            SButton(
              text: l10n.guestProfileLoginButton,
              onPressed: () {
                unawaited(ref.read(routerProvider).push(SAppRoutePath.login));
              },
              size: ButtonSize.large,
              backgroundColor: Colors.white,
              foregroundColor: colorScheme.primary,
            ),
            const Gap(12),
            // Register button
            SButton(
              text: l10n.authGuardRegisterButton,
              onPressed: () {
                unawaited(ref.read(routerProvider).push(SAppRoutePath.signUp));
              },
              variant: ButtonVariant.outlined,
              size: ButtonSize.large,
              foregroundColor: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
