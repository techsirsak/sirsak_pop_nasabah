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

  /// No description provided for @dropPointBankSampah.
  ///
  /// In en, this message translates to:
  /// **'Bank Sampah'**
  String get dropPointBankSampah;

  /// No description provided for @dropPointDistance.
  ///
  /// In en, this message translates to:
  /// **'{distance} km away'**
  String dropPointDistance(String distance);

  /// No description provided for @dropPointDropPoint.
  ///
  /// In en, this message translates to:
  /// **'Drop Point'**
  String get dropPointDropPoint;

  /// No description provided for @dropPointFilter.
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get dropPointFilter;

  /// No description provided for @dropPointLocationFound.
  ///
  /// In en, this message translates to:
  /// **'Location found'**
  String get dropPointLocationFound;

  /// No description provided for @dropPointNoResults.
  ///
  /// In en, this message translates to:
  /// **'No drop points found'**
  String get dropPointNoResults;

  /// No description provided for @dropPointNoResultsHint.
  ///
  /// In en, this message translates to:
  /// **'Try adjusting your search or filters'**
  String get dropPointNoResultsHint;

  /// No description provided for @dropPointOpenUntil.
  ///
  /// In en, this message translates to:
  /// **'Open until {time}'**
  String dropPointOpenUntil(String time);

  /// No description provided for @dropPointRvm.
  ///
  /// In en, this message translates to:
  /// **'RVM'**
  String get dropPointRvm;

  /// No description provided for @dropPointSearchPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Ketik nama daerahmu di sini...'**
  String get dropPointSearchPlaceholder;

  /// No description provided for @dropPointSortBy.
  ///
  /// In en, this message translates to:
  /// **'Sort By'**
  String get dropPointSortBy;

  /// No description provided for @dropPointTitle.
  ///
  /// In en, this message translates to:
  /// **'Drop Point'**
  String get dropPointTitle;

  /// No description provided for @dropPointYourLocation.
  ///
  /// In en, this message translates to:
  /// **'Lokasimu'**
  String get dropPointYourLocation;

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

  /// No description provided for @homeChallenges.
  ///
  /// In en, this message translates to:
  /// **'Challenges'**
  String get homeChallenges;

  /// No description provided for @homeChallengesDesc.
  ///
  /// In en, this message translates to:
  /// **'Complete challenges and get rewards!'**
  String get homeChallengesDesc;

  /// No description provided for @homeChallengeProgress.
  ///
  /// In en, this message translates to:
  /// **'{current}/{total} {itemType} collected'**
  String homeChallengeProgress(int current, int total, String itemType);

  /// No description provided for @homeEvents.
  ///
  /// In en, this message translates to:
  /// **'Events'**
  String get homeEvents;

  /// No description provided for @homeGreeting.
  ///
  /// In en, this message translates to:
  /// **'Welcome back, {userName}!'**
  String homeGreeting(String userName);

  /// No description provided for @homeHistory.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get homeHistory;

  /// No description provided for @homeImpactCarbonLabel.
  ///
  /// In en, this message translates to:
  /// **'Avoided Carbon Emissions'**
  String get homeImpactCarbonLabel;

  /// No description provided for @homeImpactRecycledLabel.
  ///
  /// In en, this message translates to:
  /// **'Recycled Waste'**
  String get homeImpactRecycledLabel;

  /// No description provided for @homeImpactWasteLabel.
  ///
  /// In en, this message translates to:
  /// **'Waste Collected'**
  String get homeImpactWasteLabel;

  /// No description provided for @homePoints.
  ///
  /// In en, this message translates to:
  /// **'Sirsak points'**
  String get homePoints;

  /// No description provided for @homeRegisterNow.
  ///
  /// In en, this message translates to:
  /// **'Register now'**
  String get homeRegisterNow;

  /// No description provided for @homeRewards.
  ///
  /// In en, this message translates to:
  /// **'Rewards'**
  String get homeRewards;

  /// No description provided for @homeSetorSampah.
  ///
  /// In en, this message translates to:
  /// **'Setor Sampah'**
  String get homeSetorSampah;

  /// No description provided for @homeSetorSampahDesc.
  ///
  /// In en, this message translates to:
  /// **'Find your nearest drop point!'**
  String get homeSetorSampahDesc;

  /// No description provided for @homeTakeAction.
  ///
  /// In en, this message translates to:
  /// **'Take Action'**
  String get homeTakeAction;

  /// No description provided for @homeWithdraw.
  ///
  /// In en, this message translates to:
  /// **'Withdraw'**
  String get homeWithdraw;

  /// No description provided for @homeYourImpact.
  ///
  /// In en, this message translates to:
  /// **'Your Impact'**
  String get homeYourImpact;

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

  /// No description provided for @landingPageFeature1.
  ///
  /// In en, this message translates to:
  /// **'**Search** for your nearest waste collection points'**
  String get landingPageFeature1;

  /// No description provided for @landingPageFeature2.
  ///
  /// In en, this message translates to:
  /// **'**Drop** your separated recyclable waste'**
  String get landingPageFeature2;

  /// No description provided for @landingPageFeature3.
  ///
  /// In en, this message translates to:
  /// **'**Get points** and redeem rewards!'**
  String get landingPageFeature3;

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
  /// **'Separate your recyclable waste into the following categories: **plastic wrappers**, **PET bottles**, **paper**, and **other recyclables**.'**
  String get tutorialDesc1;

  /// No description provided for @tutorialDesc2.
  ///
  /// In en, this message translates to:
  /// **'Bring and dispose waste at **waste banks** and **other collection points** registered in the Sirsak community.'**
  String get tutorialDesc2;

  /// No description provided for @tutorialDesc3.
  ///
  /// In en, this message translates to:
  /// **'Earn points for every waste returned to collection points. Exchange with **vouchers**, **discounts**, and other **rewards**.'**
  String get tutorialDesc3;

  /// No description provided for @tutorialDesc4.
  ///
  /// In en, this message translates to:
  /// **'We ensure all waste sent to collection points will be **handled responsibly** to **minimize environmental impact**.'**
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
  /// **'Sort your waste'**
  String get tutorialTitle1;

  /// No description provided for @tutorialTitle2.
  ///
  /// In en, this message translates to:
  /// **'Dispose at nearby collection points'**
  String get tutorialTitle2;

  /// No description provided for @tutorialTitle3.
  ///
  /// In en, this message translates to:
  /// **'Get exclusive rewards'**
  String get tutorialTitle3;

  /// No description provided for @tutorialTitle4.
  ///
  /// In en, this message translates to:
  /// **'Join our community'**
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
