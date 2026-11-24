import 'package:flutter/foundation.dart';

import '../../domain/entities/celda.dart';
import '../../domain/entities/dificultad_sopa.dart';
import '../../domain/entities/sopa_de_letras.dart';
import '../../domain/usecases/generar_sopa.dart';
import '../../domain/usecases/trazar_seleccion.dart';
import '../../domain/usecases/validar_seleccion.dart';

/// Estado de la partida y orquestación de los casos de uso.
/// No conoce widgets: la UI solo escucha y llama a sus métodos.
class SopaDeLetrasController extends ChangeNotifier {
  SopaDeLetrasController({
    required GenerarSopa generarSopa,
    TrazarSeleccion trazarSeleccion = const TrazarSeleccion(),
    ValidarSeleccion validarSeleccion = const ValidarSeleccion(),
  })  : _generarSopa = generarSopa,
        _trazarSeleccion = trazarSeleccion,
        _validarSeleccion = validarSeleccion;

  final GenerarSopa _generarSopa;
  final TrazarSeleccion _trazarSeleccion;
  final ValidarSeleccion _validarSeleccion;

  late SopaDeLetras _sopa;
  final Set<String> _encontradas = {};
  final Set<Celda> _celdasResueltas = {};
  Celda? _inicioSeleccion;
  List<Celda> _seleccion = const [];

  late List<String> _palabras;
  late int _tamano;
  late DificultadSopa _dificultad;

  SopaDeLetras get sopa => _sopa;
  Set<String> get encontradas => Set.unmodifiable(_encontradas);
  Set<Celda> get celdasResueltas => Set.unmodifiable(_celdasResueltas);
  List<Celda> get seleccion => List.unmodifiable(_seleccion);
  bool get completado =>
      _sopa.objetivos.isNotEmpty &&
      _encontradas.length == _sopa.objetivos.length;

  /// Configura la partida y genera el primer tablero.
  void configurar({
    required List<String> palabras,
    required int tamano,
    required DificultadSopa dificultad,
  }) {
    _palabras = List.of(palabras);
    _tamano = tamano;
    _dificultad = dificultad;
    reiniciar();
  }

  /// Genera un tablero nuevo con la configuración actual.
  void reiniciar() {
    _sopa = _generarSopa(
      palabras: _palabras,
      tamano: _tamano,
      dificultad: _dificultad,
    );
    _encontradas.clear();
    _celdasResueltas.clear();
    _inicioSeleccion = null;
    _seleccion = const [];
    notifyListeners();
  }

  void iniciarSeleccion(Celda celda) {
    _inicioSeleccion = celda;
    _seleccion = [celda];
    notifyListeners();
  }

  void actualizarSeleccion(Celda celda) {
    final inicio = _inicioSeleccion;
    if (inicio == null) return;
    _seleccion = _trazarSeleccion(inicio, celda);
    notifyListeners();
  }

  void finalizarSeleccion() {
    final palabra = _validarSeleccion(
      sopa: _sopa,
      seleccion: _seleccion,
      encontradas: _encontradas,
    );
    if (palabra != null) {
      _encontradas.add(palabra);
      _celdasResueltas.addAll(_seleccion);
    }
    _inicioSeleccion = null;
    _seleccion = const [];
    notifyListeners();
  }
}
