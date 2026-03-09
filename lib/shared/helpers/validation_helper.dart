/// Shared validation helper for form validation across the app.
/// Returns localization key strings for error messages, or null if valid.
class ValidationHelper {
  ValidationHelper._();

  /// Validates email format.
  /// Returns error key or null if valid.
  static String? validateEmail(String email) {
    final trimmed = email.trim();
    if (trimmed.isEmpty) return 'emailRequired';

    // Supports standard email format including + for aliases
    final emailRegex = RegExp(r'^[\w-\.+]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(trimmed)) return 'emailInvalid';

    return null;
  }

  /// Validates password with minimum length requirement.
  /// Returns error key or null if valid.
  static String? validatePassword(String password) {
    if (password.isEmpty) return 'passwordRequired';
    if (password.length < 6) return 'passwordMinLength';
    return null;
  }

  /// Returns a map of password criteria and their validation status.
  /// Used for displaying real-time password strength checklist.
  static Map<String, bool> getPasswordCriteria(String password) {
    return {
      'minLength': password.length >= 8,
      'hasUppercase': password.contains(RegExp('[A-Z]')),
      'hasAlphanumeric':
          password.contains(RegExp('[a-zA-Z]')) &&
          password.contains(RegExp('[0-9]')),
    };
  }

  /// Validates password meets all security criteria.
  /// Returns error key or null if valid.
  static String? validatePasswordSecurity(String password) {
    if (password.isEmpty) return 'passwordRequired';
    final criteria = getPasswordCriteria(password);
    if (!criteria.values.every((v) => v)) return 'passwordCriteriaNotMet';
    return null;
  }
}
