// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Sirsak Pop Nasabah';

  @override
  String get cancel => 'Cancel';

  @override
  String get dropPointBankSampah => 'Bank Sampah';

  @override
  String dropPointDistance(String distance) {
    return '$distance km away';
  }

  @override
  String get dropPointDropPoint => 'Drop Point';

  @override
  String get dropPointFilter => 'Filter';

  @override
  String get dropPointLocationFound => 'Location found';

  @override
  String get dropPointLocationPermissionMessage =>
      'Enable location to see your position';

  @override
  String get dropPointNoResults => 'No drop points found';

  @override
  String get dropPointNoResultsHint => 'Try adjusting your search or filters';

  @override
  String get dropPointOpenSettings => 'Open Settings';

  @override
  String dropPointOpenUntil(String time) {
    return 'Open until $time';
  }

  @override
  String get dropPointRvm => 'RVM';

  @override
  String get dropPointSearchPlaceholder => 'Ketik nama daerahmu di sini...';

  @override
  String get dropPointSortBy => 'Sort By';

  @override
  String get dropPointTitle => 'Drop Point';

  @override
  String get dropPointYourLocation => 'Lokasimu';

  @override
  String get continueWithGoogle => 'Continue with Google';

  @override
  String get dontHaveAccount => 'Don\'t have an account?';

  @override
  String get emailAddress => 'Email Address';

  @override
  String get emailInvalid => 'Invalid email format';

  @override
  String get emailLabel => 'Email';

  @override
  String get emailRequired => 'Email is required';

  @override
  String get error => 'Error';

  @override
  String get forgotPassword => 'Forgot Password?';

  @override
  String get generalErrorTitle => 'Something went wrong';

  @override
  String get homeChallenges => 'Challenges';

  @override
  String get homeChallengesDesc => 'Complete challenges and get rewards!';

  @override
  String homeChallengeProgress(int current, int total, String itemType) {
    return '$current/$total $itemType collected';
  }

  @override
  String get homeEvents => 'Events';

  @override
  String homeGreeting(String userName) {
    return 'Welcome back, $userName!';
  }

  @override
  String get homeHistory => 'History';

  @override
  String get homeImpactCarbonLabel => 'Avoided Carbon Emissions';

  @override
  String get homeImpactRecycledLabel => 'Recycled Waste';

  @override
  String get homeImpactWasteLabel => 'Waste Collected';

  @override
  String get homePoints => 'Sirsak points';

  @override
  String get homeRegisterNow => 'Register now';

  @override
  String get homeRewards => 'Rewards';

  @override
  String get homeSetorSampah => 'Setor Sampah';

  @override
  String get homeSetorSampahDesc => 'Find your nearest drop point!';

  @override
  String get homeTakeAction => 'Take Action';

  @override
  String get homeWithdraw => 'Withdraw';

  @override
  String get homeYourImpact => 'Your Impact';

  @override
  String itemCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count items',
      one: '1 item',
      zero: 'No items',
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
      '**Search** for your nearest waste collection points';

  @override
  String get landingPageFeature2 => '**Drop** your separated recyclable waste';

  @override
  String get landingPageFeature3 => '**Get points** and redeem rewards!';

  @override
  String get landingPageGetStartedButton => 'Get Started';

  @override
  String get landingPageSignInButton => 'Sign in';

  @override
  String get landingPageTitlePart1 => 'Building Indonesia\'s ';

  @override
  String get landingPageTitlePart2 => 'largest,\ntraceable';

  @override
  String get landingPageTitlePart3 => ' waste value chain network';

  @override
  String get loading => 'Loading...';

  @override
  String get loginButton => 'Login';

  @override
  String get loginTitle => 'Login';

  @override
  String get ok => 'OK';

  @override
  String get or => 'or';

  @override
  String get passwordLabel => 'Password';

  @override
  String get passwordMinLength => 'Password must be at least 6 characters';

  @override
  String get passwordRequired => 'Password is required';

  @override
  String get signIn => 'Sign In';

  @override
  String get signUp => 'Sign Up';

  @override
  String get splashTitle => 'Welcome';

  @override
  String get tutorialDesc1 =>
      'Separate your recyclable waste into the following categories: **plastic wrappers**, **PET bottles**, **paper**, and **other recyclables**.';

  @override
  String get tutorialDesc2 =>
      'Bring and dispose waste at **waste banks** and **other collection points** registered in the Sirsak community.';

  @override
  String get tutorialDesc3 =>
      'Earn points for every waste returned to collection points. Exchange with **vouchers**, **discounts**, and other **rewards**.';

  @override
  String get tutorialDesc4 =>
      'We ensure all waste sent to collection points will be **handled responsibly** to **minimize environmental impact**.';

  @override
  String get tutorialSkip => 'Skip';

  @override
  String get tutorialStartButton => 'Start Now!';

  @override
  String get tutorialTitle1 => 'Sort your waste';

  @override
  String get tutorialTitle2 => 'Dispose at nearby collection points';

  @override
  String get tutorialTitle3 => 'Get exclusive rewards';

  @override
  String get tutorialTitle4 => 'Join our community';

  @override
  String get walletBalance => 'Saldo Nasabah';

  @override
  String get walletBankSampahBalance => 'Saldo Bank Sampah';

  @override
  String get walletExpiry => 'Masa Berlaku';

  @override
  String get walletGetRewards => 'Get your rewards';

  @override
  String get walletHistory => 'History';

  @override
  String get walletMonthly => 'Bulan Ini';

  @override
  String get walletRewards => 'Rewards';

  @override
  String get walletRewardsDesc =>
      'Tukarkan poin dengan voucher, diskon, dan produk eksklusif.';

  @override
  String get walletSirsakPoints => 'Sirsak Points';

  @override
  String get walletTitle => 'Wallet';

  @override
  String get walletWithdraw => 'Withdraw';

  @override
  String get walletWithdrawDesc =>
      'Ubah poin menjadi uang tunai dan transfer ke e-wallet.';

  @override
  String welcomeUser(String userName) {
    return 'Welcome, $userName!';
  }
}
