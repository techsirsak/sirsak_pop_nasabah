import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:sirsak_pop_nasabah/l10n/extension.dart';

class LocationFoundToast extends StatefulWidget {
  const LocationFoundToast({
    required this.onDismiss,
    super.key,
  });

  final VoidCallback onDismiss;

  @override
  State<LocationFoundToast> createState() => _LocationFoundToastState();
}

class _LocationFoundToastState extends State<LocationFoundToast>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  Timer? _dismissTimer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    unawaited(_controller.forward());

    // Auto dismiss after 3 seconds
    _dismissTimer = Timer(const Duration(seconds: 3), () {
      unawaited(_controller.reverse().then((_) {
        widget.onDismiss();
      }));
    });
  }

  @override
  void dispose() {
    _dismissTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: colorScheme.tertiaryContainer,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: .1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              PhosphorIcons.mapPin(PhosphorIconsStyle.fill),
              size: 16,
              color: colorScheme.tertiary,
            ),
            const Gap(6),
            Text(
              context.l10n.dropPointLocationFound,
              style: textTheme.labelMedium?.copyWith(
                color: colorScheme.onTertiaryContainer,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
