// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class AppLocalizationsId extends AppLocalizations {
  AppLocalizationsId([String locale = 'id']) : super(locale);

  @override
  String get appName => 'Sirsak Pop Nasabah';

  @override
  String get loading => 'Memuat...';

  @override
  String get error => 'Kesalahan';

  @override
  String get cancel => 'Batal';

  @override
  String get ok => 'OK';

  @override
  String get splashTitle => 'Selamat Datang';

  @override
  String get loginTitle => 'Masuk';

  @override
  String get emailLabel => 'Email';

  @override
  String get passwordLabel => 'Kata Sandi';

  @override
  String get loginButton => 'Masuk';

  @override
  String get emailRequired => 'Email wajib diisi';

  @override
  String get emailInvalid => 'Format email tidak valid';

  @override
  String get passwordRequired => 'Kata sandi wajib diisi';

  @override
  String get passwordMinLength => 'Kata sandi minimal 6 karakter';

  @override
  String welcomeUser(String userName) {
    return 'Selamat datang, $userName!';
  }

  @override
  String itemCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count item',
      one: '1 item',
      zero: 'Tidak ada item',
    );
    return '$_temp0';
  }
}
