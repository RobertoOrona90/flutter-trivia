import 'package:flutter/material.dart';

import '../../../domain/entities/dificultad_sopa.dart';
import '../atoms/estilo_nivel.dart';

/// Molécula: tarjeta que explica el nivel, con barra de progreso.
class TarjetaNivel extends StatelessWidget {
  const TarjetaNivel({super.key, required this.nivel});

  final DificultadSopa nivel;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final scheme = tema.colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: nivel.color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: nivel.color.withValues(alpha: 0.45)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: nivel.color,
                foregroundColor: Colors.white,
                child: Icon(nivel.icono),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Nivel ${nivel.nombre}',
                      style: tema.textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      nivel.rango,
                      style: tema.textTheme.labelMedium
                          ?.copyWith(color: scheme.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
              Text(
                '${nivel.index + 1} de ${DificultadSopa.values.length}',
                style: tema.textTheme.labelMedium
                    ?.copyWith(color: scheme.onSurfaceVariant),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              for (final n in DificultadSopa.values)
                Expanded(
                  child: Container(
                    height: 6,
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    decoration: BoxDecoration(
                      color: n.index <= nivel.index
                          ? nivel.color
                          : scheme.outlineVariant,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Text(nivel.descripcion, style: tema.textTheme.bodyMedium),
        ],
      ),
    );
  }
}
