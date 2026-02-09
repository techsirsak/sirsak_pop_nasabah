import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

/// A reusable password text field with built-in visibility toggle.
///
/// This widget manages its own visibility state internally, so each password
/// field can have independent visibility without polluting ViewModel state.
class SPasswordField extends StatefulWidget {
  const SPasswordField({
    required this.onChanged,
    this.controller,
    this.errorText,
    this.hintText,
    this.onSubmitted,
    super.key,
  });

  /// Called when the text field value changes.
  final ValueChanged<String> onChanged;

  /// Optional controller for the text field.
  final TextEditingController? controller;

  /// Error text to display below the field.
  final String? errorText;

  /// Hint text to display when the field is empty.
  final String? hintText;

  /// Called when the user submits the field (e.g., presses Enter).
  final VoidCallback? onSubmitted;

  @override
  State<SPasswordField> createState() => _SPasswordFieldState();
}

class _SPasswordFieldState extends State<SPasswordField> {
  bool _isPasswordVisible = false;

  void _toggleVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return TextField(
      controller: widget.controller,
      onChanged: widget.onChanged,
      onSubmitted: widget.onSubmitted != null
          ? (_) => widget.onSubmitted!()
          : null,
      obscureText: !_isPasswordVisible,
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFFE8EFF5),
        hintText: widget.hintText,
        hintStyle: TextStyle(
          color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
        ),
        suffixIcon: IconButton(
          icon: Icon(
            _isPasswordVisible ? PhosphorIcons.eyeSlash() : PhosphorIcons.eye(),
            color: colorScheme.onSurfaceVariant,
          ),
          onPressed: _toggleVisibility,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: colorScheme.primary,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: colorScheme.error,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: colorScheme.error,
            width: 2,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        errorText: widget.errorText,
      ),
    );
  }
}
