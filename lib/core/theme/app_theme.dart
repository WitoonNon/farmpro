import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';

class AppTheme {
  AppTheme._();

  // ─── Light Theme ─────────────────────────────────────────────────────────────
  static ThemeData get lightTheme {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: _colorScheme,
      scaffoldBackgroundColor: AppColors.background,
    );

    return base.copyWith(
      textTheme: _buildTextTheme(base.textTheme),
      appBarTheme: _appBarTheme,
      cardTheme: _cardTheme,
      elevatedButtonTheme: _elevatedButtonTheme,
      outlinedButtonTheme: _outlinedButtonTheme,
      textButtonTheme: _textButtonTheme,
      inputDecorationTheme: _inputDecorationTheme,
      bottomNavigationBarTheme: _bottomNavTheme,
      chipTheme: _chipTheme,
      dividerTheme: _dividerTheme,
      iconTheme: _iconTheme,
      snackBarTheme: _snackBarTheme,
      badgeTheme: _badgeTheme,
      floatingActionButtonTheme: _fabTheme,
      progressIndicatorTheme: _progressIndicatorTheme,
      tabBarTheme: _tabBarTheme,
      navigationBarTheme: _navigationBarTheme,
      dialogTheme: _dialogTheme,
      listTileTheme: _listTileTheme,
    );
  }

  // ─── Color Scheme ─────────────────────────────────────────────────────────────
  static const ColorScheme _colorScheme = ColorScheme(
    brightness: Brightness.light,

    // Primary – Forest Green
    primary: AppColors.primary,
    onPrimary: AppColors.onPrimary,
    primaryContainer: AppColors.primaryContainer,
    onPrimaryContainer: AppColors.primaryDark,

    // Secondary – Soil Brown
    secondary: AppColors.secondary,
    onSecondary: AppColors.onPrimary,
    secondaryContainer: AppColors.secondaryContainer,
    onSecondaryContainer: AppColors.secondaryDark,

    // Tertiary – Harvest Gold
    tertiary: AppColors.accent,
    onTertiary: AppColors.textPrimary,
    tertiaryContainer: AppColors.accentLight,
    onTertiaryContainer: AppColors.accentDark,

    // Error
    error: AppColors.error,
    onError: AppColors.onPrimary,
    errorContainer: Color(0xFFFFDAD6),
    onErrorContainer: Color(0xFF410002),

    // Background / Surface
    surface: AppColors.surface,
    onSurface: AppColors.textPrimary,
    surfaceContainerHighest: AppColors.surfaceVariant,
    onSurfaceVariant: AppColors.textSecondary,

    // Outline
    outline: AppColors.border,
    outlineVariant: AppColors.divider,

    // Inverse
    inverseSurface: AppColors.textPrimary,
    onInverseSurface: AppColors.surface,
    inversePrimary: AppColors.primaryLight,

    // Shadow / Scrim
    shadow: AppColors.shadowDark,
    scrim: AppColors.shadowDark,
  );

  // ─── Typography (Google Fonts – Sarabun for Thai support) ────────────────────
  static TextTheme _buildTextTheme(TextTheme base) {
    return GoogleFonts.sarabunTextTheme(base).copyWith(
      displayLarge: GoogleFonts.sarabun(
        fontSize: 57,
        fontWeight: FontWeight.w400,
        color: AppColors.textPrimary,
        letterSpacing: -0.25,
      ),
      displayMedium: GoogleFonts.sarabun(
        fontSize: 45,
        fontWeight: FontWeight.w400,
        color: AppColors.textPrimary,
      ),
      displaySmall: GoogleFonts.sarabun(
        fontSize: 36,
        fontWeight: FontWeight.w400,
        color: AppColors.textPrimary,
      ),
      headlineLarge: GoogleFonts.sarabun(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      ),
      headlineMedium: GoogleFonts.sarabun(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
      headlineSmall: GoogleFonts.sarabun(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
      titleLarge: GoogleFonts.sarabun(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
      titleMedium: GoogleFonts.sarabun(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimary,
        letterSpacing: 0.15,
      ),
      titleSmall: GoogleFonts.sarabun(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimary,
        letterSpacing: 0.1,
      ),
      bodyLarge: GoogleFonts.sarabun(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: AppColors.textPrimary,
        letterSpacing: 0.5,
      ),
      bodyMedium: GoogleFonts.sarabun(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
        letterSpacing: 0.25,
      ),
      bodySmall: GoogleFonts.sarabun(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: AppColors.textHint,
        letterSpacing: 0.4,
      ),
      labelLarge: GoogleFonts.sarabun(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
        letterSpacing: 0.1,
      ),
      labelMedium: GoogleFonts.sarabun(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: AppColors.textSecondary,
        letterSpacing: 0.5,
      ),
      labelSmall: GoogleFonts.sarabun(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        color: AppColors.textHint,
        letterSpacing: 0.5,
      ),
    );
  }

  // ─── AppBar ──────────────────────────────────────────────────────────────────
  static const AppBarTheme _appBarTheme = AppBarTheme(
    backgroundColor: Colors.transparent,
    foregroundColor: AppColors.textOnPrimary,
    elevation: 0,
    scrolledUnderElevation: 0,
    centerTitle: false,
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
    ),
    iconTheme: IconThemeData(color: AppColors.textOnPrimary, size: 24),
    actionsIconTheme: IconThemeData(color: AppColors.textOnPrimary, size: 24),
  );

  // ─── Card ────────────────────────────────────────────────────────────────────
  static final CardThemeData _cardTheme = CardThemeData(
    color: AppColors.surface,
    surfaceTintColor: Colors.transparent,
    elevation: 2,
    shadowColor: AppColors.shadow,
    margin: EdgeInsets.zero,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
    clipBehavior: Clip.antiAlias,
  );

  // ─── Elevated Button ─────────────────────────────────────────────────────────
  static final ElevatedButtonThemeData _elevatedButtonTheme =
      ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.onPrimary,
      disabledBackgroundColor: AppColors.divider,
      disabledForegroundColor: AppColors.textHint,
      elevation: 2,
      shadowColor: AppColors.shadow,
      minimumSize: const Size(double.infinity, 52),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      textStyle: GoogleFonts.sarabun(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
      ),
    ),
  );

  // ─── Outlined Button ─────────────────────────────────────────────────────────
  static final OutlinedButtonThemeData _outlinedButtonTheme =
      OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: AppColors.primary,
      side: const BorderSide(color: AppColors.primary, width: 1.5),
      minimumSize: const Size(double.infinity, 52),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      textStyle: GoogleFonts.sarabun(
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
    ),
  );

  // ─── Text Button ─────────────────────────────────────────────────────────────
  static final TextButtonThemeData _textButtonTheme = TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: AppColors.primary,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      textStyle: GoogleFonts.sarabun(
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
    ),
  );

  // ─── Input Decoration ────────────────────────────────────────────────────────
  static InputDecorationTheme get _inputDecorationTheme => InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.error, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.error, width: 2),
        ),
        hintStyle: GoogleFonts.sarabun(
          color: AppColors.textHint,
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
        labelStyle: GoogleFonts.sarabun(
          color: AppColors.textSecondary,
          fontSize: 14,
        ),
        errorStyle: GoogleFonts.sarabun(
          color: AppColors.error,
          fontSize: 12,
        ),
        prefixIconColor: AppColors.textHint,
        suffixIconColor: AppColors.textHint,
      );

  // ─── Bottom Navigation Bar ───────────────────────────────────────────────────
  static BottomNavigationBarThemeData get _bottomNavTheme =>
      BottomNavigationBarThemeData(
        backgroundColor: AppColors.surface,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textHint,
        selectedLabelStyle: GoogleFonts.sarabun(
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: GoogleFonts.sarabun(
          fontSize: 11,
          fontWeight: FontWeight.w400,
        ),
        type: BottomNavigationBarType.fixed,
        elevation: 12,
        showSelectedLabels: true,
        showUnselectedLabels: true,
      );

  // ─── Navigation Bar (Material 3) ─────────────────────────────────────────────
  static NavigationBarThemeData get _navigationBarTheme =>
      NavigationBarThemeData(
        backgroundColor: AppColors.surface,
        indicatorColor: AppColors.primaryContainer,
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: AppColors.primary, size: 24);
          }
          return const IconThemeData(color: AppColors.textHint, size: 22);
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return GoogleFonts.sarabun(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            );
          }
          return GoogleFonts.sarabun(
            fontSize: 11,
            fontWeight: FontWeight.w400,
            color: AppColors.textHint,
          );
        }),
        elevation: 12,
        height: 68,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      );

  // ─── Chip ────────────────────────────────────────────────────────────────────
  static ChipThemeData get _chipTheme => ChipThemeData(
        backgroundColor: AppColors.primaryContainer,
        selectedColor: AppColors.primary,
        labelStyle: GoogleFonts.sarabun(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: AppColors.textPrimary,
        ),
        secondaryLabelStyle: GoogleFonts.sarabun(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: AppColors.onPrimary,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        side: BorderSide.none,
        elevation: 0,
      );

  // ─── Divider ─────────────────────────────────────────────────────────────────
  static const DividerThemeData _dividerTheme = DividerThemeData(
    color: AppColors.divider,
    thickness: 1,
    space: 1,
  );

  // ─── Icon ────────────────────────────────────────────────────────────────────
  static const IconThemeData _iconTheme = IconThemeData(
    color: AppColors.textSecondary,
    size: 24,
  );

  // ─── SnackBar ────────────────────────────────────────────────────────────────
  static SnackBarThemeData get _snackBarTheme => SnackBarThemeData(
        backgroundColor: AppColors.textPrimary,
        contentTextStyle: GoogleFonts.sarabun(
          color: AppColors.onPrimary,
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
        actionTextColor: AppColors.primaryLight,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        behavior: SnackBarBehavior.floating,
        elevation: 4,
      );

  // ─── Badge ───────────────────────────────────────────────────────────────────
  static const BadgeThemeData _badgeTheme = BadgeThemeData(
    backgroundColor: AppColors.badge,
    textColor: Colors.white,
    smallSize: 8,
    largeSize: 18,
    textStyle: TextStyle(fontSize: 10, fontWeight: FontWeight.w700),
  );

  // ─── FAB ─────────────────────────────────────────────────────────────────────
  static const FloatingActionButtonThemeData _fabTheme =
      FloatingActionButtonThemeData(
    backgroundColor: AppColors.primary,
    foregroundColor: AppColors.onPrimary,
    elevation: 4,
    focusElevation: 6,
    hoverElevation: 6,
    highlightElevation: 8,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(16)),
    ),
  );

  // ─── Progress Indicator ──────────────────────────────────────────────────────
  static const ProgressIndicatorThemeData _progressIndicatorTheme =
      ProgressIndicatorThemeData(
    color: AppColors.primary,
    linearTrackColor: AppColors.primaryContainer,
    circularTrackColor: AppColors.primaryContainer,
    linearMinHeight: 6,
  );

  // ─── Tab Bar ─────────────────────────────────────────────────────────────────
  static TabBarThemeData get _tabBarTheme => TabBarThemeData(
        labelColor: AppColors.primary,
        unselectedLabelColor: AppColors.textHint,
        indicatorColor: AppColors.primary,
        indicatorSize: TabBarIndicatorSize.label,
        dividerColor: AppColors.divider,
        labelStyle: GoogleFonts.sarabun(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: GoogleFonts.sarabun(
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
      );

  // ─── Dialog ──────────────────────────────────────────────────────────────────
  static final DialogThemeData _dialogTheme = DialogThemeData(
    backgroundColor: AppColors.surface,
    surfaceTintColor: Colors.transparent,
    elevation: 8,
    shadowColor: AppColors.shadowDark,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(24),
    ),
    titleTextStyle: GoogleFonts.sarabun(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: AppColors.textPrimary,
    ),
    contentTextStyle: GoogleFonts.sarabun(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: AppColors.textSecondary,
    ),
  );

  // ─── List Tile ───────────────────────────────────────────────────────────────
  static ListTileThemeData get _listTileTheme => ListTileThemeData(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        tileColor: Colors.transparent,
        titleTextStyle: GoogleFonts.sarabun(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: AppColors.textPrimary,
        ),
        subtitleTextStyle: GoogleFonts.sarabun(
          fontSize: 13,
          fontWeight: FontWeight.w400,
          color: AppColors.textSecondary,
        ),
        iconColor: AppColors.textSecondary,
        minLeadingWidth: 24,
        minVerticalPadding: 8,
      );
}
