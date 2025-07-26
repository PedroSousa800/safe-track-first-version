// lib/features/auth/widgets/custom_pin_pad.dart

import 'package:first_version/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

class CustomPinPad extends StatelessWidget {
  final ValueChanged<String> onDigitPressed;
  final VoidCallback onBackspacePressed;
  final VoidCallback onBiometricsPressed;
  final bool isLoading;

  const CustomPinPad({
    super.key,
    required this.onDigitPressed,
    required this.onBackspacePressed,
    required this.onBiometricsPressed,
    this.isLoading = false,
  });

  Widget _buildButton(BuildContext context, String text, {IconData? icon, VoidCallback? onPressed, bool isSpecial = false}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: AspectRatio(
          aspectRatio: 1, // Torna o botão quadrado, mantendo a proporção
          child: ElevatedButton(
            onPressed: isLoading ? null : onPressed,
            style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
              padding: EdgeInsets.zero,
              backgroundColor: isSpecial
                  ? Theme.of(context).colorScheme.secondary.withOpacity(0.1) // Usar Theme.of(context) para cores do tema
                  : AppTheme.alternateBrand, 
              foregroundColor: isSpecial
                  ? Theme.of(context).colorScheme.secondary // Usar Theme.of(context) para cores do tema
                  : Theme.of(context).colorScheme.onSurface, // Usar Theme.of(context) para cores do tema
              elevation: 0, // Remove a elevação
              shadowColor: Colors.transparent, // Remove a sombra
            ),
            child: icon != null
                ? Icon(
                    icon,
                    size: 36, // Tamanho do ícone para melhor visibilidade
                    color: AppTheme.primaryBrand.withOpacity(0.8), // Usar AppTheme diretamente
                  )
                : Text(
                    text,
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w400,
                      color: isSpecial
                          ? Theme.of(context).colorScheme.secondary // Usar Theme.of(context) para cores do tema
                          : AppTheme.primaryBrand.withOpacity(0.8)
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: AbsorbPointer(
        absorbing: isLoading, // Desabilita o teclado se estiver carregando
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildButton(context, '1', onPressed: () => onDigitPressed('1')),
                _buildButton(context, '2', onPressed: () => onDigitPressed('2')),
                _buildButton(context, '3', onPressed: () => onDigitPressed('3')),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildButton(context, '4', onPressed: () => onDigitPressed('4')),
                _buildButton(context, '5', onPressed: () => onDigitPressed('5')),
                _buildButton(context, '6', onPressed: () => onDigitPressed('6')),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildButton(context, '7', onPressed: () => onDigitPressed('7')),
                _buildButton(context, '8', onPressed: () => onDigitPressed('8')),
                _buildButton(context, '9', onPressed: () => onDigitPressed('9')),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildButton(context, '', icon: Icons.fingerprint, onPressed: onBiometricsPressed, isSpecial: false),
                _buildButton(context, '0', onPressed: () => onDigitPressed('0')),
                _buildButton(context, '', icon: Icons.backspace_outlined, onPressed: onBackspacePressed, isSpecial: false),
              ],
            ),
          ],
        ),
      ),
    );
  }
}