import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTextTheme {
  static TextTheme theme = TextTheme(
    // 헤드라인
    displayLarge: GoogleFonts.notoSansKr(
      fontSize: 22,
      fontWeight: FontWeight.bold,
      letterSpacing: -1.0,
    ),
    displayMedium: GoogleFonts.notoSansKr(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      letterSpacing: -0.5,
    ),
    displaySmall: GoogleFonts.notoSansKr(
      fontSize: 18,
      fontWeight: FontWeight.bold,
    ),

    // 본문
    bodyLarge: GoogleFonts.notoSansKr(
      fontSize: 16,
      fontWeight: FontWeight.normal,
      letterSpacing: 0.5,
      height: 1.5,
    ),
    bodyMedium: GoogleFonts.notoSansKr(
      fontSize: 14,
      fontWeight: FontWeight.normal,
      letterSpacing: 0.25,
      height: 1.4,
    ),
    bodySmall: GoogleFonts.notoSansKr(
      fontSize: 12,
      fontWeight: FontWeight.normal,
      letterSpacing: 0.2,
      height: 1.3,
    ),

    // 레이블
    labelLarge: GoogleFonts.notoSansKr(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.1,
    ),
    labelMedium: GoogleFonts.notoSansKr(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.5,
    ),
    labelSmall: GoogleFonts.notoSansKr(
      fontSize: 11,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.5,
    ),
  );
}
