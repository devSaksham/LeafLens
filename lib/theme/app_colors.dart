import 'package:flutter/painting.dart';

/// The single source of truth for every color in LeafLens.
///
/// This is the ONLY file permitted to contain raw `Color(0x...)` literals.
/// Feature code must reference these tokens (or `Theme.of(context).colorScheme`)
/// and must never inline a hex color or use `Colors.*`.
class AppColors {
  AppColors._();

  // ---------------------------------------------------------------------------
  // Light palette
  // ---------------------------------------------------------------------------

  /// Deep forest-ink. Headlines, navigation, borders, key contrast.
  static const Color primary = Color(0xFF1D2B1F);

  /// Muted sage-gray. Supportive text and softer UI moments.
  static const Color secondary = Color(0xFF6D7B6F);

  /// Lively lime. Primary calls to action and highlights.
  static const Color tertiary = Color(0xFFBFEA4B);

  /// Warm cream. Default page background.
  static const Color neutral = Color(0xFFF7F0E6);

  /// Off-white. Elevated cards and content areas.
  static const Color surface = Color(0xFFFFFDF8);

  /// Default readable text color on light backgrounds.
  static const Color onSurface = Color(0xFF1D2B1F);

  /// Restrained alert red. Validation and destructive states.
  static const Color error = Color(0xFFC84D4D);

  /// Lifted primary tone. Hover and nuanced borders/text.
  static const Color primary60 = Color(0xFF4E5B50);

  /// Deepened primary tone. Pressed and heavier contrast.
  static const Color primary80 = Color(0xFF2D3A30);

  /// Signature highlight. Mirrors [tertiary]; use sparingly.
  static const Color accent = Color(0xFFBFEA4B);

  // ---------------------------------------------------------------------------
  // Dark palette (derived from the same forest / cream / lime language)
  // ---------------------------------------------------------------------------

  /// Near-black green. Default dark background.
  static const Color darkBackground = Color(0xFF12180F);

  /// Forest ink. Default dark surface.
  static const Color darkSurface = Color(0xFF1D2B1F);

  /// Lifted forest. Elevated dark cards and content areas.
  static const Color darkSurfaceElevated = Color(0xFF2D3A30);

  /// Muted dark card fill, analogue of [neutral] for dark mode.
  static const Color darkNeutral = Color(0xFF232E24);

  /// Cream. Default readable text color on dark backgrounds.
  static const Color onDark = Color(0xFFF7F0E6);

  /// Lightened sage. Supportive text on dark backgrounds.
  static const Color darkSecondary = Color(0xFF9CAA92);

  /// Lightened alert red for dark backgrounds.
  static const Color darkError = Color(0xFFE06A6A);
}
