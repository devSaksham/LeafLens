import 'package:flutter/painting.dart';

/// The single source of truth for every color in LeafLens.
///
/// This is the ONLY file permitted to contain raw `Color(0x...)` literals.
/// Feature code must reference these tokens (or `Theme.of(context).colorScheme`)
/// and must never inline a hex color or use `Colors.*`.
class AppColors {
  AppColors._();

  static const Color primary = Color(0xFF5E6AD2);
  static const Color secondary = Color(0xFF62666D);
  static const Color tertiary = Color(0xFF3FA45B);
  static const Color neutral = Color(0xFFF7F8F8);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color onSurface = Color(0xFF08090A);
  static const Color error = Color(0xFFD0454C);
  static const Color primary60 = Color(0xFF8A8F98);
  static const Color primary80 = Color(0xFF4A52B0);
  static const Color accent = Color(0xFF5E6AD2);
  static const Color borderLight = Color(0xFFE5E5E6);
  static const Color borderStandard = Color(0xFFD0D6E0);

  static const Color darkBackground = Color(0xFF08090A);
  static const Color darkSurface = Color(0xFF0F1011);
  static const Color darkSurfaceElevated = Color(0xFF121414);
  static const Color darkNeutral = Color(0xFF101112);
  static const Color onDark = Color(0xFFF7F8F8);
  static const Color darkSecondary = Color(0xFF8A8F98);
  static const Color darkError = Color(0xFFE5646B);
  static const Color darkBorder = Color(0x0DFFFFFF);
  static const Color darkBorderHover = Color(0x14FFFFFF);

  static const Color transparent = Color(0x00000000);
  static const Color shadowOuter = Color(0x14000000);
  static const Color shadowMid = Color(0x0A000000);
  static const Color shadowInner = Color(0x12000000);
}
