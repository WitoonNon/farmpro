import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // ─── Primary – Agricultural Forest Green ───────────────────────────────────
  static const Color primary        = Color(0xFF2E7D32);
  static const Color primaryLight   = Color(0xFF4CAF50);
  static const Color primaryDark    = Color(0xFF1B5E20);
  static const Color primaryContainer = Color(0xFFE8F5E9);
  static const Color onPrimary      = Color(0xFFFFFFFF);

  // ─── Secondary – Warm Earth / Soil Brown ────────────────────────────────────
  static const Color secondary          = Color(0xFF795548);
  static const Color secondaryLight     = Color(0xFFA1887F);
  static const Color secondaryDark      = Color(0xFF4E342E);
  static const Color secondaryContainer = Color(0xFFEFEBE9);

  // ─── Accent – Harvest Golden Yellow ─────────────────────────────────────────
  static const Color accent      = Color(0xFFF9A825);
  static const Color accentLight = Color(0xFFFFECB3);
  static const Color accentDark  = Color(0xFFF57F17);

  // ─── Header / AppBar – Deep Forest ──────────────────────────────────────────
  static const Color headerDark  = Color(0xFF1B3A2D);
  static const Color headerMid   = Color(0xFF1B4332);

  // ─── Promo Banner ────────────────────────────────────────────────────────────
  static const Color promoBrown      = Color(0xFF6D4C41);
  static const Color promoBrownLight = Color(0xFF8D6E63);
  static const Color promoBrownDark  = Color(0xFF4E342E);

  // ─── Shipping Banner ─────────────────────────────────────────────────────────
  static const Color shippingOrange      = Color(0xFFE65100);
  static const Color shippingOrangeLight = Color(0xFFFF6D00);

  // ─── Tip / Knowledge Card ────────────────────────────────────────────────────
  static const Color tipGreen      = Color(0xFFDCEDC8);
  static const Color tipGreenDark  = Color(0xFF33691E);

  // ─── Status ──────────────────────────────────────────────────────────────────
  static const Color success = Color(0xFF2E7D32);
  static const Color warning = Color(0xFFFB8C00);
  static const Color error   = Color(0xFFB71C1C);
  static const Color info    = Color(0xFF0277BD);

  // ─── Category Chip Backgrounds ───────────────────────────────────────────────
  static const Color catOrganic   = Color(0xFFE8F5E9); // light green
  static const Color catChemical  = Color(0xFFFFF9C4); // light yellow
  static const Color catLiquid    = Color(0xFFE3F2FD); // light blue
  static const Color catPesticide = Color(0xFFFCE4EC); // light pink
  static const Color catSeeds     = Color(0xFFF3E5F5); // light purple
  static const Color catFertilizer= Color(0xFFFFF3E0); // light orange
  static const Color catTools     = Color(0xFFE0F7FA); // light cyan

  // ─── Category Icon Colors ─────────────────────────────────────────────────────
  static const Color catOrganicIcon   = Color(0xFF388E3C);
  static const Color catChemicalIcon  = Color(0xFFF9A825);
  static const Color catLiquidIcon    = Color(0xFF1976D2);
  static const Color catPesticideIcon = Color(0xFFD81B60);
  static const Color catSeedsIcon     = Color(0xFF7B1FA2);
  static const Color catFertilizerIcon= Color(0xFFE65100);
  static const Color catToolsIcon     = Color(0xFF00838F);

  // ─── Background & Surface ────────────────────────────────────────────────────
  static const Color background      = Color(0xFFF5F5F0);
  static const Color surface         = Color(0xFFFFFFFF);
  static const Color surfaceVariant  = Color(0xFFF1F8E9);
  static const Color surfaceCard     = Color(0xFFFFFFFF);

  // ─── Text ────────────────────────────────────────────────────────────────────
  static const Color textPrimary   = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF616161);
  static const Color textHint      = Color(0xFF9E9E9E);
  static const Color textOnDark    = Color(0xFFFFFFFF);
  static const Color textOnPrimary = Color(0xFFFFFFFF);
  static const Color textPrice     = Color(0xFF2E7D32);
  static const Color textDiscount  = Color(0xFFB71C1C);

  // ─── Divider & Border ────────────────────────────────────────────────────────
  static const Color divider = Color(0xFFE0E0E0);
  static const Color border  = Color(0xFFBDBDBD);

  // ─── Shadow ──────────────────────────────────────────────────────────────────
  static const Color shadow     = Color(0x1A000000);
  static const Color shadowDark = Color(0x33000000);

  // ─── Badge / Cart ────────────────────────────────────────────────────────────
  static const Color badge = Color(0xFFE53935);

  // ─── Gradient helpers ────────────────────────────────────────────────────────
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryDark, primary, primaryLight],
  );

  static const LinearGradient headerGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [headerDark, headerMid],
  );

  static const LinearGradient promoGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF5D4037), Color(0xFF795548), Color(0xFF8D6E63)],
  );

  static const LinearGradient shippingGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [shippingOrange, shippingOrangeLight],
  );
}
