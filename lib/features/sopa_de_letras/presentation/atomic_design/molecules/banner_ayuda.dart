import 'package:flutter/material.dart';

/// Molécula: ayuda de primera vez que señala la cápsula de edad.
class BannerAyuda extends StatelessWidget {
  const BannerAyuda({super.key, required this.onCerrar});

  final VoidCallback onCerrar;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Material(
        color: scheme.inverseSurface,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 4, 4, 4),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'Toca aquí para cambiar la edad; '
                  'el nivel se ajusta automáticamente.',
                  style: TextStyle(color: scheme.onInverseSurface),
                ),
              ),
              const SizedBox(width: 8),
              // La cápsula de edad está arriba a la derecha.
              Icon(Icons.north_east, size: 18, color: scheme.onInverseSurface),
              IconButton(
                onPressed: onCerrar,
                tooltip: 'Entendido',
                icon: Icon(Icons.close, color: scheme.onInverseSurface),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
