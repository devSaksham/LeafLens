import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_spacing.dart';
import 'app_typography.dart';

/// Depth is expressed through borders and opacity first. Shadows are a
/// restrained multi-layer treatment, used only where interaction needs it.
class AppShadows {
  AppShadows._();

  static const List<BoxShadow> hard = [
    BoxShadow(color: AppColors.shadowOuter, offset: Offset(0, 8), blurRadius: 2),
    BoxShadow(color: AppColors.shadowMid, offset: Offset(0, 3), blurRadius: 2),
    BoxShadow(color: AppColors.shadowInner, offset: Offset(0, 1), blurRadius: 1),
  ];
}

class AppTheme {
  AppTheme._();

  static TextTheme _textTheme(Color onSurface, Color muted) {
    return TextTheme(
      displayLarge: AppTypography.headlineDisplay.copyWith(color: onSurface),
      displayMedium: AppTypography.headlineLg.copyWith(color: onSurface),
      displaySmall: AppTypography.headlineMd.copyWith(color: onSurface),
      headlineMedium: AppTypography.headlineSm.copyWith(color: onSurface),
      bodyLarge: AppTypography.bodyLg.copyWith(color: onSurface),
      bodyMedium: AppTypography.bodyMd.copyWith(color: onSurface),
      bodySmall: AppTypography.bodySm.copyWith(color: muted),
      labelLarge: AppTypography.labelLg.copyWith(color: onSurface),
      labelMedium: AppTypography.labelMd.copyWith(color: onSurface),
      labelSmall: AppTypography.labelSm.copyWith(color: muted),
    );
  }

  static ThemeData _build({
    required Brightness brightness,
    required Color background,
    required Color surface,
    required Color card,
    required Color onSurface,
    required Color muted,
    required Color border,
    required Color error,
  }) {
    final TextTheme text = _textTheme(onSurface, muted);
    final ColorScheme scheme = ColorScheme(
      brightness: brightness,
      primary: AppColors.primary,
      onPrimary: AppColors.surface,
      secondary: muted,
      onSecondary: onSurface,
      tertiary: AppColors.tertiary,
      onTertiary: AppColors.surface,
      surface: surface,
      onSurface: onSurface,
      error: error,
      onError: AppColors.surface,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: background,
      canvasColor: background,
      cardColor: card,
      dividerColor: border,
      textTheme: text,
      appBarTheme: AppBarTheme(
        backgroundColor: background,
        surfaceTintColor: background,
        foregroundColor: onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: text.headlineMedium,
      ),
      cardTheme: CardThemeData(
        color: card,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.lgRadius,
          side: BorderSide(color: border),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.surface,
          disabledBackgroundColor: muted,
          disabledForegroundColor: surface,
          elevation: 0,
          minimumSize: const Size(0, 44),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          shape: const RoundedRectangleBorder(
              borderRadius: AppRadius.fullRadius),
          textStyle: AppTypography.labelMd,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: onSurface,
          backgroundColor: AppColors.transparent,
          minimumSize: const Size(0, 44),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
          side: BorderSide(color: border),
          shape: const RoundedRectangleBorder(
              borderRadius: AppRadius.fullRadius),
          textStyle: AppTypography.labelMd,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: muted,
          minimumSize: const Size(0, 44),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
          shape: const RoundedRectangleBorder(
              borderRadius: AppRadius.fullRadius),
          textStyle: AppTypography.labelMd,
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: card,
        side: BorderSide(color: border),
        labelStyle: AppTypography.labelMd.copyWith(color: onSurface),
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
        shape: const RoundedRectangleBorder(
            borderRadius: AppRadius.fullRadius),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: card,
        contentPadding: const EdgeInsets.symmetric(
            horizontal: 14, vertical: AppSpacing.sm),
        hintStyle: AppTypography.labelMd.copyWith(color: muted),
        border: OutlineInputBorder(
          borderRadius: AppRadius.mdRadius,
          borderSide: BorderSide(color: border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.mdRadius,
          borderSide: BorderSide(color: border),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: AppRadius.mdRadius,
          borderSide: BorderSide(color: AppColors.primary),
        ),
      ),
      progressIndicatorTheme:
          const ProgressIndicatorThemeData(color: AppColors.primary),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: card,
        surfaceTintColor: card,
      ),
    );
  }

  static ThemeData get light => _build(
        brightness: Brightness.light,
        background: AppColors.neutral,
        surface: AppColors.surface,
        card: AppColors.surface,
        onSurface: AppColors.onSurface,
        muted: AppColors.secondary,
        border: AppColors.borderLight,
        error: AppColors.error,
      );

  static ThemeData get dark => _build(
        brightness: Brightness.dark,
        background: AppColors.darkBackground,
        surface: AppColors.darkSurface,
        card: AppColors.darkSurface,
        onSurface: AppColors.onDark,
        muted: AppColors.darkSecondary,
        border: AppColors.darkBorder,
        error: AppColors.darkError,
      );
}
