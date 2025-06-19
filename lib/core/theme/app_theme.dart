import 'package:flutter/material.dart';

class AppTheme {
  // Define a paleta de cores primárias e secundárias

  static ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: const Color(0xFFF1F4F8),
    primaryColor: const Color(0xFF4B39EF),
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF4B39EF),
      secondary: const Color(0xFF39D2C0),
      tertiary: const Color(0xFFEE8B60),
      background: const Color(0xFFF1F4F8),
      surface: const Color(0xFFE0E3E7),
      error: const Color(0xFFFF5963),
    ),
    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: Color(0xFF14181B)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF4B39EF),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        textStyle: TextStyle(
          fontWeight: FontWeight.w600,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Color(0xFFE0E3E7),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      hintStyle: TextStyle(color: Color(0xFF57636C)),
    ), // ... outras configurações de tema
  );

  // Opcional: Tema escuro
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.deepPurple,
    // ... defina as cores e estilos para o tema escuro
  );
}
