import 'package:flutter/material.dart';

class AppColors {
  // الألوان الأساسية
  static const Color primary = Color(0xFFEC563D);
  static const Color primaryDark = Color(0xFFC43E28);
  static const Color primaryLight = Color(0xFFFF8A70);

  // خلفيات
  static const Color backgroundDark = Color(0xFF150806);
  static const Color backgroundMid = Color(0xFF2A0F0A);
  static const Color backgroundLight = Color(0xFF3D1A12);

  // زجاج
  static const Color glassFill = Color(0x1AFFFFFF);      // 10%
  static const Color glassFillSoft = Color(0x0DFFFFFF);  // 5%
  static const Color glassBorder = Color(0x33FFFFFF);    // 20%

  // نصوص
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Color(0xCCFFFFFF);
  static const Color textMuted = Color(0x99FFFFFF);

  // شبكات التواصل
  static const Color facebookBlue = Color(0xFF1877F2);
  static const Color googleRed = Color(0xFFDB4437);
  static const Color whatsappGreen = Color(0xFF25D366);

  // ظلال
  static Color get primaryGlow => primary.withOpacity(0.35);
}