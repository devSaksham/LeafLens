import 'package:flutter/painting.dart';
import 'package:google_fonts/google_fonts.dart';

/// The LeafLens type scale.
///
/// Fraunces is the expressive display serif (hero and section headlines).
/// Inter handles all functional communication (body, labels, controls).
///
/// Styles intentionally carry no color; [AppTheme] applies the scheme color
/// so the same scale reads correctly in both light and dark modes.
class AppTypography {
  AppTypography._();

  static TextStyle get headlineDisplay => GoogleFonts.fraunces(
        fontSize: 74,
        fontWeight: FontWeight.w700,
        height: 89 / 74,
        letterSpacing: -1.85,
      );

  static TextStyle get headlineLg => GoogleFonts.fraunces(
        fontSize: 52,
        fontWeight: FontWeight.w700,
        height: 62 / 52,
        letterSpacing: -1.30,
      );

  static TextStyle get headlineMd => GoogleFonts.fraunces(
        fontSize: 37,
        fontWeight: FontWeight.w600,
        height: 44 / 37,
        letterSpacing: -0.39,
      );

  static TextStyle get headlineSm => GoogleFonts.inter(
        fontSize: 26,
        fontWeight: FontWeight.w600,
        height: 31 / 26,
      );

  static TextStyle get bodyLg => GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w400,
        height: 30 / 18,
        letterSpacing: -0.09,
      );

  static TextStyle get bodyMd => GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 26 / 16,
        letterSpacing: -0.05,
      );

  static TextStyle get bodySm => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 22 / 14,
      );

  static TextStyle get labelLg => GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        height: 16 / 12,
        letterSpacing: 0.96,
      );

  static TextStyle get labelMd => GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        height: 14 / 11,
        letterSpacing: 0.88,
      );

  static TextStyle get labelSm => GoogleFonts.inter(
        fontSize: 10,
        fontWeight: FontWeight.w700,
        height: 12 / 10,
        letterSpacing: 1.0,
      );
}
