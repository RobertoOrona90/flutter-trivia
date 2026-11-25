import 'package:flutter/material.dart';

import '../../data/repositorio_palabras_local.dart';
import '../../domain/entities/dificultad_sopa.dart';
import '../../domain/usecases/obtener_palabras_por_edad.dart';
import '../atomic_design/atoms/texto_contador.dart';
import '../atomic_design/molecules/banner_ayuda.dart';
import '../atomic_design/molecules/pildora_edad.dart';
import '../atomic_design/organisms/hoja_selector_edad.dart';
import '../controller/sopa_de_letras_controller.dart';
import 'sopa_de_letras_widget.dart';

/// Pantalla: el jugador elige su edad desde la cápsula del AppBar y el
/// tablero se ajusta automáticamente (dificultad, tamaño y vocabulario).
class SopaDeLetrasPorEdadPage extends StatefulWidget {
  const SopaDeLetrasPorEdadPage({
    super.key,
    this.palabras,
    this.edadInicial = 7,
    this.obtenerPalabras,
  });

  /// Palabras fijas. Si es `null`, se eligen del banco según la edad.
  final List<String>? palabras;
  final int edadInicial;

  /// Opcional: inyecta otra fuente de palabras (p. ej. en pruebas).
  final ObtenerPalabrasPorEdad? obtenerPalabras;

  @override
  State<SopaDeLetrasPorEdadPage> createState() =>
      _SopaDeLetrasPorEdadPageState();
}

class _SopaDeLetrasPorEdadPageState extends State<SopaDeLetrasPorEdadPage> {
  late final ObtenerPalabrasPorEdad _obtenerPalabras = widget.obtenerPalabras ??
      ObtenerPalabrasPorEdad(RepositorioPalabrasLocal());

  late int _edad = widget.edadInicial;
  late List<String> _palabras = _elegirPalabras();

  /// Cambia en cada partida nueva para que el tablero se genere de cero.
  int _partida = 0;

  /// Primera vez: por ahora vive en memoria. Para que no vuelva a salir
  /// al reabrir la app, guardarlo con almacenamiento persistente.
  bool _mostrarAyuda = true;

  /// Lo comparten el tablero y el contador del AppBar.
  final SopaDeLetrasController _controller = crearControladorSopa();

  @override
  void initState() {
    super.initState();
    _configurarPartida();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _configurarPartida() {
    final dificultad = DificultadSopa.porEdad(_edad);
    _controller.configurar(
      palabras: _palabras,
      tamano: dificultad.tamanoTablero,
      dificultad: dificultad,
    );
  }

  List<String> _elegirPalabras() => widget.palabras ?? _obtenerPalabras(_edad);

  void _nuevaPartida({int? edad}) {
    setState(() {
      _edad = edad ?? _edad;
      _palabras = _elegirPalabras();
      _partida++;
      _configurarPartida();
    });
  }

  Future<void> _abrirSelector() async {
    setState(() => _mostrarAyuda = false);
    final nuevaEdad = await mostrarSelectorEdad(context, edadActual: _edad);
    if (!mounted) return;
    if (nuevaEdad != null && nuevaEdad != _edad) {
      _nuevaPartida(edad: nuevaEdad);
    }
  }

  @override
  Widget build(BuildContext context) {
    final dificultad = DificultadSopa.porEdad(_edad);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Flexible(
              child: Text('Sopa de letras', overflow: TextOverflow.ellipsis),
            ),
            const SizedBox(width: 12),
            ListenableBuilder(
              listenable: _controller,
              builder: (context, _) => TextoContador(
                encontradas: _controller.encontradas.length,
                total: _controller.sopa.objetivos.length,
                conEtiqueta: false,
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: PildoraEdad(edad: _edad, onTap: _abrirSelector),
          ),
        ],
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
            child: SingleChildScrollView(
              child: SopaDeLetrasWidget(
                key: ValueKey(_partida),
                controller: _controller,
                mostrarContador: false,
                palabras: _palabras,
                dificultad: dificultad,
                gridSize: dificultad.tamanoTablero,
                onNuevaPartida: _nuevaPartida,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
