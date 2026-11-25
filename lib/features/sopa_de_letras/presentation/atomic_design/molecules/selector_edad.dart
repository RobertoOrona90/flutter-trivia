import 'package:flutter/material.dart';

import '../../../domain/entities/dificultad_sopa.dart';

/// Molécula: selector de edad con una nota breve que explica
/// que la dificultad depende de la edad.
class SelectorEdad extends StatelessWidget {
  const SelectorEdad({
    super.key,
    required this.edad,
    required this.onChanged,
    this.edadMinima = 4,
    this.edadMaxima = 15,
  });

  final int edad;
  final ValueChanged<int> onChanged;
  final int edadMinima;
  final int edadMaxima;

  static String _nombreDificultad(DificultadSopa d) => switch (d) {
        DificultadSopa.facil => 'Fácil',
        DificultadSopa.media => 'Media',
        DificultadSopa.dificil => 'Difícil',
      };

  @override
  Widget build(BuildContext context) {
    final dificultad = DificultadSopa.porEdad(edad);
    final estiloNota = Theme.of(context).textTheme.bodySmall;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'Edad:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 12),
            DropdownButton<int>(
              value: edad,
              items: [
                for (var e = edadMinima; e <= edadMaxima; e++)
                  DropdownMenuItem(
                    value: e,
                    child: Text(e == edadMaxima ? '$e+ años' : '$e años'),
                  ),
              ],
              onChanged: (valor) {
                if (valor != null) onChanged(valor);
              },
            ),
          ],
        ),
        Text(
          'La dificultad se ajusta a la edad. '
          'Nivel: ${_nombreDificultad(dificultad)}',
          style: estiloNota,
        ),
      ],
    );
  }
}
