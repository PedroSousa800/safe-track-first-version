// lib/core/theme/app_theme.dart

import 'package:flutter/material.dart';

// ESTA CLASSE PRECISA ESTAR AQUI! É a extensão de tema que define suas cores personalizadas.
class _AppColors extends ThemeExtension<_AppColors> {
  final Color? primaryBrand;
  final Color? secondaryBrand;
  final Color? tertiaryBrand;
  final Color? alternateBrand;
  final Color? primaryText;
  final Color? secondaryText;
  final Color? primaryBackground;
  final Color? secondaryBackground;
  final Color? accent1;
  final Color? accent2;
  final Color? accent3;
  final Color? accent4;
  final Color? successColor;
  final Color? errorColor;
  final Color? warningColor;
  final Color? infoColor;

  const _AppColors({
    this.primaryBrand,
    this.secondaryBrand,
    this.tertiaryBrand,
    this.alternateBrand,
    this.primaryText,
    this.secondaryText,
    this.primaryBackground,
    this.secondaryBackground,
    this.accent1,
    this.accent2,
    this.accent3,
    this.accent4,
    this.successColor,
    this.errorColor,
    this.warningColor,
    this.infoColor,
  });

  @override
  _AppColors copyWith({
    Color? primaryBrand,
    Color? secondaryBrand,
    Color? tertiaryBrand,
    Color? alternateBrand,
    Color? primaryText,
    Color? secondaryText,
    Color? primaryBackground,
    Color? secondaryBackground,
    Color? accent1,
    Color? accent2,
    Color? accent3,
    Color? accent4,
    Color? successColor,
    Color? errorColor,
    Color? warningColor,
    Color? infoColor,
  }) {
    return _AppColors(
      primaryBrand: primaryBrand ?? this.primaryBrand,
      secondaryBrand: secondaryBrand ?? this.secondaryBrand,
      tertiaryBrand: tertiaryBrand ?? this.tertiaryBrand,
      alternateBrand: alternateBrand ?? this.alternateBrand,
      primaryText: primaryText ?? this.primaryText,
      secondaryText: secondaryText ?? this.secondaryText,
      primaryBackground: primaryBackground ?? this.primaryBackground,
      secondaryBackground: secondaryBackground ?? this.secondaryBackground,
      accent1: accent1 ?? this.accent1,
      accent2: accent2 ?? this.accent2,
      accent3: accent3 ?? this.accent3,
      accent4: accent4 ?? this.accent4,
      successColor: successColor ?? this.successColor,
      errorColor: errorColor ?? this.errorColor,
      warningColor: warningColor ?? this.warningColor,
      infoColor: infoColor ?? this.infoColor,
    );
  }

  @override
  _AppColors lerp(ThemeExtension<_AppColors>? other, double t) {
    if (other is! _AppColors) {
      return this;
    }
    return _AppColors(
      primaryBrand: Color.lerp(primaryBrand, other.primaryBrand, t),
      secondaryBrand: Color.lerp(secondaryBrand, other.secondaryBrand, t),
      tertiaryBrand: Color.lerp(tertiaryBrand, other.tertiaryBrand, t),
      alternateBrand: Color.lerp(alternateBrand, other.alternateBrand, t),
      primaryText: Color.lerp(primaryText, other.primaryText, t),
      secondaryText: Color.lerp(secondaryText, other.secondaryText, t),
      primaryBackground: Color.lerp(primaryBackground, other.primaryBackground, t),
      secondaryBackground: Color.lerp(secondaryBackground, other.secondaryBackground, t),
      accent1: Color.lerp(accent1, other.accent1, t),
      accent2: Color.lerp(accent2, other.accent2, t),
      accent3: Color.lerp(accent3, other.accent3, t),
      accent4: Color.lerp(accent4, other.accent4, t),
      successColor: Color.lerp(successColor, other.successColor, t),
      errorColor: Color.lerp(errorColor, other.errorColor, t),
      warningColor: Color.lerp(warningColor, other.warningColor, t),
      infoColor: Color.lerp(infoColor, other.infoColor, t),
    );
  }
}

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
  static const Color primaryBackground =
      Color(0xFFF1F4F8); // Primary Background (um cinza claro)
  static const Color secondaryBackground =
      Color(0xFFFFFFFF); // Secondary Background (White)

  // Accent Colors
  static const Color accent1 = Color(0x4C4B39EF);
  static const Color accent2 = Color(0x4D39D2C0);
  static const Color accent3 = Color(0x4DEE8B60);
  static const Color accent4 = Color(0xCCFFFFFF);

  // Semantic Colors
  static const Color successColor = Color(0xFF249689); // Success
  static const Color errorColor = Color(0xFFE63E2A); // Error
  static const Color warningColor = Color(0xFFF9CF58); // Warning
  static const Color infoColor = Color(
      0xFFFFFFFF); // Info (geralmente branco para texto em fundos coloridos)

  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: primaryBrand,
    scaffoldBackgroundColor: primaryBackground,
    // ADICIONE A EXTENSÃO _AppColors AQUI!
    extensions: const <ThemeExtension<dynamic>>[
      _AppColors(
        primaryBrand: primaryBrand,
        secondaryBrand: secondaryBrand,
        tertiaryBrand: tertiaryBrand,
        alternateBrand: alternateBrand,
        primaryText: primaryText,
        secondaryText: secondaryText,
        primaryBackground: primaryBackground,
        secondaryBackground: secondaryBackground,
        accent1: accent1,
        accent2: accent2,
        accent3: accent3,
        accent4: accent4,
        successColor: successColor,
        errorColor: errorColor,
        warningColor: warningColor,
        infoColor: infoColor,
      ),
    ],
    // Configuração do tema para ElevatedButton (para botões normais)
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryBrand, // Cor de fundo principal da marca
        foregroundColor: secondaryBackground, // Cor do texto/ícone (branco)
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
              Radius.circular(8.0)), // Bordas levemente arredondadas
        ),
        padding: const EdgeInsets.symmetric(
            vertical: 16.0, horizontal: 24.0), // Padding padrão
        textStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        elevation: 2, // Leve elevação para botões
        shadowColor: Colors.black.withOpacity(0.1), // Sombra suave
      ),
    ),
    // Configuração do tema para TextButton (para o teclado PIN plano)
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        shape: const CircleBorder(), // Botões circulares para o PIN pad
        padding:
            EdgeInsets.zero, // Padding zero, o AspectRatio cuidará do tamanho
        backgroundColor: Colors
            .grey.shade100, // Cor de fundo padrão para os botões numéricos
        foregroundColor: primaryText, // Cor do texto/ícone
        textStyle: const TextStyle(
          fontSize: 32, // Tamanho maior para os dígitos
          fontWeight: FontWeight.normal,
        ),
        // Removendo qualquer elevação e sombra para um visual plano
        elevation: 0,
        shadowColor: Colors.transparent,
      ),
    ),
    // Define um tema de ícones padrão se necessário
    iconTheme: const IconThemeData(
      color: primaryText, // Cor padrão para ícones
      size: 24,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: primaryBrand, // <--- Mude para primaryBrand
      foregroundColor:
          secondaryBackground, // <--- Provavelmente você vai querer o texto/ícones brancos sobre o fundo azul
      elevation: 0, // Mantenha 0 se não quiser sombra
      centerTitle: true,
      titleTextStyle: TextStyle(
        color:
            secondaryBackground, // <--- Mude para secondaryBackground para o texto ser branco
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
      iconTheme: IconThemeData(
        color:
            secondaryBackground, // <--- Mude para secondaryBackground para os ícones serem brancos
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true, // Campo preenchido
      fillColor: secondaryBackground, // Fundo branco
      contentPadding: const EdgeInsets.symmetric(
          vertical: 16.0, horizontal: 20.0), // Padding interno
      border: OutlineInputBorder(
        // Borda padrão
        borderRadius: BorderRadius.circular(8.0), // Bordas arredondadas
        borderSide: const BorderSide(
          color: alternateBrand, // Borda fina e discreta
          width: 1.0,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        // Borda quando o campo está habilitado
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(
          color: alternateBrand, // Cor da borda
          width: 1.0, // Espessura da borda
        ),
      ),
      focusedBorder: OutlineInputBorder(
        // Borda quando o campo está focado
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(
          color:
              primaryBrand, // Cor da borda quando focado (pode ser sua primaryBrand)
          width: 2.0, // Um pouco mais grossa para indicar foco
        ),
      ),
      labelStyle: const TextStyle(
        // Estilo do texto do label (quando não focado)
        color: secondaryText, // Cinza para o label
        fontSize: 16,
      ),
      floatingLabelStyle: const TextStyle(
        // Estilo do texto do label (quando flutua)
        color: primaryText, // Preto/azul escuro para o label flutuante
        fontSize: 14,
      ),
      hintStyle: const TextStyle(
        // Estilo do texto de hint (placeholder)
        color: secondaryText, // Cinza para o hint
        fontSize: 16,
      ),
      errorStyle: const TextStyle(
        // Estilo do texto de erro
        color: errorColor, // Cor de erro
        fontSize: 12,
      ),
    ),
    textTheme: const TextTheme(
      // Títulos maiores
      displayLarge: TextStyle(
          color: primaryText, fontSize: 57, fontWeight: FontWeight.bold),
      displayMedium: TextStyle(
          color: primaryText, fontSize: 45, fontWeight: FontWeight.bold),
      displaySmall: TextStyle(
          color: primaryText, fontSize: 36, fontWeight: FontWeight.bold),

      // Títulos médios
      headlineLarge: TextStyle(
          color: primaryText, fontSize: 32, fontWeight: FontWeight.bold),
      headlineMedium: TextStyle(
          color: primaryText, fontSize: 28, fontWeight: FontWeight.bold),
      headlineSmall: TextStyle(
          color: primaryText, fontSize: 24, fontWeight: FontWeight.bold),

      // Títulos menores ou subtítulos
      titleLarge: TextStyle(
          color: primaryText, fontSize: 20, fontWeight: FontWeight.w600),
      titleMedium: TextStyle(
          color: primaryText, fontSize: 18, fontWeight: FontWeight.w600),
      titleSmall: TextStyle(
          color: secondaryText, fontSize: 16, fontWeight: FontWeight.w500),

      // Corpo de texto principal
      bodyLarge: TextStyle(color: primaryText, fontSize: 16),
      bodyMedium: TextStyle(color: secondaryText, fontSize: 14),
      bodySmall: TextStyle(color: secondaryText, fontSize: 12),

      // Estilos para botões, labels de formulários etc.
      labelLarge: TextStyle(
          color: secondaryBackground,
          fontSize: 18,
          fontWeight: FontWeight.w600),
      labelMedium: TextStyle(color: secondaryText, fontSize: 14),
      labelSmall: TextStyle(color: secondaryText, fontSize: 12),
    ),
  );

  // -- Tema Escuro (implementação similar, ajustando as cores Dark Mode Theme) --
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: primaryBrand,
    scaffoldBackgroundColor: const Color(0xFF1D2428),
    // ADICIONE A EXTENSÃO _AppColors AQUI TAMBÉM!
    extensions: const <ThemeExtension<dynamic>>[
      _AppColors(
        primaryBrand: primaryBrand,
        secondaryBrand: secondaryBrand,
        tertiaryBrand: tertiaryBrand,
        alternateBrand: alternateBrand,
        primaryText: secondaryBackground, // Exemplo: texto primário branco no modo escuro
        secondaryText: Color(0xFF9AA5AE), // Exemplo: texto secundário cinza claro
        primaryBackground: Color(0xFF1D2428),
        secondaryBackground: Color(0xFF1D2428),
        accent1: accent1,
        accent2: accent2,
        accent3: accent3,
        accent4: accent4,
        successColor: successColor,
        errorColor: errorColor,
        warningColor: warningColor,
        infoColor: infoColor,
      ),
    ],
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryBrand, // Ajuste para o modo escuro
        foregroundColor: secondaryBackground, // Ajuste para o modo escuro
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
        textStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        elevation: 0, // Removido o efeito de elevação no modo escuro
        shadowColor: Colors.transparent, // Sombra transparente no modo escuro
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        shape: const CircleBorder(),
        padding: EdgeInsets.zero,
        backgroundColor: Colors.grey
            .shade800, // Cor de fundo padrão para os botões numéricos no modo escuro
        foregroundColor:
            secondaryBackground, // Cor do texto/ícone no modo escuro
        textStyle: const TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.normal,
        ),
        elevation: 0,
        shadowColor: Colors.transparent,
      ),
    ),
    iconTheme: const IconThemeData(
      color: secondaryBackground, // Cor padrão para ícones no modo escuro
      size: 24,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF1D2428), // Fundo escuro para AppBar
      foregroundColor: secondaryBackground, // Cor do texto e ícones (branco)
      elevation: 0, // Sem sombra
      centerTitle: true, // Centraliza o título
      titleTextStyle: TextStyle(
        color: secondaryBackground,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
      iconTheme: IconThemeData(
        color: secondaryBackground,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(
          0xFF2D3740), // Um cinza mais escuro para o fundo do campo no tema escuro
      contentPadding:
          const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(
          color: Color(0xFF4B5563), // Borda discreta no tema escuro
          width: 1.0,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(
          color: Color(0xFF4B5563),
          width: 1.0,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(
          color: primaryBrand, // Cor da borda quando focado (sua primaryBrand)
          width: 2.0,
        ),
      ),
      labelStyle: const TextStyle(
        color: Color(
            0xFF9AA5AE), // Cinza mais claro para o label no tema escuro
        fontSize: 16,
      ),
      floatingLabelStyle: const TextStyle(
        color:
            secondaryBackground, // Branco para o label flutuante no tema escuro
        fontSize: 14,
      ),
      hintStyle: const TextStyle(
        color: Color(0xFF9AA5AE),
        fontSize: 16,
      ),
      errorStyle: const TextStyle(
        color: errorColor,
        fontSize: 12,
      ),
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(
          color: secondaryBackground,
          fontSize: 57,
          fontWeight: FontWeight.bold),
      displayMedium: TextStyle(
          color: secondaryBackground,
          fontSize: 45,
          fontWeight: FontWeight.bold),
      displaySmall: TextStyle(
          color: secondaryBackground,
          fontSize: 36,
          fontWeight: FontWeight.bold),

      headlineLarge: TextStyle(
          color: secondaryBackground,
          fontSize: 32,
          fontWeight: FontWeight.bold),
      headlineMedium: TextStyle(
          color: secondaryBackground,
          fontSize: 28,
          fontWeight: FontWeight.bold),
      headlineSmall: TextStyle(
          color: secondaryBackground,
          fontSize: 24,
          fontWeight: FontWeight.bold),

      titleLarge: TextStyle(
          color: secondaryBackground,
          fontSize: 20,
          fontWeight: FontWeight.w600),
      titleMedium: TextStyle(
          color: secondaryBackground,
          fontSize: 18,
          fontWeight: FontWeight.w600),
      titleSmall: TextStyle(
          color: Color(0xFF9AA5AE),
          fontSize: 16,
          fontWeight: FontWeight.w500), // Ajuste para secondaryText escuro

      bodyLarge: TextStyle(color: secondaryBackground, fontSize: 16),
      bodyMedium: TextStyle(
          color: Color(0xFF9AA5AE),
          fontSize: 14), // Ajuste para secondaryText escuro
      bodySmall: TextStyle(
          color: Color(0xFF9AA5AE),
          fontSize: 12), // Ajuste para secondaryText escuro

      labelLarge: TextStyle(
          color: primaryText,
          fontSize: 18,
          fontWeight: FontWeight.w600), // Ajuste para primaryText escuro
      labelMedium: TextStyle(color: Color(0xFF9AA5AE), fontSize: 14),
      labelSmall: TextStyle(color: Color(0xFF9AA5AE), fontSize: 12),
    ),
  );
}