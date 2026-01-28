import 'package:flutter/material.dart';
import 'package:sirsak_pop_nasabah/l10n/extension.dart';
import 'package:sirsak_pop_nasabah/shared/widgets/info_dialog.dart';

/// A dialog that displays information about wallet balance types.
///
/// Shows explanations for:
/// - Sirsak Points: Points earned at SirCle (RVM) and Wartabak collection
///   points
/// - Saldo Bank Sampah: Cash balance earned at waste banks
class BalanceInfoDialog extends StatelessWidget {
  const BalanceInfoDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return InfoDialog(
      sections: [
        InfoDialogSection(
          title: l10n.walletSirsakPoints,
          description: l10n.walletBalanceInfoSirsakPointsDesc,
        ),
        InfoDialogSection(
          title: l10n.walletBankSampahBalance,
          description: l10n.walletBalanceInfoBankSampahDesc,
        ),
      ],
    );
  }
}
