import 'package:flutter/material.dart';

/// Átomo: texto de progreso "Encontradas: x / y", o solo "x / y"
/// cuando [conEtiqueta] es `false`.
class TextoContador extends StatelessWidget {
  const TextoContador({
    super.key,
    required this.encontradas,
    required this.total,
    this.conEtiqueta = true,
  });

  final int encontradas;
  final int total;
  final bool conEtiqueta;

  @override
  Widget build(BuildContext context) {
    return Text(
      '${conEtiqueta ? 'Encontradas: ' : ''}$encontradas / $total',
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }
}
