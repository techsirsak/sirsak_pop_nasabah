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

  /// No description provided for @authGuardLoginButton.
  ///
  /// In en, this message translates to:
  /// **'Log In'**
  String get authGuardLoginButton;

  /// No description provided for @authGuardLoginMessage.
  ///
  /// In en, this message translates to:
  /// **'Please log in to access this feature'**
  String get authGuardLoginMessage;

  /// No description provided for @authGuardLoginRequired.
  ///
  /// In en, this message translates to:
  /// **'Login Required'**
  String get authGuardLoginRequired;

  /// No description provided for @authGuardRegisterButton.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get authGuardRegisterButton;

  /// No description provided for @appVersion.
  ///
  /// In en, this message translates to:
  /// **'Version {version}'**
  String appVersion(String version);

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @changePasswordButton.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePasswordButton;

  /// No description provided for @changePasswordConfirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm New Password'**
  String get changePasswordConfirmPassword;

  /// No description provided for @changePasswordNewPassword.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get changePasswordNewPassword;

  /// No description provided for @changePasswordSuccess.
  ///
  /// In en, this message translates to:
  /// **'Password changed successfully'**
  String get changePasswordSuccess;

  /// No description provided for @changePasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePasswordTitle;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @continueWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get continueWithGoogle;

  /// No description provided for @deleteAccountConfirmButton.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get deleteAccountConfirmButton;

  /// No description provided for @deleteAccountConfirmationMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete your account? This action cannot be undone.'**
  String get deleteAccountConfirmationMessage;

  /// No description provided for @deleteAccountConfirmationTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Account?'**
  String get deleteAccountConfirmationTitle;

  /// No description provided for @deleteAccountSuccess.
  ///
  /// In en, this message translates to:
  /// **'Account deletion requested successfully'**
  String get deleteAccountSuccess;

  /// No description provided for @dontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get dontHaveAccount;

  /// No description provided for @dropPointBankSampah.
  ///
  /// In en, this message translates to:
  /// **'Bank Sampah'**
  String get dropPointBankSampah;

  /// No description provided for @dropPointDetailAcceptedWaste.
  ///
  /// In en, this message translates to:
  /// **'Accepted Waste Types'**
  String get dropPointDetailAcceptedWaste;

  /// No description provided for @dropPointDetailGetDirections.
  ///
  /// In en, this message translates to:
  /// **'Get Directions'**
  String get dropPointDetailGetDirections;

  /// No description provided for @dropPointDetailMapUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Map location not available'**
  String get dropPointDetailMapUnavailable;

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

  /// No description provided for @dropPointNextWeighing.
  ///
  /// In en, this message translates to:
  /// **'Next Weighing: {date}'**
  String dropPointNextWeighing(String date);

  /// No description provided for @dropPointLocationFound.
  ///
  /// In en, this message translates to:
  /// **'Location found'**
  String get dropPointLocationFound;

  /// No description provided for @dropPointLocationPermissionMessage.
  ///
  /// In en, this message translates to:
  /// **'Enable location to see your position'**
  String get dropPointLocationPermissionMessage;

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

  /// No description provided for @dropPointOpenSettings.
  ///
  /// In en, this message translates to:
  /// **'Open Settings'**
  String get dropPointOpenSettings;

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

  /// No description provided for @editProfileSaveButton.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get editProfileSaveButton;

  /// No description provided for @editProfileSaveSuccess.
  ///
  /// In en, this message translates to:
  /// **'Profile updated successfully'**
  String get editProfileSaveSuccess;

  /// No description provided for @editProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfileTitle;

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

  /// No description provided for @errorInvalidCredentials.
  ///
  /// In en, this message translates to:
  /// **'Invalid email or password. Please try again.'**
  String get errorInvalidCredentials;

  /// No description provided for @errorLoginFailed.
  ///
  /// In en, this message translates to:
  /// **'Login failed. Please try again.'**
  String get errorLoginFailed;

  /// No description provided for @errorNetworkConnection.
  ///
  /// In en, this message translates to:
  /// **'Network error. Please check your connection.'**
  String get errorNetworkConnection;

  /// No description provided for @errorServerError.
  ///
  /// In en, this message translates to:
  /// **'Server error. Please try again later.'**
  String get errorServerError;

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

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// No description provided for @guestProfileLoginButton.
  ///
  /// In en, this message translates to:
  /// **'Log In'**
  String get guestProfileLoginButton;

  /// No description provided for @guestProfileMessage.
  ///
  /// In en, this message translates to:
  /// **'Sign in to access your profile, track your recycling impact, and earn rewards'**
  String get guestProfileMessage;

  /// No description provided for @guestProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Sirsak'**
  String get guestProfileTitle;

  /// No description provided for @homeChallengeProgress.
  ///
  /// In en, this message translates to:
  /// **'{current}/{total} {itemType} collected'**
  String homeChallengeProgress(int current, int total, String itemType);

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

  /// No description provided for @landingPageRegisterWithQrButton.
  ///
  /// In en, this message translates to:
  /// **'Register with QR'**
  String get landingPageRegisterWithQrButton;

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

  /// No description provided for @openEmailAppFailure.
  ///
  /// In en, this message translates to:
  /// **'Unable to open email app'**
  String get openEmailAppFailure;

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

  /// No description provided for @profileAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'Akun'**
  String get profileAccountTitle;

  /// No description provided for @profileBadgesTitle.
  ///
  /// In en, this message translates to:
  /// **'Your Badges'**
  String get profileBadgesTitle;

  /// No description provided for @profileCarbonAvoided.
  ///
  /// In en, this message translates to:
  /// **'Emisi Karbon\nTerhindari'**
  String get profileCarbonAvoided;

  /// No description provided for @profileChangePassword.
  ///
  /// In en, this message translates to:
  /// **'Ubah Kata Sandi'**
  String get profileChangePassword;

  /// No description provided for @profileChangePasswordDesc.
  ///
  /// In en, this message translates to:
  /// **'Ubah kata sandi akun anda'**
  String get profileChangePasswordDesc;

  /// No description provided for @profileContactEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get profileContactEmail;

  /// No description provided for @profileContactInstagram.
  ///
  /// In en, this message translates to:
  /// **'Instagram'**
  String get profileContactInstagram;

  /// No description provided for @profileContactPhone.
  ///
  /// In en, this message translates to:
  /// **'Telpon (Whatsapp chat):'**
  String get profileContactPhone;

  /// No description provided for @profileContactUs.
  ///
  /// In en, this message translates to:
  /// **'Hubungi Kami:'**
  String get profileContactUs;

  /// No description provided for @profileDeleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Hapus Akun'**
  String get profileDeleteAccount;

  /// No description provided for @profileDeleteAccountDesc.
  ///
  /// In en, this message translates to:
  /// **'Hapus akun anda secara permanen'**
  String get profileDeleteAccountDesc;

  /// No description provided for @profileEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get profileEdit;

  /// No description provided for @profileEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get profileEmailLabel;

  /// No description provided for @profileFaqLinkPre.
  ///
  /// In en, this message translates to:
  /// **'Lihat halaman FAQ '**
  String get profileFaqLinkPre;

  /// No description provided for @profileFaqLinkText.
  ///
  /// In en, this message translates to:
  /// **'di sini'**
  String get profileFaqLinkText;

  /// No description provided for @profileFaqQuestion.
  ///
  /// In en, this message translates to:
  /// **'Punya pertanyaan?'**
  String get profileFaqQuestion;

  /// No description provided for @profileFaqTitle.
  ///
  /// In en, this message translates to:
  /// **'FAQ'**
  String get profileFaqTitle;

  /// No description provided for @profileLogout.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get profileLogout;

  /// No description provided for @profileMemberSince.
  ///
  /// In en, this message translates to:
  /// **'Member sejak {year}'**
  String profileMemberSince(String year);

  /// No description provided for @profileNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Nama'**
  String get profileNameLabel;

  /// No description provided for @profilePersonalInfo.
  ///
  /// In en, this message translates to:
  /// **'Informasi Pribadi'**
  String get profilePersonalInfo;

  /// No description provided for @profilePhoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Nomor Telpon'**
  String get profilePhoneLabel;

  /// No description provided for @profileWasteCollected.
  ///
  /// In en, this message translates to:
  /// **'Sampah\nTerkumpul'**
  String get profileWasteCollected;

  /// No description provided for @profileWasteRecycled.
  ///
  /// In en, this message translates to:
  /// **'Sampah\nTerdaur Ulang'**
  String get profileWasteRecycled;

  /// No description provided for @qrScanCameraPermission.
  ///
  /// In en, this message translates to:
  /// **'Camera permission is required to scan QR codes'**
  String get qrScanCameraPermission;

  /// No description provided for @qrScanDecryptionFailed.
  ///
  /// In en, this message translates to:
  /// **'Unable to read QR code. Please try again.'**
  String get qrScanDecryptionFailed;

  /// No description provided for @qrScanInstruction.
  ///
  /// In en, this message translates to:
  /// **'Point your camera at the QR code'**
  String get qrScanInstruction;

  /// No description provided for @qrScanInvalidCode.
  ///
  /// In en, this message translates to:
  /// **'This QR code is not valid or has been tampered with'**
  String get qrScanInvalidCode;

  /// No description provided for @qrScanOpenSettings.
  ///
  /// In en, this message translates to:
  /// **'Open Settings'**
  String get qrScanOpenSettings;

  /// No description provided for @qrScanPermissionDeniedForever.
  ///
  /// In en, this message translates to:
  /// **'Camera permission was permanently denied. Please enable it in settings.'**
  String get qrScanPermissionDeniedForever;

  /// No description provided for @qrScanTitle.
  ///
  /// In en, this message translates to:
  /// **'Scan QR Code'**
  String get qrScanTitle;

  /// No description provided for @setorQrScanErrorApi.
  ///
  /// In en, this message translates to:
  /// **'Failed to start deposit session. Please try again.'**
  String get setorQrScanErrorApi;

  /// No description provided for @setorQrScanErrorInvalidQr.
  ///
  /// In en, this message translates to:
  /// **'This QR code is not valid for waste deposit'**
  String get setorQrScanErrorInvalidQr;

  /// No description provided for @setorQrScanInstruction.
  ///
  /// In en, this message translates to:
  /// **'Scan QR code at the RVM machine'**
  String get setorQrScanInstruction;

  /// No description provided for @setorQrScanRetry.
  ///
  /// In en, this message translates to:
  /// **'Scan Again'**
  String get setorQrScanRetry;

  /// No description provided for @setorQrScanSubmitting.
  ///
  /// In en, this message translates to:
  /// **'Starting deposit session...'**
  String get setorQrScanSubmitting;

  /// No description provided for @setorQrScanSuccess.
  ///
  /// In en, this message translates to:
  /// **'Scan Successful!'**
  String get setorQrScanSuccess;

  /// No description provided for @setorQrScanSuccessMessage.
  ///
  /// In en, this message translates to:
  /// **'Points have been updated.'**
  String get setorQrScanSuccessMessage;

  /// No description provided for @setorQrScanTitle.
  ///
  /// In en, this message translates to:
  /// **'Setor Sampah'**
  String get setorQrScanTitle;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

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

  /// No description provided for @signupAlreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get signupAlreadyHaveAccount;

  /// No description provided for @signupConfirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get signupConfirmPassword;

  /// No description provided for @signupConfirmPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Please confirm your password'**
  String get signupConfirmPasswordRequired;

  /// No description provided for @signupFullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get signupFullName;

  /// No description provided for @signupFullNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Full name is required'**
  String get signupFullNameRequired;

  /// No description provided for @signupFullNameTooShort.
  ///
  /// In en, this message translates to:
  /// **'Full name must be at least 2 characters'**
  String get signupFullNameTooShort;

  /// No description provided for @signupOptional.
  ///
  /// In en, this message translates to:
  /// **'optional'**
  String get signupOptional;

  /// No description provided for @signupPasswordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get signupPasswordsDoNotMatch;

  /// No description provided for @signupPhoneHint.
  ///
  /// In en, this message translates to:
  /// **'+62 812 3456 7890'**
  String get signupPhoneHint;

  /// No description provided for @signupPhoneInvalid.
  ///
  /// In en, this message translates to:
  /// **'Invalid phone number format'**
  String get signupPhoneInvalid;

  /// No description provided for @signupPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get signupPhoneNumber;

  /// No description provided for @signupPrivacyPolicyLink.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get signupPrivacyPolicyLink;

  /// No description provided for @signupRegisteringAt.
  ///
  /// In en, this message translates to:
  /// **'Registering at'**
  String get signupRegisteringAt;

  /// No description provided for @signupTermsAnd.
  ///
  /// In en, this message translates to:
  /// **' and '**
  String get signupTermsAnd;

  /// No description provided for @signupTermsLink.
  ///
  /// In en, this message translates to:
  /// **'Terms and Conditions'**
  String get signupTermsLink;

  /// No description provided for @signupTermsPrefix.
  ///
  /// In en, this message translates to:
  /// **'I agree to the '**
  String get signupTermsPrefix;

  /// No description provided for @signupTermsRequired.
  ///
  /// In en, this message translates to:
  /// **'You must accept the terms and conditions and privacy policy'**
  String get signupTermsRequired;

  /// No description provided for @splashTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get splashTitle;

  /// No description provided for @transactionDetailBarang.
  ///
  /// In en, this message translates to:
  /// **'Item'**
  String get transactionDetailBarang;

  /// No description provided for @transactionDetailHarga.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get transactionDetailHarga;

  /// No description provided for @transactionDetailItems.
  ///
  /// In en, this message translates to:
  /// **'Transaction Items'**
  String get transactionDetailItems;

  /// No description provided for @transactionDetailJumlah.
  ///
  /// In en, this message translates to:
  /// **'Qty'**
  String get transactionDetailJumlah;

  /// No description provided for @transactionDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'Transaction Detail'**
  String get transactionDetailTitle;

  /// No description provided for @transactionDetailTotal.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get transactionDetailTotal;

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

  /// No description provided for @verifyEmailDescription.
  ///
  /// In en, this message translates to:
  /// **'We\'ve sent a verification link to your email address. Please check your inbox and click the link to verify your account.'**
  String get verifyEmailDescription;

  /// No description provided for @verifyEmailGoToLogin.
  ///
  /// In en, this message translates to:
  /// **'Go to Login'**
  String get verifyEmailGoToLogin;

  /// No description provided for @verifyEmailOpenEmail.
  ///
  /// In en, this message translates to:
  /// **'Open Email App'**
  String get verifyEmailOpenEmail;

  /// No description provided for @verifyEmailTitle.
  ///
  /// In en, this message translates to:
  /// **'Check Your Email'**
  String get verifyEmailTitle;

  /// No description provided for @walletBalance.
  ///
  /// In en, this message translates to:
  /// **'Saldo Nasabah'**
  String get walletBalance;

  /// No description provided for @walletBalanceInfoBankSampahDesc.
  ///
  /// In en, this message translates to:
  /// **'Get cash by collecting waste at waste banks. Waste bank balance must also be withdrawn at the waste bank.'**
  String get walletBalanceInfoBankSampahDesc;

  /// No description provided for @walletBalanceInfoSirsakPointsDesc.
  ///
  /// In en, this message translates to:
  /// **'Get Sirsak Points by disposing waste at SirCle (RVM) and Wartabak collection points.'**
  String get walletBalanceInfoSirsakPointsDesc;

  /// No description provided for @walletBankSampahBalance.
  ///
  /// In en, this message translates to:
  /// **'Saldo Bank Sampah'**
  String get walletBankSampahBalance;

  /// No description provided for @walletExpiry.
  ///
  /// In en, this message translates to:
  /// **'Masa Berlaku'**
  String get walletExpiry;

  /// No description provided for @walletGetRewards.
  ///
  /// In en, this message translates to:
  /// **'Get your rewards'**
  String get walletGetRewards;

  /// No description provided for @walletHistory.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get walletHistory;

  /// No description provided for @walletMonthly.
  ///
  /// In en, this message translates to:
  /// **'Bulan Ini'**
  String get walletMonthly;

  /// No description provided for @walletRewards.
  ///
  /// In en, this message translates to:
  /// **'Rewards'**
  String get walletRewards;

  /// No description provided for @walletRewardsDesc.
  ///
  /// In en, this message translates to:
  /// **'Tukarkan poin dengan voucher, diskon, dan produk eksklusif.'**
  String get walletRewardsDesc;

  /// No description provided for @walletSirsakPoints.
  ///
  /// In en, this message translates to:
  /// **'Sirsak Points'**
  String get walletSirsakPoints;

  /// No description provided for @walletTitle.
  ///
  /// In en, this message translates to:
  /// **'Wallet'**
  String get walletTitle;

  /// No description provided for @walletWithdraw.
  ///
  /// In en, this message translates to:
  /// **'Withdraw'**
  String get walletWithdraw;

  /// No description provided for @walletWithdrawDesc.
  ///
  /// In en, this message translates to:
  /// **'Ubah poin menjadi uang tunai dan transfer ke e-wallet.'**
  String get walletWithdrawDesc;

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
