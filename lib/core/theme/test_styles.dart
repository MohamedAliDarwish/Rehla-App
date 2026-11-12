import 'package:google_fonts/google_fonts.dart';
import 'package:material_ui/material_ui.dart';

class AppTextStyles {
  static TextStyle get displayLarge =>
      GoogleFonts.cairo(fontSize: 48, fontWeight: FontWeight.bold);

  static TextStyle get displayMedium =>
      GoogleFonts.cairo(fontSize: 36, fontWeight: FontWeight.bold);

  static TextStyle get displaySmall =>
      GoogleFonts.cairo(fontSize: 28, fontWeight: FontWeight.bold);

  static TextStyle get headlineLarge =>
      GoogleFonts.cairo(fontSize: 24, fontWeight: FontWeight.bold);

  static TextStyle get headlineMedium =>
      GoogleFonts.cairo(fontSize: 20, fontWeight: FontWeight.w600);

  static TextStyle get headlineSmall =>
      GoogleFonts.cairo(fontSize: 18, fontWeight: FontWeight.w600);

  static TextStyle get titleLarge =>
      GoogleFonts.cairo(fontSize: 18, fontWeight: FontWeight.w600);

  static TextStyle get titleMedium =>
      GoogleFonts.cairo(fontSize: 16, fontWeight: FontWeight.w600);

  static TextStyle get titleSmall =>
      GoogleFonts.cairo(fontSize: 14, fontWeight: FontWeight.w500);

  static TextStyle get bodyLarge =>
      GoogleFonts.cairo(fontSize: 16, fontWeight: FontWeight.normal);

  static TextStyle get bodyMedium =>
      GoogleFonts.cairo(fontSize: 14, fontWeight: FontWeight.normal);

  static TextStyle get bodySmall =>
      GoogleFonts.cairo(fontSize: 12, fontWeight: FontWeight.normal);

  static TextStyle get labelLarge =>
      GoogleFonts.cairo(fontSize: 14, fontWeight: FontWeight.w600);

  static TextStyle get labelMedium =>
      GoogleFonts.cairo(fontSize: 12, fontWeight: FontWeight.w500);

  static TextStyle get labelSmall =>
      GoogleFonts.cairo(fontSize: 11, fontWeight: FontWeight.w500);
}
