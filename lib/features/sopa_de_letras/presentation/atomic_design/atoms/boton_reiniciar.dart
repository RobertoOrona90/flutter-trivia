import 'package:flutter/material.dart';

/// Átomo: botón de ícono para generar un tablero nuevo.
class BotonReiniciar extends StatelessWidget {
  const BotonReiniciar({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: const Icon(Icons.refresh),
      tooltip: 'Nuevo tablero',
    );
  }
}
