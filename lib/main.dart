// =============================================================================
//  lib/main.dart
//  FarmPro – Smart Agriculture Store
//  Entry point: bootstraps providers and launches the app.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'app/app.dart';
import 'controllers/cart_controller.dart';
import 'controllers/home_controller.dart';

void main() async {
  // Ensure Flutter engine is fully initialized before calling native APIs.
  WidgetsFlutterBinding.ensureInitialized();

  // Lock the app to portrait orientation – better UX for farmer use-case.
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Set a transparent status bar so our gradient header bleeds edge-to-edge.
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(
    MultiProvider(
      providers: [
        // Home screen data: banners, categories, products, tips, search
        ChangeNotifierProvider<HomeController>(
          create: (_) => HomeController(),
          lazy: false, // pre-warm so first frame has data
        ),

        // Shopping cart: items, quantities, totals
        ChangeNotifierProvider<CartController>(
          create: (_) => CartController(),
        ),
      ],
      child: const FarmProApp(),
    ),
  );
}
