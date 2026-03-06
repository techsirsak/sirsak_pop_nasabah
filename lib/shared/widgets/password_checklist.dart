import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:sirsak_pop_nasabah/l10n/extension.dart';
import 'package:sirsak_pop_nasabah/shared/helpers/validation_helper.dart';

/// A widget that displays password security criteria with real-time validation.
class PasswordChecklist extends StatelessWidget {
  const PasswordChecklist({
    required this.password,
    super.key,
  });

  final String password;

  @override
  Widget build(BuildContext context) {
    final criteria = ValidationHelper.getPasswordCriteria(password);
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _ChecklistItem(
          label: context.l10n.passwordMinEightChars,
          isValid: criteria['minLength'] ?? false,
          colorScheme: colorScheme,
        ),
        const Gap(8),
        _ChecklistItem(
          label: context.l10n.passwordRequiresUppercase,
          isValid: criteria['hasUppercase'] ?? false,
          colorScheme: colorScheme,
        ),
        const Gap(8),
        _ChecklistItem(
          label: context.l10n.passwordRequiresAlphanumeric,
          isValid: criteria['hasAlphanumeric'] ?? false,
          colorScheme: colorScheme,
        ),
      ],
    );
  }
}

class _ChecklistItem extends StatelessWidget {
  const _ChecklistItem({
    required this.label,
    required this.isValid,
    required this.colorScheme,
  });

  final String label;
  final bool isValid;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final color = isValid ? Colors.green : colorScheme.onSurfaceVariant;

    return Row(
      children: [
        Icon(
          isValid ? PhosphorIcons.checkCircle() : PhosphorIcons.circle(),
          size: 18,
          color: color,
        ),
        const Gap(8),
        Text(
          label,
          style: textTheme.bodyMedium?.copyWith(
            color: color,
          ),
        ),
      ],
    );
  }
}
