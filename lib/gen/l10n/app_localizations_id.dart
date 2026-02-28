// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class AppLocalizationsId extends AppLocalizations {
  AppLocalizationsId([String locale = 'id']) : super(locale);

  @override
  String get applyBsuError => 'Gagal mendaftar ke BSU';

  @override
  String get applyBsuSuccess => 'Berhasil mendaftar ke BSU';

  @override
  String get appName => 'Sirsak Pop Nasabah';

  @override
  String get authGuardLoginButton => 'Masuk';

  @override
  String get authGuardLoginMessage => 'Silakan masuk untuk mengakses fitur ini';

  @override
  String get authGuardLoginRequired => 'Perlu Masuk';

  @override
  String get authGuardRegisterButton => 'Buat Akun';

  @override
  String appVersion(String version) {
    return 'Versi $version';
  }

  @override
  String get cancel => 'Batal';

  @override
  String get changePasswordButton => 'Ubah Kata Sandi';

  @override
  String get changePasswordConfirmPassword => 'Konfirmasi Kata Sandi Baru';

  @override
  String get changePasswordNewPassword => 'Kata Sandi Baru';

  @override
  String get changePasswordSuccess => 'Kata sandi berhasil diubah';

  @override
  String get changePasswordTitle => 'Ubah Kata Sandi';

  @override
  String get close => 'Tutup';

  @override
  String get continueWithGoogle => 'Lanjutkan dengan Google';

  @override
  String get dateToday => 'Hari ini';

  @override
  String get dateTomorrow => 'Besok';

  @override
  String get dateYesterday => 'Kemarin';

  @override
  String get deleteAccountConfirmButton => 'Hapus Akun';

  @override
  String get deleteAccountConfirmationMessage =>
      'Apakah Anda yakin ingin menghapus akun? Tindakan ini tidak dapat dibatalkan.';

  @override
  String get deleteAccountConfirmationTitle => 'Hapus Akun?';

  @override
  String get deleteAccountSuccess => 'Permintaan penghapusan akun berhasil';

  @override
  String get dontHaveAccount => 'Belum punya akun?';

  @override
  String get dropPointBankSampah => 'Bank Sampah';

  @override
  String get dropPointDetailAcceptedWaste => 'Jenis Sampah yang Dapat Diterima';

  @override
  String get dropPointDetailGetDirections => 'Petunjuk Arah';

  @override
  String get dropPointDetailMapUnavailable => 'Lokasi peta tidak tersedia';

  @override
  String dropPointDistance(String distance) {
    return '$distance km dari Anda';
  }

  @override
  String get dropPointDropPoint => 'Drop Point';

  @override
  String get dropPointFilter => 'Filter';

  @override
  String dropPointNextWeighing(String date) {
    return 'Penimbangan Selanjutnya: $date';
  }

  @override
  String get dropPointLocationFound => 'Lokasi ditemukan';

  @override
  String get dropPointLocationPermissionMessage =>
      'Aktifkan lokasi untuk melihat posisi Anda';

  @override
  String get dropPointNoResults => 'Tidak ada drop point ditemukan';

  @override
  String get dropPointNoResultsHint => 'Coba ubah pencarian atau filter Anda';

  @override
  String get dropPointOpenSettings => 'Buka Pengaturan';

  @override
  String dropPointOpenUntil(String time) {
    return 'Buka sampai $time';
  }

  @override
  String get dropPointRvm => 'RVM';

  @override
  String get dropPointSearchPlaceholder => 'Ketik nama daerahmu di sini...';

  @override
  String get dropPointSortBy => 'Urutkan';

  @override
  String get dropPointTitle => 'Drop Point';

  @override
  String get dropPointYourLocation => 'Lokasimu';

  @override
  String get editProfileSaveButton => 'Simpan Perubahan';

  @override
  String get editProfileSaveSuccess => 'Profil berhasil diperbarui';

  @override
  String get editProfileTitle => 'Edit Profil';

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
  String get errorInvalidCredentials =>
      'Email atau kata sandi salah. Silakan coba lagi.';

  @override
  String get errorLoginFailed => 'Login gagal. Silakan coba lagi.';

  @override
  String get errorNetworkConnection =>
      'Kesalahan jaringan. Silakan periksa koneksi Anda.';

  @override
  String get errorServerError => 'Kesalahan server. Silakan coba lagi nanti.';

  @override
  String get forgotPassword => 'Lupa Kata Sandi?';

  @override
  String get generalErrorTitle => 'Terjadi kesalahan';

  @override
  String get getStarted => 'Mulai';

  @override
  String get guestProfileLoginButton => 'Masuk';

  @override
  String get guestProfileMessage =>
      'Masuk untuk mengakses profil Anda, melacak dampak daur ulang, dan mendapatkan hadiah';

  @override
  String get guestProfileTitle => 'Selamat Datang di Sirsak';

  @override
  String homeChallengeProgress(int current, int total, String itemType) {
    return '$current/$total $itemType terkumpulkan';
  }

  @override
  String get homeChallenges => 'Tantangan';

  @override
  String get homeChallengesDesc => 'Selesaikan tantangan, dapatkan hadiahnya!';

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
  String get landingPageRegisterWithQrButton => 'Daftar dengan QR';

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
  String get openEmailAppFailure => 'Tidak dapat membuka aplikasi email';

  @override
  String get or => 'atau';

  @override
  String get passwordLabel => 'Kata Sandi';

  @override
  String get passwordMinLength => 'Kata sandi minimal 6 karakter';

  @override
  String get passwordRequired => 'Kata sandi wajib diisi';

  @override
  String get profileAccountTitle => 'Akun';

  @override
  String get profileApplyBsu => 'Daftar BSU';

  @override
  String get profileBadgesTitle => 'Lencana Kamu';

  @override
  String get profileCarbonAvoided => 'Emisi Karbon\nTerhindari';

  @override
  String get profileChangePassword => 'Ubah Kata Sandi';

  @override
  String get profileChangePasswordDesc => 'Ubah kata sandi akun anda';

  @override
  String get profileContactEmail => 'Email';

  @override
  String get profileContactInstagram => 'Instagram';

  @override
  String get profileContactPhone => 'Telpon (Whatsapp chat):';

  @override
  String get profileContactUs => 'Hubungi Kami:';

  @override
  String get profileDeleteAccount => 'Hapus Akun';

  @override
  String get profileDeleteAccountDesc => 'Hapus akun anda secara permanen';

  @override
  String get profileEdit => 'Edit';

  @override
  String get profileEmailLabel => 'Email';

  @override
  String get profileFaqLinkPre => 'Lihat halaman FAQ ';

  @override
  String get profileFaqLinkText => 'di sini';

  @override
  String get profileFaqQuestion => 'Punya pertanyaan?';

  @override
  String get profileFaqTitle => 'FAQ';

  @override
  String get profileLogout => 'Keluar';

  @override
  String profileMemberSince(String year) {
    return 'Member sejak $year';
  }

  @override
  String get profileNameLabel => 'Nama';

  @override
  String get profilePersonalInfo => 'Informasi Pribadi';

  @override
  String get profilePhoneLabel => 'Nomor Telpon';

  @override
  String get profileWasteCollected => 'Sampah\nTerkumpul';

  @override
  String get profileWasteRecycled => 'Sampah\nTerdaur Ulang';

  @override
  String get qrScanCameraPermission =>
      'Izin kamera diperlukan untuk memindai kode QR';

  @override
  String get qrScanDecryptionFailed =>
      'Tidak dapat membaca kode QR. Silakan coba lagi.';

  @override
  String get qrScanInstruction => 'Arahkan kamera ke kode QR';

  @override
  String get qrScanInvalidCode => 'Kode QR ini tidak valid atau telah diubah';

  @override
  String get qrScanOpenSettings => 'Buka Pengaturan';

  @override
  String get qrScanPermissionDeniedForever =>
      'Izin kamera ditolak secara permanen. Silakan aktifkan di pengaturan.';

  @override
  String get qrScanTitle => 'Pindai Kode QR';

  @override
  String get registeredAt => 'Terdaftar di';

  @override
  String get setorQrScanErrorApi =>
      'Gagal memulai sesi setor. Silakan coba lagi.';

  @override
  String get setorQrScanErrorInvalidQr =>
      'Kode QR ini tidak valid untuk setor sampah';

  @override
  String get setorQrScanInstruction => 'Pindai kode QR di Sircle';

  @override
  String get setorQrScanRetry => 'Pindai Lagi';

  @override
  String get setorQrScanSubmitting => 'Memulai sesi setor...';

  @override
  String get setorQrScanSuccess => 'Scan Berhasil!';

  @override
  String get setorQrScanSuccessMessage => 'Poin telah diperbarui.';

  @override
  String get setorQrScanTitle => 'Setor Sampah';

  @override
  String get register => 'Daftar';

  @override
  String get signIn => 'Masuk';

  @override
  String get signUp => 'Daftar';

  @override
  String get signupAlreadyHaveAccount => 'Sudah punya akun?';

  @override
  String get signupConfirmPassword => 'Konfirmasi Kata Sandi';

  @override
  String get signupConfirmPasswordRequired =>
      'Silakan konfirmasi kata sandi Anda';

  @override
  String get signupFullName => 'Nama Lengkap';

  @override
  String get signupFullNameRequired => 'Nama lengkap wajib diisi';

  @override
  String get signupFullNameTooShort => 'Nama lengkap minimal 2 karakter';

  @override
  String get signupOptional => 'opsional';

  @override
  String get signupPasswordsDoNotMatch => 'Kata sandi tidak cocok';

  @override
  String get signupPhoneHint => '+62 812 3456 7890';

  @override
  String get signupPhoneInvalid => 'Format nomor telepon tidak valid';

  @override
  String get signupPhoneNumber => 'Nomor Telepon';

  @override
  String get signupPrivacyPolicyLink => 'Kebijakan Privasi';

  @override
  String get signupRegisteringAt => 'Mendaftar di';

  @override
  String get signupTermsAnd => ' dan ';

  @override
  String get signupTermsLink => 'Syarat dan Ketentuan';

  @override
  String get signupTermsPrefix => 'Saya menyetujui ';

  @override
  String get signupTermsRequired =>
      'Anda harus menyetujui syarat dan ketentuan serta kebijakan privasi';

  @override
  String get splashTitle => 'Selamat Datang';

  @override
  String get transactionDetailBarang => 'Barang';

  @override
  String get transactionDetailHarga => 'Harga';

  @override
  String get transactionDetailItems => 'Item Transaksi';

  @override
  String get transactionDetailJumlah => 'Jumlah';

  @override
  String get transactionDetailTitle => 'Detail Transaksi';

  @override
  String get transactionDetailTotal => 'Total';

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
  String get verifyEmailDescription =>
      'Kami telah mengirimkan tautan verifikasi ke alamat email Anda. Silakan periksa kotak masuk Anda dan klik tautan untuk memverifikasi akun Anda.';

  @override
  String get verifyEmailGoToLogin => 'Ke Halaman Masuk';

  @override
  String get verifyEmailOpenEmail => 'Buka Aplikasi Email';

  @override
  String get verifyEmailTitle => 'Periksa Email Anda';

  @override
  String get walletBalance => 'Saldo Nasabah';

  @override
  String get walletBalanceInfoBankSampahDesc =>
      'Dapatkan uang tunai dengan mengumpulkan sampah di bank sampah. Saldo bank sampah juga harus ditarik di bank sampah.';

  @override
  String get walletBalanceInfoSirsakPointsDesc =>
      'Dapatkan Sirsak Points dengan membuang sampah di titik pengumpulan SirCle (RVM) dan Wartabak.';

  @override
  String get walletBankSampahBalance => 'Saldo Bank Sampah';

  @override
  String get walletExpiry => 'Masa Berlaku';

  @override
  String get walletGetRewards => 'Dapatkan hadiahmu';

  @override
  String get walletHistory => 'Riwayat';

  @override
  String get walletMonthly => 'Bulan Ini';

  @override
  String get walletRewards => 'Hadiah';

  @override
  String get walletRewardsDesc =>
      'Tukarkan poin dengan voucher, diskon, dan produk eksklusif.';

  @override
  String get walletSirsakPoints => 'Poin Sirsak';

  @override
  String get walletTitle => 'Dompet';

  @override
  String get walletWithdraw => 'Tarik';

  @override
  String get walletWithdrawDesc =>
      'Ubah poin menjadi uang tunai dan transfer ke e-wallet.';

  @override
  String welcomeUser(String userName) {
    return 'Selamat datang, $userName!';
  }
}
