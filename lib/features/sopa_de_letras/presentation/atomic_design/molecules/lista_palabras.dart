import 'package:flutter/material.dart';

import '../atoms/chip_palabra.dart';

/// Molécula: todas las palabras objetivo con su estado.
class ListaPalabras extends StatelessWidget {
  const ListaPalabras({
    super.key,
    required this.palabras,
    required this.encontradas,
  });

  final List<String> palabras;
  final Set<String> encontradas;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      alignment: WrapAlignment.center,
      children: [
        for (final palabra in palabras)
          ChipPalabra(
            palabra: palabra,
            encontrada: encontradas.contains(palabra),
          ),
      ],
    );
  }
}
