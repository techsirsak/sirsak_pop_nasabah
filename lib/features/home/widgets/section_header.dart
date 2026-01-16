import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:sirsak_pop_nasabah/core/theme/app_fonts.dart';

class SectionHeader extends StatelessWidget {
  const SectionHeader({
    required this.icon,
    required this.title,
    super.key,
  });

  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Icon(
            icon,
            color: colorScheme.primary,
            size: 24,
          ),
          const Gap(8),
          Text(
            title,
            style: textTheme.titleLarge?.copyWith(
              fontVariations: AppFonts.semiBold,
            ),
          ),
        ],
      ),
    );
  }
}
