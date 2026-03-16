import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:sirsak_pop_nasabah/core/theme/app_fonts.dart';
import 'package:sirsak_pop_nasabah/shared/widgets/buttons.dart';

class EmailSentSuccessView extends StatelessWidget {
  const EmailSentSuccessView({
    required this.title,
    required this.description,
    required this.primaryButtonText,
    required this.secondaryButtonText,
    required this.onPrimaryPressed,
    required this.onSecondaryPressed,
    super.key,
  });

  final String title;
  final String description;
  final String primaryButtonText;
  final String secondaryButtonText;
  final VoidCallback onPrimaryPressed;
  final VoidCallback onSecondaryPressed;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

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
                title,
                style: textTheme.titleLarge?.copyWith(
                  fontVariations: AppFonts.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const Gap(16),
              // Description
              Text(
                description,
                style: textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              // Primary Button
              SButton(
                onPressed: onPrimaryPressed,
                text: primaryButtonText,
              ),
              const Gap(16),
              // Secondary Button
              SButton(
                onPressed: onSecondaryPressed,
                variant: ButtonVariant.outlined,
                text: secondaryButtonText,
              ),
              const Gap(48),
            ],
          ),
        ),
      ),
    );
  }
}
