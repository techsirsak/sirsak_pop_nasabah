import 'package:flutter/material.dart';

/// Parses text with markdown-style bold syntax (**text**) and returns
/// a list of TextSpan widgets with appropriate styling.
///
/// Example:
/// ```dart
/// final spans = parseRichText(
///   'This is **bold** text',
///   baseStyle: TextStyle(fontSize: 14),
///   boldFontVariations: AppFonts.bold,
/// );
/// ```
List<TextSpan> parseRichText(
  String text, {
  required TextStyle baseStyle,
  required List<FontVariation> boldFontVariations,
}) {
  final spans = <TextSpan>[];
  final boldPattern = RegExp(r'\*\*(.*?)\*\*');

  var currentIndex = 0;

  for (final match in boldPattern.allMatches(text)) {
    // Add regular text before the bold section
    if (match.start > currentIndex) {
      spans.add(
        TextSpan(
          text: text.substring(currentIndex, match.start),
          style: baseStyle,
        ),
      );
    }

    // Add bold text
    spans.add(
      TextSpan(
        text: match.group(1), // Text inside **...**
        style: baseStyle.copyWith(
          fontVariations: boldFontVariations,
        ),
      ),
    );

    currentIndex = match.end;
  }

  // Add any remaining regular text after the last bold section
  if (currentIndex < text.length) {
    spans.add(
      TextSpan(
        text: text.substring(currentIndex),
        style: baseStyle,
      ),
    );
  }

  return spans;
}
