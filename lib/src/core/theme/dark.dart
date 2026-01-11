import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.deepPurple,
    brightness: Brightness.dark,
  ),
  textTheme: GoogleFonts.interTextTheme(),
);
