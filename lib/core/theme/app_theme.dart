import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData _base(Color seed, Brightness b) {
    final scheme = ColorScheme.fromSeed(seedColor: seed, brightness: b);
    final textTheme = GoogleFonts.interTextTheme().copyWith(
      titleLarge: GoogleFonts.inter(fontWeight: FontWeight.w700),
    );
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        centerTitle: true,
        backgroundColor: scheme.surface,
        elevation: 0,
      ),
      cardTheme: const CardThemeData(
        margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        clipBehavior: Clip.antiAlias,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: scheme.inverseSurface,
        contentTextStyle: TextStyle(color: scheme.onInverseSurface),
        actionTextColor: scheme.secondary,
      ),
      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(14))),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        shape: StadiumBorder(),
      ),
    );
  }

  static ThemeData lightTheme(Color seed) => _base(seed, Brightness.light);
  static ThemeData darkTheme(Color seed) => _base(seed, Brightness.dark);
}
