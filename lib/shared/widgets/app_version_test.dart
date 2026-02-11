import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sirsak_pop_nasabah/core/providers/app_version_provider.dart';
import 'package:sirsak_pop_nasabah/l10n/extension.dart';

class AppVersionText extends ConsumerWidget {
  const AppVersionText({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return ref
        .watch(appVersionProvider)
        .when(
          data: (version) => Center(
            child: Text(
              context.l10n.appVersion(version),
              style: textTheme.labelMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          loading: () => const SizedBox.shrink(),
          error: (_, _) => const SizedBox.shrink(),
        );
  }
}
