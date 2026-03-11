// ─────────────────────────────────────────────────────────────────────────────
//  core/constants/app_text_styles.dart
//  Farmer-friendly typography – large, clear, readable at a glance.
//  Uses Google Fonts "Sarabun" for full Thai-language support.
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  // ─── Base font helper ────────────────────────────────────────────────────────
  static TextStyle _sarabun({
    required double fontSize,
    FontWeight fontWeight = FontWeight.w400,
    Color color = AppColors.textPrimary,
    double? height,
    double letterSpacing = 0,
    TextDecoration? decoration,
  }) {
    return GoogleFonts.sarabun(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      height: height,
      letterSpacing: letterSpacing,
      decoration: decoration,
    );
  }

  // ─── Display ─────────────────────────────────────────────────────────────────
  static TextStyle get displayLarge => _sarabun(
        fontSize: 36,
        fontWeight: FontWeight.w800,
        height: 1.2,
        letterSpacing: -0.5,
      );

  static TextStyle get displayMedium => _sarabun(
        fontSize: 30,
        fontWeight: FontWeight.w700,
        height: 1.25,
      );

  // ─── Headlines ───────────────────────────────────────────────────────────────
  /// Section titles, screen headers – 24 sp Bold
  static TextStyle get headlineLarge => _sarabun(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        height: 1.3,
      );

  /// Card headers, dialog titles – 20 sp SemiBold
  static TextStyle get headlineMedium => _sarabun(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        height: 1.35,
      );

  /// Sub-section labels – 18 sp SemiBold
  static TextStyle get headlineSmall => _sarabun(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        height: 1.4,
      );

  // ─── Titles ──────────────────────────────────────────────────────────────────
  /// Product name, list item title – 16 sp SemiBold
  static TextStyle get titleLarge => _sarabun(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        height: 1.4,
      );

  /// Card subtitle – 14 sp Medium
  static TextStyle get titleMedium => _sarabun(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        height: 1.4,
      );

  /// Small label title – 13 sp Medium
  static TextStyle get titleSmall => _sarabun(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: AppColors.textSecondary,
        height: 1.4,
      );

  // ─── Body ────────────────────────────────────────────────────────────────────
  /// Primary reading text – 16 sp Regular
  static TextStyle get bodyLarge => _sarabun(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.6,
      );

  /// Secondary reading text – 14 sp Regular
  static TextStyle get bodyMedium => _sarabun(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
        height: 1.6,
      );

  /// Caption / helper text – 12 sp Regular
  static TextStyle get bodySmall => _sarabun(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: AppColors.textHint,
        height: 1.5,
      );

  // ─── Labels ──────────────────────────────────────────────────────────────────
  /// Button text, tab labels – 15 sp SemiBold
  static TextStyle get labelLarge => _sarabun(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.3,
      );

  /// Chip, badge labels – 13 sp Medium
  static TextStyle get labelMedium => _sarabun(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.2,
      );

  /// Tiny tag labels – 11 sp Medium
  static TextStyle get labelSmall => _sarabun(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.4,
        color: AppColors.textSecondary,
      );

  // ─── Price ───────────────────────────────────────────────────────────────────
  /// Large featured price – 28 sp ExtraBold, accent color
  static TextStyle get priceLarge => _sarabun(
        fontSize: 28,
        fontWeight: FontWeight.w800,
        color: AppColors.accent,
        letterSpacing: -0.5,
      );

  /// Standard product price – 18 sp Bold, primary green
  static TextStyle get priceMedium => _sarabun(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrice,
      );

  /// Small inline price – 14 sp Bold
  static TextStyle get priceSmall => _sarabun(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrice,
      );

  /// Strikethrough original price – 13 sp Regular, grey
  static TextStyle get priceOriginal => _sarabun(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        color: AppColors.textHint,
        decoration: TextDecoration.lineThrough,
      );

  // ─── Discount / Badge ────────────────────────────────────────────────────────
  /// Discount percentage badge – 14 sp Bold, red
  static TextStyle get discountBadge => _sarabun(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: AppColors.textOnDark,
      );

  // ─── Banner / Promo ──────────────────────────────────────────────────────────
  /// Banner main discount figure – 40 sp ExtraBold, white
  static TextStyle get bannerDiscount => _sarabun(
        fontSize: 40,
        fontWeight: FontWeight.w800,
        color: AppColors.accent,
        height: 1.0,
        letterSpacing: -1,
      );

  /// Banner title – 18 sp Bold, white
  static TextStyle get bannerTitle => _sarabun(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: AppColors.textOnDark,
        height: 1.3,
      );

  /// Banner subtitle – 14 sp Regular, white 80%
  static TextStyle get bannerSubtitle => _sarabun(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: Color(0xCCFFFFFF),
        height: 1.4,
      );

  /// Banner badge pill text – 12 sp SemiBold, white
  static TextStyle get bannerBadge => _sarabun(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: AppColors.textOnDark,
      );

  // ─── Navigation ──────────────────────────────────────────────────────────────
  /// Bottom nav label – 11 sp SemiBold
  static TextStyle get navLabel => _sarabun(
        fontSize: 11,
        fontWeight: FontWeight.w600,
      );

  // ─── Search ──────────────────────────────────────────────────────────────────
  /// Search field input – 15 sp Regular
  static TextStyle get searchInput => _sarabun(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        color: AppColors.textPrimary,
      );

  /// Search hint – 14 sp Regular, hint color
  static TextStyle get searchHint => _sarabun(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AppColors.textHint,
      );

  // ─── App Bar ─────────────────────────────────────────────────────────────────
  /// Greeting line – 14 sp Regular, white 80%
  static TextStyle get greetingText => _sarabun(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: Color(0xCCFFFFFF),
      );

  /// Username – 18 sp Bold, white
  static TextStyle get usernameText => _sarabun(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: AppColors.textOnDark,
      );

  /// App brand name – 22 sp ExtraBold, white
  static TextStyle get brandName => _sarabun(
        fontSize: 22,
        fontWeight: FontWeight.w800,
        color: AppColors.textOnDark,
        letterSpacing: -0.3,
      );

  // ─── Section Header ──────────────────────────────────────────────────────────
  /// "ทั้งหมด →" link style
  static TextStyle get seeAllLink => _sarabun(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: AppColors.primary,
      );

  // ─── Category tile ───────────────────────────────────────────────────────────
  /// Category name below icon – 12 sp Medium, centered
  static TextStyle get categoryName => _sarabun(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimary,
        height: 1.3,
      );

  // ─── Tip / Knowledge card ────────────────────────────────────────────────────
  static TextStyle get tipTitle => _sarabun(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.tipGreenDark,
        height: 1.4,
      );

  static TextStyle get tipBody => _sarabun(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
        height: 1.6,
      );

  // ─── Shipping banner ─────────────────────────────────────────────────────────
  static TextStyle get shippingTitle => _sarabun(
        fontSize: 15,
        fontWeight: FontWeight.w700,
        color: AppColors.textOnDark,
      );

  static TextStyle get shippingSubtitle => _sarabun(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: Color(0xDDFFFFFF),
      );

  // ─── Button ──────────────────────────────────────────────────────────────────
  static TextStyle get buttonLarge => _sarabun(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColors.textOnPrimary,
        letterSpacing: 0.3,
      );

  static TextStyle get buttonMedium => _sarabun(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.textOnPrimary,
        letterSpacing: 0.2,
      );

  static TextStyle get addToCartButton => _sarabun(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: AppColors.textOnPrimary,
      );

  // ─── Rating ──────────────────────────────────────────────────────────────────
  static TextStyle get ratingText => _sarabun(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: AppColors.accent,
      );

  static TextStyle get reviewCount => _sarabun(
        fontSize: 11,
        fontWeight: FontWeight.w400,
        color: AppColors.textHint,
      );

  // ─── Empty / Error state ─────────────────────────────────────────────────────
  static TextStyle get emptyStateTitle => _sarabun(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: AppColors.textSecondary,
      );

  static TextStyle get emptyStateSubtitle => _sarabun(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AppColors.textHint,
        height: 1.6,
      );
}
