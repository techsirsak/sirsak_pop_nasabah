extension StringX on String {
  /// Capitalize first letter in the provided text
  String get capitalize {
    if (trim().isEmpty) return this;
    final value = '${this[0].toUpperCase()}${substring(1)}';
    return value;
  }

  /// Get word initials
  String get initials {
    if (trim().isEmpty) return this;
    final words = split(' ');

    final value = words.fold('', (p, current) => p + current[0].toUpperCase());
    return value;
  }

  /// Get initials of the string.
  String getInitials([int limitTo = 2]) {
    if (trim().isEmpty) return this;

    final buffer = StringBuffer();
    final split = this.split(' ');

    if (split.length == 1) {
      return substring(0, 1).toUpperCase();
    }

    for (var i = 0; i < limitTo; i++) {
      if (split[i].isNotEmpty) {
        buffer.write(split[i][0]);
      }
    }

    return buffer.toString().toUpperCase();
  }

  /// Get first word
  String get firstWord {
    if (trim().isEmpty) return this;
    final value = split(' ').first;
    return value;
  }
}
