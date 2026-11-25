import 'package:flutter/material.dart';

import '../../data/repositorio_palabras_local.dart';
import '../../domain/entities/dificultad_sopa.dart';
import '../../domain/usecases/obtener_palabras_por_edad.dart';
import '../atomic_design/molecules/selector_edad.dart';
import 'sopa_de_letras_widget.dart';

/// Página: el jugador elige su edad y el tablero se ajusta
/// automáticamente (dificultad, tamaño y vocabulario).
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

  List<String> _elegirPalabras() => widget.palabras ?? _obtenerPalabras(_edad);

  void _nuevaPartida({int? edad}) {
    setState(() {
      _edad = edad ?? _edad;
      _palabras = _elegirPalabras();
      _partida++;
    });
  }

  @override
  Widget build(BuildContext context) {
    final dificultad = DificultadSopa.porEdad(_edad);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: SelectorEdad(
            edad: _edad,
            onChanged: (edad) => _nuevaPartida(edad: edad),
          ),
        ),
        SopaDeLetrasWidget(
          key: ValueKey(_partida),
          palabras: _palabras,
          dificultad: dificultad,
          gridSize: dificultad.tamanoTablero,
          onNuevaPartida: _nuevaPartida,
        ),
      ],
    );
  }
}
