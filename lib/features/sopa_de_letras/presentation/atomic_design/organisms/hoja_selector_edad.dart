import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../domain/entities/dificultad_sopa.dart';
import '../atoms/estilo_nivel.dart';
import '../molecules/tarjeta_nivel.dart';

/// Abre el selector y devuelve la edad elegida, o `null` si se cerró sin elegir.
Future<int?> mostrarSelectorEdad(
  BuildContext context, {
  required int edadActual,
}) {
  return showModalBottomSheet<int>(
    context: context,
    showDragHandle: true,
    useSafeArea: true,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
    ),
    builder: (_) => HojaSelectorEdad(edadInicial: edadActual),
  );
}

/// Organismo: hoja inferior con ruleta de edad y vista previa del nivel.
class HojaSelectorEdad extends StatefulWidget {
  const HojaSelectorEdad({super.key, required this.edadInicial});

  final int edadInicial;

  @override
  State<HojaSelectorEdad> createState() => _HojaSelectorEdadState();
}

class _HojaSelectorEdadState extends State<HojaSelectorEdad> {
  late int _edad = widget.edadInicial.clamp(kEdadMinima, kEdadMaxima);
  late final FixedExtentScrollController _controlador =
      FixedExtentScrollController(initialItem: _edad - kEdadMinima);

  @override
  void dispose() {
    _controlador.dispose();
    super.dispose();
  }

  void _alCambiar(int indice) {
    final nuevaEdad = indice + kEdadMinima;
    final cambiaNivel =
        DificultadSopa.porEdad(nuevaEdad) != DificultadSopa.porEdad(_edad);

    // Clic suave en cada edad; uno más marcado cuando cambia el nivel.
    cambiaNivel
        ? HapticFeedback.mediumImpact()
        : HapticFeedback.selectionClick();

    setState(() => _edad = nuevaEdad);
  }

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final nivel = DificultadSopa.porEdad(_edad);

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            '¿Cuántos años tienes?',
            style: tema.textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            'El nivel se ajusta automáticamente a tu edad.',
            style: tema.textTheme.bodyMedium?.copyWith(
              color: tema.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 150,
            child: CupertinoPicker(
              scrollController: _controlador,
              itemExtent: 40,
              magnification: 1.15,
              useMagnifier: true,
              squeeze: 1.1,
              selectionOverlay: CupertinoPickerDefaultSelectionOverlay(
                background: nivel.color.withValues(alpha: 0.14),
              ),
              onSelectedItemChanged: _alCambiar,
              children: [
                for (var e = kEdadMinima; e <= kEdadMaxima; e++)
                  Center(
                    child: Text(
                      '$e años',
                      style: TextStyle(
                        fontSize: 20,
                        color: tema.colorScheme.onSurface,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          AnimatedSize(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOut,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              switchInCurve: Curves.easeOut,
              switchOutCurve: Curves.easeIn,
              transitionBuilder: (child, animacion) => FadeTransition(
                opacity: animacion,
                child: ScaleTransition(
                  scale: Tween(begin: 0.95, end: 1.0).animate(animacion),
                  child: child,
                ),
              ),
              child: TarjetaNivel(key: ValueKey(nivel), nivel: nivel),
            ),
          ),
          const SizedBox(height: 20),
          FilledButton(
            onPressed: () => Navigator.pop(context, _edad),
            child: Text('Listo: $_edad años'),
          ),
        ],
      ),
    );
  }
}
