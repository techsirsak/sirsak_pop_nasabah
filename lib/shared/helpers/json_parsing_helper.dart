/// Helper to parse JSON fields with detailed error messages
T parseField<T>(String field, dynamic value, T Function(dynamic) parser) {
  try {
    return parser(value);
  } catch (e) {
    final errText =
        'Error parsing "$field" - '
        'expected $T, got ${value.runtimeType} with value: $value';
    throw FormatException(errText);
  }
}

/// Helper to parse required String fields with null check
String parseRequiredString(String field, dynamic value) {
  if (value == null) {
    final errText = 'Error parsing "$field" - expected String, got null';
    throw FormatException(errText);
  }
  if (value is! String) {
    final errText =
        'Error parsing "$field" - '
        'expected String, got ${value.runtimeType} with value: $value';
    throw FormatException(errText);
  }
  return value;
}
