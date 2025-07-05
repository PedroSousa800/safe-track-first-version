import 'package:flutter/material.dart';

class AppTheme {
  // Cores da paleta "Light Mode Theme"
  // Adicionando 'FF' para o canal alfa (opacidade total) em todas as cores
  // Brand Colors
  static const Color primaryBrand = Color(0xFF4B39EF); // Primary
  static const Color secondaryBrand = Color(0xFF39D2C0); // Secondary
  static const Color tertiaryBrand = Color(0xFFEE8B60); // Tertiary
  static const Color alternateBrand = Color(0xFFE0E3E7); // Alternate

  // Utility Colors
  static const Color primaryText = Color(0xFF14181B); // Primary Text
  static const Color secondaryText = Color(0xFF57636C); // Secondary Text
  static const Color primaryBackground = Color(0xFFF1F4F8); // Primary Background (um cinza claro)
  static const Color secondaryBackground = Color(0xFFFFFFFF); // Secondary Background (White)

  // Accent Colors
  static const Color accent1 = Color(0x4C4B39EF);
  static const Color accent2 = Color(0x4D39D2C0);
  static const Color accent3 = Color(0x4DEE8B60);
  static const Color accent4 = Color(0xCCFFFFFF); 

  // Semantic Colors
  static const Color successColor = Color(0xFF249689); // Success
  static const Color errorColor = Color(0xFFFD5963); // Error
  static const Color warningColor = Color(0xFFF9CF58); // Warning
  static const Color infoColor = Color(0xFF14181B); // Info (igual ao primaryText no exemplo)

  // -- Tema Claro --
  static ThemeData lightTheme = ThemeData(
    // Definições básicas do tema
    brightness: Brightness.light,
    primaryColor: primaryBrand, // O azul mais forte
    // Usa secondaryBackground (branco) para o fundo principal do Scaffold
    scaffoldBackgroundColor: secondaryBackground,
    hintColor: secondaryText, // Cor para textos de dica (placeholders)

    // Esquema de cores principal para ColorScheme
    colorScheme: const ColorScheme.light( // Adicionado 'const' aqui
      primary: primaryBrand,
      onPrimary: secondaryBackground, // Texto em cima da cor primária
      secondary: secondaryBrand, // O verde água
      onSecondary: primaryText, // Texto em cima da cor secundária
      tertiary: tertiaryBrand, // O laranja

      // CORREÇÃO: Usando 'surface' e 'onSurface' no lugar de 'background' e 'onBackground'
      surface: primaryBackground, // Fundo principal dos elementos como Cards, Sheets
      onSurface: primaryText, // Texto sobre superfícies
      
      // As cores 'background' e 'onBackground' dentro de ColorScheme não são mais usadas
      // para definir o fundo geral da aplicação. scaffoldBackgroundColor faz isso.
      // Se você quiser uma cor de background específica que não seja a "surface",
      // pode ser o primaryBackground (F1F4F8) ou secondaryBackground (FFFFFF)
      // dependendo do que você quer como fundo padrão da tela e de cards/dialogos.
      // O scaffoldBackgroundColor já cuida do fundo da tela.

      error: errorColor, // Cor para erros
      onError: secondaryBackground, // Texto sobre erros
    ),

    // Configurações da AppBar
    appBarTheme: const AppBarTheme( // Adicionado 'const' aqui
      color: primaryBrand, // Fundo da AppBar
      foregroundColor: secondaryBackground, // Cor dos ícones e título na AppBar
      elevation: 0, // Sem sombra na AppBar
      iconTheme: IconThemeData(color: secondaryBackground), // Adicionado 'const' aqui
      actionsIconTheme: IconThemeData(color: secondaryBackground), // Adicionado 'const' aqui
      titleTextStyle: TextStyle( // Adicionado 'const' aqui
        color: secondaryBackground,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
    ),

    // Configurações para TextFields (campos de entrada)
    inputDecorationTheme: const InputDecorationTheme( // Adicionado 'const' aqui
      filled: true,
      fillColor: primaryBackground, // Fundo do campo de texto
      labelStyle: TextStyle(color: secondaryText), // Adicionado 'const' aqui
      hintStyle: TextStyle(color: secondaryText), // Adicionado 'const' aqui, e remova o .withOpacity
      floatingLabelStyle: TextStyle(color: primaryBrand), // Adicionado 'const' aqui
      border: OutlineInputBorder( // Adicionado 'const' aqui
        borderRadius: BorderRadius.all(Radius.circular(8.0)), // Adicionado 'const' aqui
        borderSide: BorderSide(color: alternateBrand, width: 1.0), // Adicionado 'const' aqui
      ),
      enabledBorder: OutlineInputBorder( // Adicionado 'const' aqui
        borderRadius: BorderRadius.all(Radius.circular(8.0)), // Adicionado 'const' aqui
        borderSide: BorderSide(color: alternateBrand, width: 1.0), // Adicionado 'const' aqui
      ),
      focusedBorder: OutlineInputBorder( // Adicionado 'const' aqui
        borderRadius: BorderRadius.all(Radius.circular(8.0)), // Adicionado 'const' aqui
        borderSide: BorderSide(color: primaryBrand, width: 2.0), // Adicionado 'const' aqui
      ),
      errorBorder: OutlineInputBorder( // Adicionado 'const' aqui
        borderRadius: BorderRadius.all(Radius.circular(8.0)), // Adicionado 'const' aqui
        borderSide: BorderSide(color: errorColor, width: 1.0), // Adicionado 'const' aqui
      ),
      focusedErrorBorder: OutlineInputBorder( // Adicionado 'const' aqui
        borderRadius: BorderRadius.all(Radius.circular(8.0)), // Adicionado 'const' aqui
        borderSide: BorderSide(color: errorColor, width: 2.0), // Adicionado 'const' aqui
      ),
      contentPadding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0), // Adicionado 'const' aqui
    ),

    // Configurações de Botões (ElevatedButton)
    elevatedButtonTheme: ElevatedButtonThemeData( // Adicionado 'const' aqui
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryBrand, // Fundo do botão
        foregroundColor: secondaryBackground, // Cor do texto/ícone no botão
        shape: const RoundedRectangleBorder( // Adicionado 'const' aqui
          borderRadius: BorderRadius.all(Radius.circular(8.0)), // Adicionado 'const' aqui
        ),
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0), // Adicionado 'const' aqui
        textStyle: const TextStyle( // Adicionado 'const' aqui
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),

    // Configurações de Texto (tipografia)
    textTheme: const TextTheme( // Adicionado 'const' aqui
      // Títulos grandes (para cabeçalhos de tela, por exemplo)
      headlineLarge: TextStyle(color: primaryText, fontSize: 32, fontWeight: FontWeight.bold),
      headlineMedium: TextStyle(color: primaryText, fontSize: 28, fontWeight: FontWeight.bold),
      headlineSmall: TextStyle(color: primaryText, fontSize: 24, fontWeight: FontWeight.bold),

      // Títulos menores ou subtítulos
      titleLarge: TextStyle(color: primaryText, fontSize: 20, fontWeight: FontWeight.w600),
      titleMedium: TextStyle(color: primaryText, fontSize: 18, fontWeight: FontWeight.w600),
      titleSmall: TextStyle(color: secondaryText, fontSize: 16, fontWeight: FontWeight.w500),

      // Corpo de texto principal
      bodyLarge: TextStyle(color: primaryText, fontSize: 16),
      bodyMedium: TextStyle(color: secondaryText, fontSize: 14),
      bodySmall: TextStyle(color: secondaryText, fontSize: 12),

      // Estilos para botões, labels de formulários etc.
      labelLarge: TextStyle(color: secondaryBackground, fontSize: 18, fontWeight: FontWeight.w600),
      labelMedium: TextStyle(color: secondaryText, fontSize: 14),
      labelSmall: TextStyle(color: secondaryText, fontSize: 12),
    ),

    // ... outras configurações de tema conforme necessário
  );

  // -- Tema Escuro (implementação similar, ajustando as cores Dark Mode Theme) --
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: primaryBrand,
    scaffoldBackgroundColor: const Color(0xFF1D2428),
    // ... defina as cores e estilos para o tema escuro usando a seção "Dark Mode Theme" da sua imagem
  );
}