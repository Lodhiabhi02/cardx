import 'package:cardx/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData.light().copyWith(
    colorScheme: ColorScheme.fromSeed(
      seedColor: Color.fromARGB(255, 240, 240, 245),
    ),
  );

  static ThemeData darkTheme = ThemeData.dark().copyWith(
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppPalette.background,
    ),
    scaffoldBackgroundColor: AppPalette.background,

    appBarTheme: AppBarTheme().copyWith(
      backgroundColor: AppPalette.background,
      // elevation: 0, // controls the shadow
      iconTheme: IconThemeData(color: AppPalette.white),
    ),
    inputDecorationTheme: InputDecorationTheme().copyWith(
      hintStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: AppPalette.boderColor),
      ),
    ),
    // textTheme: GoogleFonts.latoTextTheme().copyWith(
    //   titleLarge: GoogleFonts.lato(color: AppPalette.textWhite),
    //   titleMedium: GoogleFonts.lato(color: AppPalette.textWhite),
    // ),
  );
}
