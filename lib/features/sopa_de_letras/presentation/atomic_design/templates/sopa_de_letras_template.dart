import 'package:flutter/material.dart';

/// Plantilla: define la distribución de la pantalla con huecos (slots),
/// sin saber qué widgets concretos se colocan en ellos.
class SopaDeLetrasTemplate extends StatelessWidget {
  const SopaDeLetrasTemplate({
    super.key,
    this.encabezado,
    required this.tablero,
    required this.palabras,
    this.pie,
  });

  final Widget? encabezado;
  final Widget tablero;
  final Widget palabras;
  final Widget? pie;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (encabezado != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: encabezado,
          ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: tablero,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: palabras,
        ),
        if (pie != null)
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: pie,
          ),
      ],
    );
  }
}
