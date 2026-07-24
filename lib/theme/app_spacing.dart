import 'package:flutter/widgets.dart';

/// Spacing scale. Use these steps for padding, margins, and gaps so the
/// layout keeps a consistent airy rhythm.
class AppSpacing {
  AppSpacing._();

  static const double xs = 6;
  static const double sm = 14;
  static const double md = 24;
  static const double lg = 38;
  static const double xl = 80;

  /// Standard horizontal page gutter.
  static const double gutter = 24;
}

/// Corner radius scale and ready-made [BorderRadius] helpers.
class AppRadius {
  AppRadius._();

  static const double none = 0;
  static const double sm = 4;
  static const double md = 8;
  static const double lg = 12;

  /// Pill / fully rounded.
  static const double xl = 9999;
  static const double full = 9999;

  static const BorderRadius smRadius = BorderRadius.all(Radius.circular(sm));
  static const BorderRadius mdRadius = BorderRadius.all(Radius.circular(md));
  static const BorderRadius lgRadius = BorderRadius.all(Radius.circular(lg));
  static const BorderRadius fullRadius = BorderRadius.all(Radius.circular(full));
}
