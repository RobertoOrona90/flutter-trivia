import 'package:flutter/material.dart';

/// Átomo: botón de celebración al completar la sopa.
class BotonJugarDeNuevo extends StatelessWidget {
  const BotonJugarDeNuevo({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: const Icon(Icons.celebration),
      label: const Text('¡Completado! Jugar de nuevo'),
    );
  }
}
