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

  Widget _buildButton(BuildContext context, String text, {IconData? icon, VoidCallback? onPressed}) {
    // Definir as cores base para os botões numéricos
    Color buttonBackgroundColor = AppTheme.alternateBrand;
    Color buttonForegroundColor = AppTheme.primaryBrand.withOpacity(0.8);
    
    // Altera as cores para os botões especiais (biometria e backspace)
    //if (icon == Icons.fingerprint || icon == Icons.backspace_outlined) {
      // Usar as cores do seu tema para os botões especiais
    //  buttonBackgroundColor = Theme.of(context).colorScheme.secondary.withOpacity(0.1);
    //  buttonForegroundColor = Theme.of(context).colorScheme.secondary;
    //}

    // A lógica para desabilitar o botão. `null` desabilita o botão.
    final effectiveOnPressed = isLoading ? null : onPressed;

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: AspectRatio(
          aspectRatio: 1, // Torna o botão quadrado
          child: TextButton(
            onPressed: effectiveOnPressed,
            style: ButtonStyle(
              shape: WidgetStateProperty.all(const CircleBorder()),
              padding: WidgetStateProperty.all(EdgeInsets.zero),
              // Use WidgetStateProperty.all para forçar a cor de fundo e de primeiro plano
              backgroundColor: WidgetStateProperty.all(buttonBackgroundColor),
              foregroundColor: WidgetStateProperty.all(buttonForegroundColor),
              overlayColor: WidgetStateProperty.all(buttonForegroundColor.withOpacity(0.1)),
              elevation: WidgetStateProperty.all(0),
              shadowColor: WidgetStateProperty.all(Colors.transparent),
            ),
            child: icon != null
                ? Icon(
                    icon,
                    size: 36, // Tamanho do ícone para melhor visibilidade
                    color: buttonForegroundColor, // Usar a cor definida
                  )
                : Text(
                    text,
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w400,
                      color: buttonForegroundColor, // Usar a cor definida
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
                _buildButton(context, '', icon: Icons.fingerprint, onPressed: onBiometricsPressed),
                _buildButton(context, '0', onPressed: () => onDigitPressed('0')),
                _buildButton(context, '', icon: Icons.backspace_outlined, onPressed: onBackspacePressed),
              ],
            ),
          ],
        ),
      ),
    );
  }
}