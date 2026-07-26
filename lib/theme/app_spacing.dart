import 'package:flutter/widgets.dart';

/// Spacing scale on a 4px base unit. Use only these steps.
class AppSpacing {
  AppSpacing._();

  static const double xs = 8;
  static const double sm = 12;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 40;

  /// Standard horizontal page gutter.
  static const double gutter = 20;
}

/// Corner radius scale and ready-made [BorderRadius] helpers.
class AppRadius {
  AppRadius._();

  static const double none = 0;
  static const double sm = 4;
  static const double md = 6;
  static const double lg = 8;

  /// Pill / fully rounded.
  static const double xl = 9999;
  static const double full = 9999;

  static const BorderRadius smRadius = BorderRadius.all(Radius.circular(sm));
  static const BorderRadius mdRadius = BorderRadius.all(Radius.circular(md));
  static const BorderRadius lgRadius = BorderRadius.all(Radius.circular(lg));
  static const BorderRadius fullRadius = BorderRadius.all(Radius.circular(full));
}
