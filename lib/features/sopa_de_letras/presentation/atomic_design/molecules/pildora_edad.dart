import 'package:flutter/material.dart';

import '../../../domain/entities/dificultad_sopa.dart';
import '../atoms/estilo_nivel.dart';

/// Molécula: cápsula compacta con la edad y el nivel. Al tocarla se
/// abre el selector de edad.
class PildoraEdad extends StatelessWidget {
  const PildoraEdad({
    super.key,
    required this.edad,
    required this.onTap,
  });

  final int edad;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final nivel = DificultadSopa.porEdad(edad);
    final tema = Theme.of(context);
    final scheme = tema.colorScheme;
    final estilo = tema.textTheme.labelLarge;

    return Semantics(
      button: true,
      label: 'Edad: $edad años, nivel ${nivel.nombre}. Toca para cambiar.',
      excludeSemantics: true,
      child: Material(
        color: scheme.surface,
        shape: StadiumBorder(side: BorderSide(color: scheme.outlineVariant)),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(14, 8, 8, 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('🎂', style: TextStyle(fontSize: 16)),
                const SizedBox(width: 6),
                Text(
                  '$edad años',
                  style: estilo?.copyWith(fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Text('•', style: estilo),
                ),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  child: Row(
                    key: ValueKey(nivel),
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(nivel.icono, size: 16, color: nivel.color),
                      const SizedBox(width: 4),
                      Text('Nivel ${nivel.nombre}', style: estilo),
                    ],
                  ),
                ),
                const SizedBox(width: 2),
                Icon(Icons.expand_more,
                    size: 20, color: scheme.onSurfaceVariant),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
