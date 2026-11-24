import 'package:flutter/material.dart';

/// Átomo: texto de progreso "Encontradas: x / y".
class TextoContador extends StatelessWidget {
  const TextoContador({
    super.key,
    required this.encontradas,
    required this.total,
  });

  final int encontradas;
  final int total;

  @override
  Widget build(BuildContext context) {
    return Text(
      'Encontradas: $encontradas / $total',
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }
}
