import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:sirsak_pop_nasabah/core/theme/app_fonts.dart';
import 'package:sirsak_pop_nasabah/l10n/extension.dart';
import 'package:sirsak_pop_nasabah/shared/widgets/app_dialog.dart';

class BsuSuccessDialog extends StatelessWidget {
  const BsuSuccessDialog({required this.onClose, super.key});

  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return AppDialog(
      maxWidth: 400,
      dialogBody: Column(
        children: [
          Icon(
            PhosphorIcons.checkCircle(),
            size: 48,
            color: Theme.of(context).colorScheme.primary,
          ),
          const Gap(12),
          Text(
            l10n.applyBsuSuccess,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontVariations: AppFonts.semiBold,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
      dialogFooter: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
            onClose();
          },
          child: Text(l10n.close),
        ),
      ),
    );
  }
}
