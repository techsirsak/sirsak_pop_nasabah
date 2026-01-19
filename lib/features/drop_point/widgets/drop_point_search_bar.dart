import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:sirsak_pop_nasabah/l10n/extension.dart';

class DropPointSearchBar extends StatelessWidget {
  const DropPointSearchBar({
    required this.value,
    required this.onChanged,
    required this.onClear,
    super.key,
  });

  final String value;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: colorScheme.outlineVariant,
        ),
      ),
      child: TextField(
        onChanged: onChanged,
        controller: TextEditingController(text: value)
          ..selection = TextSelection.fromPosition(
            TextPosition(offset: value.length),
          ),
        decoration: InputDecoration(
          hintText: context.l10n.dropPointSearchPlaceholder,
          hintStyle: textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
          prefixIcon: Padding(
            padding: const EdgeInsets.only(left: 16, right: 8),
            child: Icon(
              PhosphorIcons.magnifyingGlass(),
              color: colorScheme.onSurfaceVariant,
              size: 20,
            ),
          ),
          prefixIconConstraints: const BoxConstraints(
            minWidth: 44,
            minHeight: 44,
          ),
          suffixIcon: value.isNotEmpty
              ? IconButton(
                  icon: Icon(
                    PhosphorIcons.x(),
                    color: colorScheme.onSurfaceVariant,
                    size: 18,
                  ),
                  onPressed: onClear,
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
        style: textTheme.bodyMedium,
      ),
    );
  }
}
