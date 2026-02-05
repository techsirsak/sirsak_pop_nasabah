import 'package:flutter/material.dart';

class AppDialog extends StatelessWidget {
  const AppDialog({
    required this.dialogBody,
    super.key,
    this.dialogTitle,
    this.dialogFooter,
    this.contentPadding,
    this.maxWidth,
  });

  final String? dialogTitle;
  final Widget dialogBody;
  final Widget? dialogFooter;
  final EdgeInsets? contentPadding;
  final double? maxWidth;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Dialog(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: maxWidth ?? double.infinity,
        ),
        child: SingleChildScrollView(
          padding: contentPadding ?? const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 12,
            children: [
              if (dialogTitle != null)
                Text(dialogTitle!, style: textTheme.titleLarge),
              dialogBody,
              ?dialogFooter,
            ],
          ),
        ),
      ),
    );
  }
}
