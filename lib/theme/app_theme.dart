import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_spacing.dart';
import 'app_typography.dart';

/// Signature elevation. The system avoids soft blur shadows in favour of a
/// hard, hand-drawn offset that gives buttons and cards a sticker-like lift.
class AppShadows {
  AppShadows._();

  static const List<BoxShadow> hard = [
    BoxShadow(color: AppColors.primary, offset: Offset(4, 4), blurRadius: 0),
  ];
}

/// Assembles the design tokens into Material [ThemeData] for light and dark.
class AppTheme {
  AppTheme._();

  static ThemeData get light => _build(Brightness.light);
  static ThemeData get dark => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final bool isDark = brightness == Brightness.dark;

    final ColorScheme scheme = isDark
        ? const ColorScheme.dark(
            primary: AppColors.tertiary,
            onPrimary: AppColors.primary,
            secondary: AppColors.darkSecondary,
            onSecondary: AppColors.primary,
            tertiary: AppColors.tertiary,
            onTertiary: AppColors.primary,
            error: AppColors.darkError,
            onError: AppColors.primary,
            surface: AppColors.darkSurface,
            onSurface: AppColors.onDark,
          )
        : const ColorScheme.light(
            primary: AppColors.primary,
            onPrimary: AppColors.neutral,
            secondary: AppColors.secondary,
            onSecondary: AppColors.surface,
            tertiary: AppColors.tertiary,
            onTertiary: AppColors.primary,
            error: AppColors.error,
            onError: AppColors.surface,
            surface: AppColors.surface,
            onSurface: AppColors.onSurface,
          );

    final Color onColor = isDark ? AppColors.onDark : AppColors.onSurface;
    final Color background =
        isDark ? AppColors.darkBackground : AppColors.neutral;
    final Color cardColor = isDark ? AppColors.darkNeutral : AppColors.neutral;
    final Color inputFill = isDark ? AppColors.darkSurface : AppColors.surface;
    final Color border = isDark ? AppColors.onDark : AppColors.primary;
    final Color secondaryFill =
        isDark ? AppColors.darkSurfaceElevated : AppColors.neutral;

    final TextTheme textTheme = TextTheme(
      displayLarge: AppTypography.headlineDisplay,
      displayMedium: AppTypography.headlineLg,
      displaySmall: AppTypography.headlineMd,
      headlineMedium: AppTypography.headlineSm,
      bodyLarge: AppTypography.bodyLg,
      bodyMedium: AppTypography.bodyMd,
      bodySmall: AppTypography.bodySm,
      labelLarge: AppTypography.labelLg,
      labelMedium: AppTypography.labelMd,
      labelSmall: AppTypography.labelSm,
    ).apply(bodyColor: onColor, displayColor: onColor);

    const EdgeInsets buttonPadding =
        EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 16);
    const Size buttonMinSize = Size(0, 44);

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: background,
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: background,
        foregroundColor: onColor,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: AppTypography.headlineSm.copyWith(color: onColor),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.tertiary,
          foregroundColor: AppColors.primary,
          elevation: 0,
          padding: buttonPadding,
          minimumSize: buttonMinSize,
          shape: const StadiumBorder(),
          textStyle: AppTypography.labelMd,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          backgroundColor: secondaryFill,
          foregroundColor: onColor,
          padding: buttonPadding,
          minimumSize: buttonMinSize,
          side: BorderSide(color: border, width: 2),
          shape: const StadiumBorder(),
          textStyle: AppTypography.labelMd,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: onColor,
          padding: EdgeInsets.zero,
          minimumSize: const Size(0, 0),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
          textStyle: AppTypography.labelMd,
        ),
      ),
      cardTheme: CardThemeData(
        color: cardColor,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.lgRadius,
          side: BorderSide(color: border, width: 2),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.tertiary,
        labelStyle: AppTypography.labelMd.copyWith(color: AppColors.primary),
        side: BorderSide.none,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 8),
        shape: const StadiumBorder(),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: inputFill,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.sm,
        ),
        hintStyle: AppTypography.bodyMd.copyWith(color: scheme.secondary),
        border: OutlineInputBorder(
          borderRadius: AppRadius.mdRadius,
          borderSide: BorderSide(color: scheme.secondary),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.mdRadius,
          borderSide: BorderSide(color: scheme.secondary),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadius.mdRadius,
          borderSide: BorderSide(color: scheme.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppRadius.mdRadius,
          borderSide: BorderSide(color: scheme.error),
        ),
      ),
    );
  }
}
