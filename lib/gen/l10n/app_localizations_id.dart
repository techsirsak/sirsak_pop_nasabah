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
  String get homeChallenges => 'Tantangan';

  @override
  String get homeChallengesDesc => 'Selesaikan tantangan, dapatkan hadiahnya!';

  @override
  String homeChallengeProgress(int current, int total, String itemType) {
    return '$current/$total $itemType terkumpulkan';
  }

  @override
  String get homeEvents => 'Acara';

  @override
  String homeGreeting(String userName) {
    return 'Selamat datang kembali, $userName!';
  }

  @override
  String get homeHistory => 'Riwayat';

  @override
  String get homeImpactCarbonLabel => 'Emisi Karbon Terhindari';

  @override
  String get homeImpactRecycledLabel => 'Sampah Terdaur Ulang';

  @override
  String get homeImpactWasteLabel => 'Sampah Terkumpulkan';

  @override
  String get homePoints => 'poin Sirsak';

  @override
  String get homeRegisterNow => 'Daftar sekarang';

  @override
  String get homeRewards => 'Hadiah';

  @override
  String get homeSetorSampah => 'Setor Sampah';

  @override
  String get homeSetorSampahDesc => 'Temukan Drop Point sampah terdekat!';

  @override
  String get homeTakeAction => 'Ambil Aksi';

  @override
  String get homeWithdraw => 'Tarik';

  @override
  String get homeYourImpact => 'Dampak Anda';

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
  String get landingPageFeature1 =>
      '**Temukan** titik pengumpulan sampah terdekat Anda';

  @override
  String get landingPageFeature2 =>
      '**Buanglah** sampah daur ulang yang sudah dipilah';

  @override
  String get landingPageFeature3 => '**Dapatkan poin** dan tukarkan hadiah!';

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
      '**Pisahkan** sampah daur ulang anda ke dalam kategori berikut: **plastik berlapis**, **botol PET**, **kertas**, dan **sampah daur ulang lainnya**.';

  @override
  String get tutorialDesc2 =>
      '**Bawa** dan buang sampah di **bank sampah dan titik pengumpulan lainnya** yang terdaftar dalam komunitas Sirsak.';

  @override
  String get tutorialDesc3 =>
      '**Dapatkan poin** untuk setiap sampah yang dikembalikan ke titik pengumpulan. Tukarkan dengan **voucher**, **diskon**, dan **hadiah** lainnya.';

  @override
  String get tutorialDesc4 =>
      'Kami memastikan semua sampah yang dikirim ke titik pengumpulan akan **ditangani secara bertanggung jawab** untuk **meminimalkan dampak lingkungan**.';

  @override
  String get tutorialSkip => 'Lewatkan';

  @override
  String get tutorialStartButton => 'Mulai Sekarang!';

  @override
  String get tutorialTitle1 => 'Pilah sampahmu';

  @override
  String get tutorialTitle2 =>
      'Buang sampah di titik pengumpulan terdekat Anda';

  @override
  String get tutorialTitle3 => 'Dapatkan hadiah eksklusif';

  @override
  String get tutorialTitle4 => 'Bergabunglah dengan komunitas kami';

  @override
  String welcomeUser(String userName) {
    return 'Selamat datang, $userName!';
  }
}
