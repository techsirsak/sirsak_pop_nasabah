import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:sirsak_pop_nasabah/core/theme/app_fonts.dart';

/// A reusable info dialog component with an icon, close button, and content
/// sections.
///
/// This dialog displays:
/// - An icon in a colored circle (top left)
/// - A close button (top right)
/// - Multiple content sections with title and description
class InfoDialog extends StatelessWidget {
  const InfoDialog({
    required this.sections,
    this.iconData,
    this.iconBackgroundColor,
    super.key,
  });

  /// The content sections to display in the dialog
  final List<InfoDialogSection> sections;

  /// The icon to display in the top left circle. Defaults to question mark.
  final IconData? iconData;

  /// The background color for the icon circle. Defaults to primary color.
  final Color? iconBackgroundColor;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Icon + Close button
            _DialogHeader(
              iconData: iconData ?? PhosphorIcons.question(),
              iconBackgroundColor: iconBackgroundColor ?? colorScheme.primary,
            ),
            const Gap(16),
            // Content sections
            ...sections.map((section) => _SectionWidget(section: section)),
          ],
        ),
      ),
    );
  }
}

/// A section of content within an [InfoDialog]
class InfoDialogSection {
  const InfoDialogSection({
    required this.title,
    required this.description,
  });

  /// The title text for this section
  final String title;

  /// The description text for this section
  final String description;
}

class _DialogHeader extends StatelessWidget {
  const _DialogHeader({
    required this.iconData,
    required this.iconBackgroundColor,
  });

  final IconData iconData;
  final Color iconBackgroundColor;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Icon in circle
        Icon(
          iconData,
          color: colorScheme.primary,
          size: 32,
        ),
        // Close button
        SizedBox(
          width: 20,
          height: 20,
          child: IconButton(
            visualDensity: .compact,
            alignment: .topRight,
            icon: Icon(
              PhosphorIcons.x(),
              size: 18,
              color: colorScheme.onSurface,
            ),
            onPressed: () => Navigator.of(context).pop(),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ),
      ],
    );
  }
}

class _SectionWidget extends StatelessWidget {
  const _SectionWidget({required this.section});

  final InfoDialogSection section;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            section.title,
            style: textTheme.titleLarge?.copyWith(
              fontVariations: AppFonts.bold,
              color: colorScheme.onSurface,
            ),
          ),
          const Gap(4),
          Text(
            section.description,
            style: textTheme.bodyMedium?.copyWith(
              fontVariations: AppFonts.regular,
              color: colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
