import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GlassTheme {
  static const Color primaryNeon = Color(0xFF00F2FE);
  static const Color secondaryNeon = Color(0xFF4FACFE);
  static const Color accentNeon = Color(0xFFF9D423);
  static const Color dangerNeon = Color(0xFFFF4E50);
  
  static const Color bgDark = Color(0xFF0F172A);
  static const Color glassBg = Color(0x1AFFFFFF); // Translucent background
  static const Color glassBorder = Color(0x33FFFFFF); // Translucent border

  static TextStyle get headerStyle => GoogleFonts.outfit(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.white,
        shadows: [
          Shadow(
            color: primaryNeon.withValues(alpha: 0.5),
            blurRadius: 10,
          ),
        ],
      );

  static TextStyle get subHeaderStyle => GoogleFonts.outfit(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Colors.white70,
      );

  static TextStyle get bodyStyle => GoogleFonts.inter(
        fontSize: 14,
        color: Colors.white.withValues(alpha: 0.9),
      );

  static TextStyle get tableHeaderStyle => GoogleFonts.inter(
        fontSize: 13,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      );

  static TextStyle get tableBodyStyle => GoogleFonts.inter(
        fontSize: 13,
        color: Colors.white70,
      );

  static BoxDecoration get glassDecoration => BoxDecoration(
        color: glassBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: glassBorder, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 16,
            spreadRadius: -4,
          ),
        ],
      );

  static double get blurSigma => 12.0;

  static ImageFilter get glassBlurFilter => ImageFilter.blur(
        sigmaX: blurSigma,
        sigmaY: blurSigma,
      );
}
