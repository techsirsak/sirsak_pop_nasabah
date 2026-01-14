import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_id.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('id'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Sirsak Pop Nasabah'**
  String get appName;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @continueWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get continueWithGoogle;

  /// No description provided for @dontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get dontHaveAccount;

  /// No description provided for @emailAddress.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get emailAddress;

  /// No description provided for @emailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Invalid email format'**
  String get emailInvalid;

  /// No description provided for @emailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get emailLabel;

  /// No description provided for @emailRequired.
  ///
  /// In en, this message translates to:
  /// **'Email is required'**
  String get emailRequired;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// No description provided for @generalErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get generalErrorTitle;

  /// No description provided for @itemCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No items} =1{1 item} other{{count} items}}'**
  String itemCount(int count);

  /// No description provided for @landingPageContactEmail.
  ///
  /// In en, this message translates to:
  /// **'hello@sirsak.com'**
  String get landingPageContactEmail;

  /// No description provided for @landingPageContactInstagram.
  ///
  /// In en, this message translates to:
  /// **'sirsak.hub'**
  String get landingPageContactInstagram;

  /// No description provided for @landingPageContactPhone.
  ///
  /// In en, this message translates to:
  /// **'+628 777 0808 578'**
  String get landingPageContactPhone;

  /// No description provided for @landingPageFeature1Desc.
  ///
  /// In en, this message translates to:
  /// **'for your nearest waste collection points'**
  String get landingPageFeature1Desc;

  /// No description provided for @landingPageFeature1Title.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get landingPageFeature1Title;

  /// No description provided for @landingPageFeature2Desc.
  ///
  /// In en, this message translates to:
  /// **'your separated recyclable waste'**
  String get landingPageFeature2Desc;

  /// No description provided for @landingPageFeature2Title.
  ///
  /// In en, this message translates to:
  /// **'Drop'**
  String get landingPageFeature2Title;

  /// No description provided for @landingPageFeature3Desc.
  ///
  /// In en, this message translates to:
  /// **'and redeem rewards!'**
  String get landingPageFeature3Desc;

  /// No description provided for @landingPageFeature3Title.
  ///
  /// In en, this message translates to:
  /// **'Get points'**
  String get landingPageFeature3Title;

  /// No description provided for @landingPageGetStartedButton.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get landingPageGetStartedButton;

  /// No description provided for @landingPageSignInButton.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get landingPageSignInButton;

  /// No description provided for @landingPageTitlePart1.
  ///
  /// In en, this message translates to:
  /// **'Building Indonesia\'s '**
  String get landingPageTitlePart1;

  /// No description provided for @landingPageTitlePart2.
  ///
  /// In en, this message translates to:
  /// **'largest,\ntraceable'**
  String get landingPageTitlePart2;

  /// No description provided for @landingPageTitlePart3.
  ///
  /// In en, this message translates to:
  /// **' waste value chain network'**
  String get landingPageTitlePart3;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @loginButton.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get loginButton;

  /// No description provided for @loginTitle.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get loginTitle;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @or.
  ///
  /// In en, this message translates to:
  /// **'or'**
  String get or;

  /// No description provided for @passwordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordLabel;

  /// No description provided for @passwordMinLength.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get passwordMinLength;

  /// No description provided for @passwordRequired.
  ///
  /// In en, this message translates to:
  /// **'Password is required'**
  String get passwordRequired;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// No description provided for @splashTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get splashTitle;

  /// No description provided for @tutorialDesc1.
  ///
  /// In en, this message translates to:
  /// **'Find the nearest waste collection points around you'**
  String get tutorialDesc1;

  /// No description provided for @tutorialDesc2.
  ///
  /// In en, this message translates to:
  /// **'Bring your separated recyclable waste to the collection points'**
  String get tutorialDesc2;

  /// No description provided for @tutorialDesc3.
  ///
  /// In en, this message translates to:
  /// **'Get rewarded with points for every waste you drop'**
  String get tutorialDesc3;

  /// No description provided for @tutorialDesc4.
  ///
  /// In en, this message translates to:
  /// **'Use your points to redeem exciting rewards and prizes'**
  String get tutorialDesc4;

  /// No description provided for @tutorialSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get tutorialSkip;

  /// No description provided for @tutorialStartButton.
  ///
  /// In en, this message translates to:
  /// **'Start Now!'**
  String get tutorialStartButton;

  /// No description provided for @tutorialTitle1.
  ///
  /// In en, this message translates to:
  /// **'Search for Collection Points'**
  String get tutorialTitle1;

  /// No description provided for @tutorialTitle2.
  ///
  /// In en, this message translates to:
  /// **'Drop Your Waste'**
  String get tutorialTitle2;

  /// No description provided for @tutorialTitle3.
  ///
  /// In en, this message translates to:
  /// **'Earn Points'**
  String get tutorialTitle3;

  /// No description provided for @tutorialTitle4.
  ///
  /// In en, this message translates to:
  /// **'Redeem Rewards'**
  String get tutorialTitle4;

  /// No description provided for @welcomeUser.
  ///
  /// In en, this message translates to:
  /// **'Welcome, {userName}!'**
  String welcomeUser(String userName);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'id'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'id':
      return AppLocalizationsId();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
