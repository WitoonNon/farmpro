// =============================================================================
//  app/app.dart
//  FarmPro – Root application widget
//  Configures MaterialApp with Material 3 theme, locale, and routes.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '../core/theme/app_theme.dart';
import '../views/home/home_view.dart';

class FarmProApp extends StatelessWidget {
  const FarmProApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Lock orientation to portrait for a consistent farmer-friendly experience.
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return MaterialApp(
      // ── App metadata ────────────────────────────────────────────────────────
      title: 'FarmPro – ร้านเกษตรอัจฉริยะ',
      debugShowCheckedModeBanner: false,

      // ── Theme ────────────────────────────────────────────────────────────────
      theme: AppTheme.lightTheme,
      themeMode: ThemeMode.light,

      // ── Localization delegates (required for Thai text & Material widgets) ──
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('th', 'TH'),
        Locale('en', 'US'),
      ],
      locale: const Locale('th', 'TH'),

      // ── Entry point ──────────────────────────────────────────────────────────
      home: const HomeView(),

      // ── Global scroll behavior (no overscroll glow on Android) ───────────────
      scrollBehavior: const _FarmScrollBehavior(),

      // ── Builder: clamp text scale so Thai layouts don't break ────────────────
      builder: (context, child) {
        final mq = MediaQuery.of(context);
        return MediaQuery(
          data: mq.copyWith(
            textScaler: TextScaler.linear(
              mq.textScaleFactor.clamp(0.85, 1.15),
            ),
          ),
          child: child!,
        );
      },
    );
  }
}

// ─── Custom scroll behavior (stretchy overscroll instead of blue glow) ────────

class _FarmScrollBehavior extends ScrollBehavior {
  const _FarmScrollBehavior();

  @override
  Widget buildOverscrollIndicator(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    return StretchingOverscrollIndicator(
      axisDirection: details.direction,
      child: child,
    );
  }
}
