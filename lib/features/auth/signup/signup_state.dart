import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sirsak_pop_nasabah/features/qr_scan/qr_scan_state.dart';

part 'signup_state.freezed.dart';

@freezed
abstract class SignupState with _$SignupState {
  const factory SignupState({
    // Form fields
    @Default('') String fullName,
    @Default('') String email,
    @Default('') String phoneNumber,
    @Default('') String password,
    @Default('') String confirmPassword,
    @Default(false) bool acceptedTerms,

    // Loading state
    @Default(false) bool isLoading,

    // General error message
    String? errorMessage,

    // Field-specific error keys (i18n keys)
    String? fullNameError,
    String? emailError,
    String? phoneNumberError,
    String? passwordError,
    String? confirmPasswordError,
    String? termsError,

    // QR scan data fields
    /// BSU ID from QR scan (for registerBsu type)
    String? bsuId,

    /// BSU name to display in UI (for registerBsu type)
    String? bsuName,

    /// Nasabah ID from QR scan (for registerNasabah type)
    String? nasabahId,

    /// QR type that was scanned
    QrType? qrType,
  }) = _SignupState;
}
