import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_stock/app/ui/_themes/colors.dart';

abstract final class AppTextStyles {
  static TextStyle get titleExtraLarge => GoogleFonts.rubik(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    letterSpacing: -1.0,
  );

  static TextStyle get titleLarge => GoogleFonts.rubik(
    fontSize: 26,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    letterSpacing: -1.0,
  );

  static TextStyle get titleMedium => GoogleFonts.rubik(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    letterSpacing: -1.0,
  );

  static TextStyle get titleSmall => GoogleFonts.rubik(
    fontSize: 20,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
    letterSpacing: -1.0,
  );

  static TextStyle get bodyLarge => GoogleFonts.rubik(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    letterSpacing: -1.0,
  );

  static TextStyle get titleExtraSmall => GoogleFonts.rubik(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    letterSpacing: -1.0,
  );

  static TextStyle get bodyMedium => GoogleFonts.rubik(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
  );

  static TextStyle get bodySmall => GoogleFonts.rubik(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
  );
}
