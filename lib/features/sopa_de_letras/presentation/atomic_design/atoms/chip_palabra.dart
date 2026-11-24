import 'package:flutter/material.dart';

/// Átomo: una palabra objetivo, tachada cuando ya se encontró.
class ChipPalabra extends StatelessWidget {
  const ChipPalabra({
    super.key,
    required this.palabra,
    required this.encontrada,
  });

  final String palabra;
  final bool encontrada;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: null,
      style: ElevatedButton.styleFrom(
        disabledBackgroundColor:
            encontrada ? Colors.green : Colors.grey.shade700,
        disabledForegroundColor:
            encontrada ? Colors.white : Colors.grey.shade300,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Text(
        palabra,
        style: TextStyle(
          decoration: encontrada ? TextDecoration.lineThrough : null,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
