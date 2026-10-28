import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'splash_welcome.dart';

// ============================================================
// 🔸 الألوان
// ============================================================
class AppColors {
  static const Color primary = Color(0xFFEC563D);
  static const Color primaryDark = Color(0xFFC43E28);
  static const Color primaryLight = Color(0xFFFF8A70);
  static const Color backgroundDark = Color(0xFF150806);
  static const Color backgroundMid = Color(0xFF2A0F0A);
  static const Color backgroundLight = Color(0xFF3D1A12);
  static const Color glassFill = Color(0x1AFFFFFF);
  static const Color glassBorder = Color(0x33FFFFFF);
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Color(0xCCFFFFFF);
  static const Color textMuted = Color(0x99FFFFFF);
  static const Color facebookBlue = Color(0xFF1877F2);
  static const Color googleRed = Color(0xFFDB4437);
  static const Color whatsappGreen = Color(0xFF25D366);
}

// ============================================================
// 🔸 main
// ============================================================
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
  ));
  runApp(const WikalatyApp());
}

class WikalatyApp extends StatelessWidget {
  const WikalatyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'وكالتي',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.backgroundDark,
        colorScheme: const ColorScheme.dark(
          primary: AppColors.primary,
          secondary: AppColors.primaryLight,
        ),
        textTheme: GoogleFonts.cairoTextTheme(ThemeData.dark().textTheme),
      ),
      locale: const Locale('ar', 'IQ'),
      builder: (context, child) => Directionality(
        textDirection: TextDirection.rtl,
        child: child ?? const SizedBox.shrink(),
      ),
      home: const SplashScreen(),
    );
  }
}