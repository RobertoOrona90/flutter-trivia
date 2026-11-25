// Demo independiente: selector de edad compacto con nivel automático.
//
// Ejecutar:  flutter run -t lib/ejemplos/selector_edad_demo.dart
// (o la configuración "Demo - Selector de edad" en VS Code).
//
// 100% widgets nativos de Flutter, sin paquetes externos.

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(const SelectorEdadDemoApp());

const int kEdadMinima = 4;
const int kEdadMaxima = 18;

// ---------------------------------------------------------------------------
// Modelo: niveles por rango de edad
// ---------------------------------------------------------------------------

enum Nivel {
  inicial(
    nombre: 'Inicial',
    edadMinima: 4,
    edadMaxima: 6,
    icono: Icons.child_care,
    color: Color(0xFF43A047),
    descripcion: 'Palabras cortas de 4 a 5 letras en un tablero pequeño. '
        'Solo se leen de izquierda a derecha y de arriba abajo.',
  ),
  explorador(
    nombre: 'Explorador',
    edadMinima: 7,
    edadMaxima: 10,
    icono: Icons.explore,
    color: Color(0xFF1E88E5),
    descripcion: 'Palabras de uso diario y un tablero más grande. '
        'Empiezan a aparecer palabras en diagonal.',
  ),
  aventurero(
    nombre: 'Aventurero',
    edadMinima: 11,
    edadMaxima: 14,
    icono: Icons.hiking,
    color: Color(0xFFEF6C00),
    descripcion: 'Vocabulario escolar más amplio. '
        'Algunas palabras están escritas al revés.',
  ),
  experto(
    nombre: 'Experto',
    edadMinima: 15,
    edadMaxima: 18,
    icono: Icons.workspace_premium,
    color: Color(0xFF8E24AA),
    descripcion: 'Palabras largas y abstractas en el tablero más grande, '
        'escondidas en las 8 direcciones.',
  );

  const Nivel({
    required this.nombre,
    required this.edadMinima,
    required this.edadMaxima,
    required this.icono,
    required this.color,
    required this.descripcion,
  });

  final String nombre;
  final int edadMinima;
  final int edadMaxima;
  final IconData icono;
  final Color color;
  final String descripcion;

  String get rango => '$edadMinima–$edadMaxima años';

  static Nivel porEdad(int edad) => values.firstWhere(
        (n) => edad <= n.edadMaxima,
        orElse: () => Nivel.experto,
      );
}

// ---------------------------------------------------------------------------
// App
// ---------------------------------------------------------------------------

class SelectorEdadDemoApp extends StatelessWidget {
  const SelectorEdadDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Selector de edad',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.amber,
      ),
      home: const PantallaPrincipal(),
    );
  }
}

class PantallaPrincipal extends StatefulWidget {
  const PantallaPrincipal({super.key});

  @override
  State<PantallaPrincipal> createState() => _PantallaPrincipalState();
}

class _PantallaPrincipalState extends State<PantallaPrincipal> {
  int _edad = 8;

  /// Primera vez: por ahora vive en memoria. Para que no vuelva a salir
  /// al reabrir la app, guardarlo con almacenamiento persistente.
  bool _mostrarAyuda = true;

  Future<void> _abrirSelector() async {
    setState(() => _mostrarAyuda = false);
    final nuevaEdad = await mostrarSelectorEdad(context, edadActual: _edad);
    if (nuevaEdad != null && nuevaEdad != _edad) {
      setState(() => _edad = nuevaEdad);
    }
  }

  @override
  Widget build(BuildContext context) {
    final nivel = Nivel.porEdad(_edad);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sopa de letras'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Align(
              alignment: Alignment.centerLeft,
              child: PildoraEdad(
                edad: _edad,
                nivel: nivel,
                onTap: _abrirSelector,
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            transitionBuilder: (child, animacion) => SizeTransition(
              sizeFactor: animacion,
              axisAlignment: -1,
              child: FadeTransition(opacity: animacion, child: child),
            ),
            
          ),
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: TarjetaNivel(key: ValueKey(nivel), nivel: nivel),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Cápsula compacta en el AppBar
// ---------------------------------------------------------------------------

class PildoraEdad extends StatelessWidget {
  const PildoraEdad({
    super.key,
    required this.edad,
    required this.nivel,
    required this.onTap,
  });

  final int edad;
  final Nivel nivel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
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

// ---------------------------------------------------------------------------
// Ayuda de primera vez
// ---------------------------------------------------------------------------

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
          padding: const EdgeInsets.fromLTRB(12, 4, 4, 4),
          child: Row(
            children: [
              Icon(Icons.arrow_upward,
                  size: 18, color: scheme.onInverseSurface),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Toca aquí para cambiar la edad; '
                  'el nivel se ajusta automáticamente.',
                  style: TextStyle(color: scheme.onInverseSurface),
                ),
              ),
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

// ---------------------------------------------------------------------------
// Bottom sheet con ruleta de edad
// ---------------------------------------------------------------------------

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
    final cambiaNivel = Nivel.porEdad(nuevaEdad) != Nivel.porEdad(_edad);

    // Clic suave en cada edad; uno más marcado cuando cambia el nivel.
    cambiaNivel
        ? HapticFeedback.mediumImpact()
        : HapticFeedback.selectionClick();

    setState(() => _edad = nuevaEdad);
  }

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final nivel = Nivel.porEdad(_edad);

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

// ---------------------------------------------------------------------------
// Tarjeta del nivel (se reutiliza en la hoja y en la pantalla)
// ---------------------------------------------------------------------------

class TarjetaNivel extends StatelessWidget {
  const TarjetaNivel({super.key, required this.nivel});

  final Nivel nivel;

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
                '${nivel.index + 1} de ${Nivel.values.length}',
                style: tema.textTheme.labelMedium
                    ?.copyWith(color: scheme.onSurfaceVariant),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Barra de progreso por niveles.
          Row(
            children: [
              for (final n in Nivel.values)
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
