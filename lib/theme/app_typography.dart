import 'package:flutter/painting.dart';
import 'package:google_fonts/google_fonts.dart';

/// The Inter type scale. Hierarchy comes from weight and size, never color.
class AppTypography {
  AppTypography._();

  static const FontWeight _regular = FontWeight.w400;
  static const FontWeight _medium = FontWeight.w500;
  static const FontWeight _semibold = FontWeight.w600;

  static TextStyle get headlineDisplay => GoogleFonts.inter(
        fontSize: 48, fontWeight: _medium, height: 52 / 48, letterSpacing: -1.0);

  static TextStyle get headlineLg => GoogleFonts.inter(
        fontSize: 32, fontWeight: _medium, height: 36 / 32, letterSpacing: -0.6);

  static TextStyle get headlineMd => GoogleFonts.inter(
        fontSize: 24, fontWeight: _semibold, height: 30 / 24, letterSpacing: -0.4);

  static TextStyle get headlineSm => GoogleFonts.inter(
        fontSize: 20, fontWeight: _semibold, height: 26.6 / 20);

  static TextStyle get bodyLg => GoogleFonts.inter(
        fontSize: 16, fontWeight: _regular, height: 24 / 16);

  static TextStyle get bodyMd => GoogleFonts.inter(
        fontSize: 15, fontWeight: _regular, height: 24 / 15);

  static TextStyle get bodySm => GoogleFonts.inter(
        fontSize: 13, fontWeight: _regular, height: 19.5 / 13);

  static TextStyle get labelLg => GoogleFonts.inter(
        fontSize: 13, fontWeight: _medium, height: 19.5 / 13);

  static TextStyle get labelMd => GoogleFonts.inter(
        fontSize: 13, fontWeight: _regular, height: 19.5 / 13);

  static TextStyle get labelSm => GoogleFonts.inter(
        fontSize: 12, fontWeight: _regular, height: 18 / 12);
}
