import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const Color lightPrimary = Color(0xFF0061A4);
  static const Color lightOnPrimary = Color(0xFFFFFFFF);
  static const Color lightPrimaryContainer = Color(0xFFD0E4FF);
  static const Color lightOnPrimaryContainer = Color(0xFF001D36);
  static const Color lightSecondary = Color(0xFF535F70);
  static const Color lightOnSecondary = Color(0xFFFFFFFF);
  static const Color lightSecondaryContainer = Color(0xFFD6E4F7);
  static const Color lightOnSecondaryContainer = Color(0xFF101C2B);
  static const Color lightTertiary = Color(0xFF6B5778);
  static const Color lightOnTertiary = Color(0xFFFFFFFF);
  static const Color lightTertiaryContainer = Color(0xFFF3DAFF);
  static const Color lightOnTertiaryContainer = Color(0xFF251431);
  static const Color lightSuccess = Color(0xFF388E3C);
  static const Color lightOnSuccess = Color(0xFFFFFFFF);
  static const Color lightSuccessContainer = Color(0xFFC8E6C9);
  static const Color lightOnSuccessContainer = Color(0xFF1B5E20);
  static const Color lightError = Color(0xFFBA1A1A);
  static const Color lightOnError = Color(0xFFFFFFFF);
  static const Color lightErrorContainer = Color(0xFFFFDAD6);
  static const Color lightOnErrorContainer = Color(0xFF410002);
  static const Color lightSurface = Color(0xFFFDFCFF);
  static const Color lightOnSurface = Color(0xFF1A1C1E);
  static const Color lightSurfaceVariant = Color(0xFFDFE2EB);
  static const Color lightOnSurfaceVariant = Color(0xFF43474E);
  static const Color lightOutline = Color(0xFF73777F);

  static const Color darkPrimary = Color(0xFF9BCBFF);
  static const Color darkOnPrimary = Color(0xFF003258);
  static const Color darkPrimaryContainer = Color(0xFF00497D);
  static const Color darkOnPrimaryContainer = Color(0xFFD0E4FF);
  static const Color darkSecondary = Color(0xFFBAC8DB);
  static const Color darkOnSecondary = Color(0xFF253140);
  static const Color darkSecondaryContainer = Color(0xFF3B4858);
  static const Color darkOnSecondaryContainer = Color(0xFFD6E4F7);
  static const Color darkTertiary = Color(0xFFD7BDE4);
  static const Color darkOnTertiary = Color(0xFF3B2948);
  static const Color darkTertiaryContainer = Color(0xFF523F5F);
  static const Color darkOnTertiaryContainer = Color(0xFFF3DAFF);
  static const Color darkSuccess = Color(0xFF81C784);
  static const Color darkOnSuccess = Color(0xFF003300);
  static const Color darkSuccessContainer = Color(0xFF388E3C);
  static const Color darkOnSuccessContainer = Color(0xFFC8E6C9);
  static const Color darkError = Color(0xFFFFB4AB);
  static const Color darkOnError = Color(0xFF690005);
  static const Color darkErrorContainer = Color(0xFF93000A);
  static const Color darkOnErrorContainer = Color(0xFFFFDAD6);
  static const Color darkSurface = Color(0xFF1A1C1E);
  static const Color darkOnSurface = Color(0xFFE3E2E6);
  static const Color darkSurfaceVariant = Color(0xFF43474E);
  static const Color darkOnSurfaceVariant = Color(0xFFC3C6CF);
  static const Color darkOutline = Color(0xFF8D9199);
}

class AppTextStyles {
  static TextStyle get headlineLarge => GoogleFonts.inter(fontSize: 32, fontWeight: FontWeight.w400);
  static TextStyle get headlineMedium => GoogleFonts.inter(fontSize: 28, fontWeight: FontWeight.w400);
  static TextStyle get headlineSmall => GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.w400);
  static TextStyle get titleLarge => GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.w500);
  static TextStyle get titleMedium => GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w500);
  static TextStyle get titleSmall => GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500);
  static TextStyle get bodyLarge => GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w400);
  static TextStyle get bodyMedium => GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w400);
  static TextStyle get bodySmall => GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w400);
  static TextStyle get labelLarge => GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500);
  static TextStyle get labelMedium => GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500);
  static TextStyle get labelSmall => GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w500);
}

class AppTheme {
  static const double _padding = 24.0;
  static const double _radius = 24.0;
  static const double _inputPaddingH = 16.0;
  static const double _inputPaddingV = 12.0;
  static const double _iconSize = 24.0;
  static const double _dialogRadius = 16.0;
  static const double _cardMargin = 8.0;

  static TextTheme _buildTextTheme(Color onSurfaceColor) {
    return TextTheme(
      headlineLarge: AppTextStyles.headlineLarge,
      headlineMedium: AppTextStyles.headlineMedium,
      headlineSmall: AppTextStyles.headlineSmall,
      titleLarge: AppTextStyles.titleLarge,
      titleMedium: AppTextStyles.titleMedium,
      titleSmall: AppTextStyles.titleSmall,
      bodyLarge: AppTextStyles.bodyLarge,
      bodyMedium: AppTextStyles.bodyMedium,
      bodySmall: AppTextStyles.bodySmall,
      labelLarge: AppTextStyles.labelLarge,
      labelMedium: AppTextStyles.labelMedium,
      labelSmall: AppTextStyles.labelSmall,
    ).apply(
      displayColor: onSurfaceColor,
      bodyColor: onSurfaceColor,
    );
  }

  static TextButtonThemeData _buildTextButtonTheme(Color foregroundColor) {
    return TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: foregroundColor,
        textStyle: AppTextStyles.labelLarge.copyWith(color: foregroundColor),
      ),
    );
  }

  static OutlinedButtonThemeData _buildOutlinedButtonTheme(Color foregroundColor, Color outlineColor) {
    return OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: foregroundColor,
        side: BorderSide(color: outlineColor),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        padding: const EdgeInsets.symmetric(horizontal: _padding, vertical: 12.0),
        textStyle: AppTextStyles.labelLarge.copyWith(color: foregroundColor),
      ),
    );
  }

  static SnackBarThemeData _buildSnackBarTheme(Color surfaceVariantColor, Color onSurfaceColor) {
    return SnackBarThemeData(
      backgroundColor: surfaceVariantColor,
      behavior: SnackBarBehavior.floating,
      contentTextStyle: AppTextStyles.bodyMedium.copyWith(color: onSurfaceColor),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 6,
    );
  }

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: const ColorScheme(
      primary: AppColors.lightPrimary,
      onPrimary: AppColors.lightOnPrimary,
      primaryContainer: AppColors.lightPrimaryContainer,
      onPrimaryContainer: AppColors.lightOnPrimaryContainer,
      secondary: AppColors.lightSecondary,
      onSecondary: AppColors.lightOnSecondary,
      secondaryContainer: AppColors.lightSecondaryContainer,
      onSecondaryContainer: AppColors.lightOnSecondaryContainer,
      tertiary: AppColors.lightTertiary,
      onTertiary: AppColors.lightOnTertiary,
      tertiaryContainer: AppColors.lightTertiaryContainer,
      onTertiaryContainer: AppColors.lightOnTertiaryContainer,
      error: AppColors.lightError,
      onError: AppColors.lightOnError,
      errorContainer: AppColors.lightErrorContainer,
      onErrorContainer: AppColors.lightOnErrorContainer,
      surface: AppColors.lightSurface,
      onSurface: AppColors.lightOnSurface,
      surfaceContainerHighest: AppColors.lightSurfaceVariant,
      onSurfaceVariant: AppColors.lightOnSurfaceVariant,
      outline: AppColors.lightOutline,
      shadow: Colors.black,
      inverseSurface: AppColors.darkSurface,
      onInverseSurface: AppColors.darkOnSurface,
      inversePrimary: AppColors.darkPrimary,
      brightness: Brightness.light,
    ),
    textTheme: _buildTextTheme(AppColors.lightOnSurface),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.lightSurface,
      foregroundColor: AppColors.lightOnSurface,
      elevation: 4,
      shadowColor: Colors.black26,
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: AppColors.lightSurface,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.dark,
      ),
      titleTextStyle: AppTextStyles.titleLarge.copyWith(color: AppColors.lightOnSurface),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.lightPrimary,
        foregroundColor: AppColors.lightOnPrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_radius),
        ),
        padding: const EdgeInsets.symmetric(horizontal: _padding, vertical: 12.0),
        elevation: 5,
      ),
    ),
    textButtonTheme: _buildTextButtonTheme(AppColors.lightPrimary),
    outlinedButtonTheme: _buildOutlinedButtonTheme(AppColors.lightPrimary, AppColors.lightOutline),
    cardTheme: CardThemeData(
      elevation: 10,
      color: AppColors.lightSurface,
      surfaceTintColor: AppColors.lightPrimaryContainer,
      shadowColor: AppColors.lightPrimary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_radius),
      ),
      margin: const EdgeInsets.all(_cardMargin),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.lightSurfaceVariant.withAlpha(96),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: AppColors.lightPrimary, width: 2.0),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: AppColors.lightError, width: 2.0),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: AppColors.lightError, width: 2.0),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: _inputPaddingH, vertical: _inputPaddingV),
      hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.lightOnSurfaceVariant),
      labelStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.lightOnSurface),
      errorStyle: AppTextStyles.bodySmall.copyWith(color: AppColors.lightError),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: AppColors.lightSurface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_dialogRadius),
      ),
      elevation: 8,
      titleTextStyle: AppTextStyles.titleLarge.copyWith(color: AppColors.lightOnSurface),
      contentTextStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.lightOnSurface),
    ),
    iconTheme: const IconThemeData(
      color: AppColors.lightOnSurface,
      size: _iconSize,
    ),
    primaryIconTheme: const IconThemeData(
      color: AppColors.lightOnPrimary,
      size: _iconSize,
    ),
    snackBarTheme: _buildSnackBarTheme(AppColors.lightSurfaceVariant, AppColors.lightOnSurface),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: const ColorScheme(
      primary: AppColors.darkPrimary,
      onPrimary: AppColors.darkOnPrimary,
      primaryContainer: AppColors.darkPrimaryContainer,
      onPrimaryContainer: AppColors.darkOnPrimaryContainer,
      secondary: AppColors.darkSecondary,
      onSecondary: AppColors.darkOnSecondary,
      secondaryContainer: AppColors.darkSecondaryContainer,
      onSecondaryContainer: AppColors.darkOnSecondaryContainer,
      tertiary: AppColors.darkTertiary,
      onTertiary: AppColors.darkOnTertiary,
      tertiaryContainer: AppColors.darkTertiaryContainer,
      onTertiaryContainer: AppColors.darkOnTertiaryContainer,
      error: AppColors.darkError,
      onError: AppColors.darkOnError,
      errorContainer: AppColors.darkErrorContainer,
      onErrorContainer: AppColors.darkOnErrorContainer,
      surface: AppColors.darkSurface,
      onSurface: AppColors.darkOnSurface,
      surfaceContainerHighest: AppColors.darkSurfaceVariant,
      onSurfaceVariant: AppColors.darkOnSurfaceVariant,
      outline: AppColors.darkOutline,
      shadow: Colors.black,
      inverseSurface: AppColors.lightSurface,
      onInverseSurface: AppColors.lightOnSurface,
      inversePrimary: AppColors.lightPrimary,
      brightness: Brightness.dark,
    ),
    textTheme: _buildTextTheme(AppColors.darkOnSurface),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.darkSurface,
      foregroundColor: AppColors.darkOnSurface,
      elevation: 4,
      shadowColor: Colors.black26,
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: AppColors.darkSurface,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.light,
      ),
      titleTextStyle: AppTextStyles.titleLarge.copyWith(color: AppColors.darkOnSurface),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.darkPrimary,
        foregroundColor: AppColors.darkOnPrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_radius),
        ),
        padding: const EdgeInsets.symmetric(horizontal: _padding, vertical: 12.0),
        elevation: 5,
      ),
    ),
    textButtonTheme: _buildTextButtonTheme(AppColors.darkPrimary),
    outlinedButtonTheme: _buildOutlinedButtonTheme(AppColors.darkPrimary, AppColors.darkOutline),
    cardTheme: CardThemeData(
      elevation: 10,
      color: AppColors.darkSurface,
      surfaceTintColor: AppColors.darkPrimaryContainer,
      shadowColor: AppColors.darkPrimary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_radius),
      ),
      margin: const EdgeInsets.all(_cardMargin),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.darkSurfaceVariant.withAlpha(96),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: AppColors.darkPrimary, width: 2.0),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: AppColors.darkError, width: 2.0),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: AppColors.darkError, width: 2.0),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: _inputPaddingH, vertical: _inputPaddingV),
      hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.darkOnSurfaceVariant),
      labelStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.darkOnSurface),
      errorStyle: AppTextStyles.bodySmall.copyWith(color: AppColors.darkError),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: AppColors.darkSurface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_dialogRadius),
      ),
      elevation: 8,
      titleTextStyle: AppTextStyles.titleLarge.copyWith(color: AppColors.darkOnSurface),
      contentTextStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.darkOnSurface),
    ),
    iconTheme: const IconThemeData(
      color: AppColors.darkOnSurface,
      size: _iconSize,
    ),
    primaryIconTheme: const IconThemeData(
      color: AppColors.darkOnPrimary,
      size: _iconSize,
    ),
    snackBarTheme: _buildSnackBarTheme(AppColors.darkSurfaceVariant, AppColors.darkOnSurface),
  );
}