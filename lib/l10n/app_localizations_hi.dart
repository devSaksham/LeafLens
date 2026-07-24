// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get welcomeHeadline =>
      'अपने पौधों को स्वस्थ करें,\nएक पत्ती से शुरुआत।';

  @override
  String get welcomeTagline =>
      'एक पत्ती की फोटो लें और सेकंडों में रोग पहचानें।';

  @override
  String get continueWithGoogle => 'गूगल से जारी रखें';

  @override
  String get continueAsGuest => 'अतिथि के रूप में जारी रखें';

  @override
  String get signingIn => 'साइन इन हो रहा है…';

  @override
  String get googleSignInFailed => 'गूगल साइन-इन विफल रहा। पुनः प्रयास करें।';

  @override
  String get selectLanguage => 'भाषा चुनें';

  @override
  String get homeCardTitle => 'अपने पौधे का स्वास्थ्य जाँचें';

  @override
  String get homeCardBody =>
      'रोग पहचानने और सलाह पाने के लिए पौधे की फोटो लें या चुनें।';

  @override
  String get scanLeaf => 'पत्ती स्कैन करें';

  @override
  String get detectTitle => 'पहचान';

  @override
  String get detectSubtitle =>
      'बेहतर परिणाम के लिए अच्छी रोशनी में एक ही पत्ती पर कैमरा रखें।';

  @override
  String get camera => 'कैमरा';

  @override
  String get gallery => 'गैलरी';

  @override
  String get analyzeError => 'इस छवि का विश्लेषण नहीं हो सका।';

  @override
  String get noPlantDetected => 'कोई पौधा नहीं मिला';

  @override
  String get noPlantBody => 'एक पत्ती की स्पष्ट फोटो के साथ पुनः प्रयास करें।';

  @override
  String get healthyMessage => 'यह पौधा स्वस्थ दिख रहा है।';

  @override
  String get diseaseMessage =>
      'एक रोग पाया गया। उपचार सुझावों के लिए सहायक से पूछें।';

  @override
  String get healthyChip => 'स्वस्थ';

  @override
  String get diseaseChip => 'रोग';

  @override
  String confidence(String value) {
    return 'विश्वास $value';
  }

  @override
  String get askAssistant => 'सहायक से पूछें';

  @override
  String get assistantTitle => 'सहायक';

  @override
  String get assistantGreeting =>
      'नमस्ते! मैं LeafLens सहायक हूँ। पौधों की देखभाल के बारे में कुछ भी पूछें।';

  @override
  String assistantGreetingDisease(String disease) {
    return 'मैं $disease में मदद कर सकता हूँ। लक्षण, कारण या उपचार के बारे में पूछें।';
  }

  @override
  String get askQuestion => 'कोई प्रश्न पूछें';

  @override
  String get assistantError =>
      'क्षमा करें, सहायक से संपर्क नहीं हो सका। कृपया पुनः प्रयास करें।';

  @override
  String get getStarted => 'शुरू करें';

  @override
  String get recentScans => 'हाल के स्कैन';

  @override
  String get noScansYet => 'आपके स्कैन यहाँ दिखेंगे।';

  @override
  String get viewTreatment => 'उपचार देखें';

  @override
  String get treatmentTitle => 'उपचार';

  @override
  String get labelCause => 'कारण';

  @override
  String get labelSeverity => 'गंभीरता';

  @override
  String get doNow => 'अभी करें';

  @override
  String get organicLabel => 'जैविक';

  @override
  String get chemicalLabel => 'रासायनिक';

  @override
  String get preventLabel => 'रोकथाम';

  @override
  String get regionalNote => 'क्षेत्रीय सुझाव';

  @override
  String get loadingRegionalNote => 'आपके क्षेत्र के लिए सलाह ली जा रही है…';

  @override
  String get noTreatment => 'अभी उपचार जानकारी उपलब्ध नहीं है।';
}
