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
  String get cancel => 'Batal';

  @override
  String get continueWithGoogle => 'Lanjutkan dengan Google';

  @override
  String get dontHaveAccount => 'Belum punya akun?';

  @override
  String get emailAddress => 'Alamat Email';

  @override
  String get emailInvalid => 'Format email tidak valid';

  @override
  String get emailLabel => 'Email';

  @override
  String get emailRequired => 'Email wajib diisi';

  @override
  String get error => 'Kesalahan';

  @override
  String get forgotPassword => 'Lupa Kata Sandi?';

  @override
  String get generalErrorTitle => 'Terjadi kesalahan';

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

  @override
  String get landingPageContactEmail => 'hello@sirsak.com';

  @override
  String get landingPageContactInstagram => 'sirsak.hub';

  @override
  String get landingPageContactPhone => '+628 777 0808 578';

  @override
  String get landingPageFeature1Desc =>
      'titik pengumpulan sampah terdekat Anda';

  @override
  String get landingPageFeature1Title => 'Temukan';

  @override
  String get landingPageFeature2Desc => 'sampah daur ulang yang sudah dipilah';

  @override
  String get landingPageFeature2Title => 'Buanglah';

  @override
  String get landingPageFeature3Desc => 'dan tukarkan hadiah!';

  @override
  String get landingPageFeature3Title => 'Dapatkan poin';

  @override
  String get landingPageGetStartedButton => 'Daftar';

  @override
  String get landingPageSignInButton => 'Masuk';

  @override
  String get landingPageTitlePart1 => 'Membangun jaringan ';

  @override
  String get landingPageTitlePart2 => 'terbesar\ndan tertelusur';

  @override
  String get landingPageTitlePart3 => ' untuk limbah Indonesia';

  @override
  String get loading => 'Memuat...';

  @override
  String get loginButton => 'Masuk';

  @override
  String get loginTitle => 'Masuk';

  @override
  String get ok => 'OK';

  @override
  String get or => 'atau';

  @override
  String get passwordLabel => 'Kata Sandi';

  @override
  String get passwordMinLength => 'Kata sandi minimal 6 karakter';

  @override
  String get passwordRequired => 'Kata sandi wajib diisi';

  @override
  String get signIn => 'Masuk';

  @override
  String get signUp => 'Daftar sekarang';

  @override
  String get splashTitle => 'Selamat Datang';

  @override
  String get tutorialDesc1 =>
      'Cari titik pengumpulan sampah terdekat di sekitar Anda';

  @override
  String get tutorialDesc2 =>
      'Bawa sampah daur ulang yang sudah dipilah ke titik pengumpulan';

  @override
  String get tutorialDesc3 =>
      'Raih poin sebagai hadiah untuk setiap sampah yang Anda buang';

  @override
  String get tutorialDesc4 =>
      'Gunakan poin Anda untuk menukar hadiah dan hadiah menarik';

  @override
  String get tutorialSkip => 'Lewati';

  @override
  String get tutorialStartButton => 'Mulai Sekarang!';

  @override
  String get tutorialTitle1 => 'Temukan Titik Pengumpulan';

  @override
  String get tutorialTitle2 => 'Buang Sampah Anda';

  @override
  String get tutorialTitle3 => 'Dapatkan Poin';

  @override
  String get tutorialTitle4 => 'Tukar Hadiah';

  @override
  String welcomeUser(String userName) {
    return 'Selamat datang, $userName!';
  }
}
