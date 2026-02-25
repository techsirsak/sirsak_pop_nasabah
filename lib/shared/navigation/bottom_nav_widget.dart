import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:sirsak_pop_nasabah/services/auth_state_provider.dart';
import 'package:sirsak_pop_nasabah/shared/navigation/bottom_nav_provider.dart';
import 'package:sirsak_pop_nasabah/shared/widgets/login_required_bottom_sheet.dart';

class AppBottomNavBar extends ConsumerWidget {
  const AppBottomNavBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(bottomNavProvider).selectedIndex;
    final notifier = ref.read(bottomNavProvider.notifier);
    final isAuthenticated = ref.watch(isAuthenticatedProvider);
    final colorScheme = Theme.of(context).colorScheme;

    // Protected tabs that require authentication (QR Scan = 2, Wallet = 3)
    void onProtectedTabTap(int index) {
      if (isAuthenticated) {
        notifier.setTab(index);
      } else {
        unawaited(showLoginRequiredBottomSheet(context, ref));
      }
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          height: 70,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavBarItem(
                icon: PhosphorIcons.houseLine(),
                iconFilled: PhosphorIcons.houseLine(PhosphorIconsStyle.fill),
                label: 'Home',
                isSelected: selectedIndex == 0,
                onTap: () => notifier.setTab(0),
                colorScheme: colorScheme,
              ),
              _NavBarItem(
                icon: PhosphorIcons.buildings(),
                iconFilled: PhosphorIcons.buildings(PhosphorIconsStyle.fill),
                label: 'Drop Point',
                isSelected: selectedIndex == 1,
                onTap: () => notifier.setTab(1),
                colorScheme: colorScheme,
              ),
              // Center QR Scan button
              _QRScanButton(
                isSelected: selectedIndex == 2,
                onTap: () => onProtectedTabTap(2),
                colorScheme: colorScheme,
              ),
              _NavBarItem(
                icon: PhosphorIcons.wallet(),
                iconFilled: PhosphorIcons.wallet(PhosphorIconsStyle.fill),
                label: 'Wallet',
                isSelected: selectedIndex == 3,
                onTap: () => onProtectedTabTap(3),
                colorScheme: colorScheme,
              ),
              _NavBarItem(
                icon: PhosphorIcons.user(),
                iconFilled: PhosphorIcons.user(PhosphorIconsStyle.fill),
                label: 'Profile',
                isSelected: selectedIndex == 4,
                onTap: () => notifier.setTab(4),
                colorScheme: colorScheme,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavBarItem extends StatelessWidget {
  const _NavBarItem({
    required this.icon,
    required this.iconFilled,
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.colorScheme,
  });

  final IconData icon;
  final IconData iconFilled;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isSelected ? iconFilled : icon,
              color: isSelected
                  ? colorScheme.primary
                  : colorScheme.onSurfaceVariant,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: textTheme.labelSmall?.copyWith(
                color: isSelected
                    ? colorScheme.primary
                    : colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QRScanButton extends StatelessWidget {
  const _QRScanButton({
    required this.isSelected,
    required this.onTap,
    required this.colorScheme,
  });

  final bool isSelected;
  final VoidCallback onTap;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Material(
        color: colorScheme.primary,
        shape: const CircleBorder(),
        elevation: 4,
        child: InkWell(
          onTap: onTap,
          customBorder: const CircleBorder(),
          child: Container(
            width: 56,
            height: 56,
            alignment: Alignment.center,
            child: Icon(
              PhosphorIcons.qrCode(),
              color: Colors.white,
              size: 28,
            ),
          ),
        ),
      ),
    );
  }
}
