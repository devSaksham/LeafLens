import 'package:flutter/widgets.dart';

class LocaleController {
  LocaleController._();

  static final ValueNotifier<Locale> locale = ValueNotifier(const Locale('en'));

  static const List<Locale> supported = [Locale('en'), Locale('hi')];

  static void setLocale(Locale value) => locale.value = value;
}
