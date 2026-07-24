import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_hi.dart';

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
    Locale('hi'),
  ];

  /// No description provided for @welcomeHeadline.
  ///
  /// In en, this message translates to:
  /// **'Heal your plants,\none leaf at a time.'**
  String get welcomeHeadline;

  /// No description provided for @welcomeTagline.
  ///
  /// In en, this message translates to:
  /// **'Snap a leaf and spot disease in seconds.'**
  String get welcomeTagline;

  /// No description provided for @continueWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'CONTINUE WITH GOOGLE'**
  String get continueWithGoogle;

  /// No description provided for @continueAsGuest.
  ///
  /// In en, this message translates to:
  /// **'CONTINUE AS GUEST'**
  String get continueAsGuest;

  /// No description provided for @signingIn.
  ///
  /// In en, this message translates to:
  /// **'SIGNING IN…'**
  String get signingIn;

  /// No description provided for @googleSignInFailed.
  ///
  /// In en, this message translates to:
  /// **'Google sign-in failed. Try again.'**
  String get googleSignInFailed;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select language'**
  String get selectLanguage;

  /// No description provided for @homeCardTitle.
  ///
  /// In en, this message translates to:
  /// **'Check your plant\'s health'**
  String get homeCardTitle;

  /// No description provided for @homeCardBody.
  ///
  /// In en, this message translates to:
  /// **'Take or select a photo of a plant to detect the disease and get guidance.'**
  String get homeCardBody;

  /// No description provided for @scanLeaf.
  ///
  /// In en, this message translates to:
  /// **'Scan a leaf'**
  String get scanLeaf;

  /// No description provided for @detectTitle.
  ///
  /// In en, this message translates to:
  /// **'Detect'**
  String get detectTitle;

  /// No description provided for @detectSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Point at a single leaf in good light for the best result.'**
  String get detectSubtitle;

  /// No description provided for @camera.
  ///
  /// In en, this message translates to:
  /// **'CAMERA'**
  String get camera;

  /// No description provided for @gallery.
  ///
  /// In en, this message translates to:
  /// **'GALLERY'**
  String get gallery;

  /// No description provided for @analyzeError.
  ///
  /// In en, this message translates to:
  /// **'Could not analyze this image.'**
  String get analyzeError;

  /// No description provided for @noPlantDetected.
  ///
  /// In en, this message translates to:
  /// **'No plant detected'**
  String get noPlantDetected;

  /// No description provided for @noPlantBody.
  ///
  /// In en, this message translates to:
  /// **'Try again with a clearer photo of a single leaf.'**
  String get noPlantBody;

  /// No description provided for @healthyMessage.
  ///
  /// In en, this message translates to:
  /// **'This plant looks healthy.'**
  String get healthyMessage;

  /// No description provided for @diseaseMessage.
  ///
  /// In en, this message translates to:
  /// **'A disease was detected. Ask the assistant for treatment tips.'**
  String get diseaseMessage;

  /// No description provided for @healthyChip.
  ///
  /// In en, this message translates to:
  /// **'HEALTHY'**
  String get healthyChip;

  /// No description provided for @diseaseChip.
  ///
  /// In en, this message translates to:
  /// **'DISEASE'**
  String get diseaseChip;

  /// No description provided for @confidence.
  ///
  /// In en, this message translates to:
  /// **'Confidence {value}'**
  String confidence(String value);

  /// No description provided for @askAssistant.
  ///
  /// In en, this message translates to:
  /// **'ASK ASSISTANT'**
  String get askAssistant;

  /// No description provided for @assistantTitle.
  ///
  /// In en, this message translates to:
  /// **'Assistant'**
  String get assistantTitle;

  /// No description provided for @assistantGreeting.
  ///
  /// In en, this message translates to:
  /// **'Hi! I\'m the LeafLens assistant. Ask me anything about plant care.'**
  String get assistantGreeting;

  /// No description provided for @assistantGreetingDisease.
  ///
  /// In en, this message translates to:
  /// **'I can help with {disease}. Ask about symptoms, causes, or treatment.'**
  String assistantGreetingDisease(String disease);

  /// No description provided for @askQuestion.
  ///
  /// In en, this message translates to:
  /// **'Ask a question'**
  String get askQuestion;

  /// No description provided for @assistantError.
  ///
  /// In en, this message translates to:
  /// **'Sorry, I could not reach the assistant. Please try again.'**
  String get assistantError;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'GET STARTED'**
  String get getStarted;

  /// No description provided for @recentScans.
  ///
  /// In en, this message translates to:
  /// **'Recent scans'**
  String get recentScans;

  /// No description provided for @noScansYet.
  ///
  /// In en, this message translates to:
  /// **'Your scans will appear here.'**
  String get noScansYet;

  /// No description provided for @viewTreatment.
  ///
  /// In en, this message translates to:
  /// **'VIEW TREATMENT'**
  String get viewTreatment;

  /// No description provided for @treatmentTitle.
  ///
  /// In en, this message translates to:
  /// **'Treatment'**
  String get treatmentTitle;

  /// No description provided for @labelCause.
  ///
  /// In en, this message translates to:
  /// **'Cause'**
  String get labelCause;

  /// No description provided for @labelSeverity.
  ///
  /// In en, this message translates to:
  /// **'Severity'**
  String get labelSeverity;

  /// No description provided for @doNow.
  ///
  /// In en, this message translates to:
  /// **'Do now'**
  String get doNow;

  /// No description provided for @organicLabel.
  ///
  /// In en, this message translates to:
  /// **'Organic'**
  String get organicLabel;

  /// No description provided for @chemicalLabel.
  ///
  /// In en, this message translates to:
  /// **'Chemical'**
  String get chemicalLabel;

  /// No description provided for @preventLabel.
  ///
  /// In en, this message translates to:
  /// **'Prevent'**
  String get preventLabel;

  /// No description provided for @regionalNote.
  ///
  /// In en, this message translates to:
  /// **'Regional note'**
  String get regionalNote;

  /// No description provided for @loadingRegionalNote.
  ///
  /// In en, this message translates to:
  /// **'Getting advice for your area…'**
  String get loadingRegionalNote;

  /// No description provided for @noTreatment.
  ///
  /// In en, this message translates to:
  /// **'No treatment information available yet.'**
  String get noTreatment;
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
      <String>['en', 'hi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'hi':
      return AppLocalizationsHi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
