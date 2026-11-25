import 'package:flutter/material.dart';

enum EstadoCelda { normal, seleccionada, resuelta }

/// Átomo: una letra del tablero con su color según el estado.
class LetraCelda extends StatelessWidget {
  const LetraCelda({
    super.key,
    required this.letra,
    this.estado = EstadoCelda.normal,
  });

  final String letra;
  final EstadoCelda estado;

  @override
  Widget build(BuildContext context) {
    final (fondo, texto) = switch (estado) {
      EstadoCelda.seleccionada => (Colors.orange.shade600, Colors.white),
      EstadoCelda.resuelta => (Colors.green.shade400, Colors.white),
      EstadoCelda.normal => (Colors.transparent, Colors.black87),
    };

    return AnimatedContainer(
      duration: const Duration(milliseconds: 120),
      margin: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: fondo,
        borderRadius: BorderRadius.circular(6),
        // Borde negro suave: ni muy delgado ni muy grueso.
        border: Border.all(color: Colors.black87, width: 1.5),
      ),
      alignment: Alignment.center,
      child: Text(
        letra,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: texto,
        ),
      ),
    );
  }
}
