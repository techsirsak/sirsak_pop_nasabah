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
  String get landingPageFeature1Desc =>
      'for your nearest waste collection points';

  @override
  String get landingPageFeature1Title => 'Search';

  @override
  String get landingPageFeature2Desc => 'your separated recyclable waste';

  @override
  String get landingPageFeature2Title => 'Drop';

  @override
  String get landingPageFeature3Desc => 'and redeem rewards!';

  @override
  String get landingPageFeature3Title => 'Get points';

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
  String welcomeUser(String userName) {
    return 'Welcome, $userName!';
  }
}
