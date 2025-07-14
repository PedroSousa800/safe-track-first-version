// lib/pin_input_display.dart

import 'package:flutter/material.dart';


class PinInputDisplay extends StatelessWidget {
  final int pinLength; // Quantos dígitos já foram inseridos
  final int maxLength; // Comprimento total do PIN (ex: 4 ou 6)
  final Color filledColor; // Cor para as bolinhas preenchidas
  final Color emptyColor; // Cor para as bolinhas vazias

  const PinInputDisplay({
    super.key,
    required this.pinLength,
    this.maxLength = 4, // Padrão para um PIN de 4 dígitos
    required this.filledColor, // Agora é obrigatório passar a cor
    required this.emptyColor, // Agora é obrigatório passar a cor
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center, // Centraliza as bolinhas horizontalmente
      children: List.generate(maxLength, (index) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 12.0), // Espaçamento entre as bolinhas
          width: 50.0, // Largura da bolinha
          height: 50.0, // Altura da bolinha
          decoration: BoxDecoration(
            shape: BoxShape.rectangle, // Forma retangular
            borderRadius: BorderRadius.circular(5.0), // Borda arredondada para bolinhas
            color: index < pinLength
                ? filledColor.withOpacity(0.4) // Bolinha preenchida se o índice for menor que o comprimento do PIN
                : emptyColor.withOpacity(0.4), // Bolinha vazia (com opacidade para ser mais suave)
            border: Border.all(
              color: emptyColor.withOpacity(0.6), // Borda mais suave para bolinhas vazias
              width: 2.0,
            ),
          ),
        );
      }),
    );
  }
}