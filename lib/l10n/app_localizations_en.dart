// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get welcomeHeadline => 'Heal your plants,\none leaf at a time.';

  @override
  String get welcomeTagline => 'Snap a leaf and spot disease in seconds.';

  @override
  String get continueWithGoogle => 'CONTINUE WITH GOOGLE';

  @override
  String get continueAsGuest => 'CONTINUE AS GUEST';

  @override
  String get signingIn => 'SIGNING IN…';

  @override
  String get googleSignInFailed => 'Google sign-in failed. Try again.';

  @override
  String get selectLanguage => 'Select language';

  @override
  String get homeCardTitle => 'Check your plant\'s health';

  @override
  String get homeCardBody =>
      'Take or select a photo of a plant to detect the disease and get guidance.';

  @override
  String get scanLeaf => 'Scan a leaf';

  @override
  String get detectTitle => 'Detect';

  @override
  String get detectSubtitle =>
      'Point at a single leaf in good light for the best result.';

  @override
  String get camera => 'CAMERA';

  @override
  String get gallery => 'GALLERY';

  @override
  String get analyzeError => 'Could not analyze this image.';

  @override
  String get noPlantDetected => 'No plant detected';

  @override
  String get noPlantBody => 'Try again with a clearer photo of a single leaf.';

  @override
  String get healthyMessage => 'This plant looks healthy.';

  @override
  String get diseaseMessage =>
      'A disease was detected. Ask the assistant for treatment tips.';

  @override
  String get healthyChip => 'HEALTHY';

  @override
  String get diseaseChip => 'DISEASE';

  @override
  String confidence(String value) {
    return 'Confidence $value';
  }

  @override
  String get askAssistant => 'ASK ASSISTANT';

  @override
  String get assistantTitle => 'Assistant';

  @override
  String get assistantGreeting =>
      'Hi! I\'m the LeafLens assistant. Ask me anything about plant care.';

  @override
  String assistantGreetingDisease(String disease) {
    return 'I can help with $disease. Ask about symptoms, causes, or treatment.';
  }

  @override
  String get askQuestion => 'Ask a question';

  @override
  String get assistantError =>
      'Sorry, I could not reach the assistant. Please try again.';

  @override
  String get getStarted => 'GET STARTED';

  @override
  String get recentScans => 'Recent scans';

  @override
  String get noScansYet => 'Your scans will appear here.';

  @override
  String get viewTreatment => 'VIEW TREATMENT';

  @override
  String get treatmentTitle => 'Treatment';

  @override
  String get labelCause => 'Cause';

  @override
  String get labelSeverity => 'Severity';

  @override
  String get doNow => 'Do now';

  @override
  String get organicLabel => 'Organic';

  @override
  String get chemicalLabel => 'Chemical';

  @override
  String get preventLabel => 'Prevent';

  @override
  String get regionalNote => 'Regional note';

  @override
  String get loadingRegionalNote => 'Getting advice for your area…';

  @override
  String get noTreatment => 'No treatment information available yet.';
}
