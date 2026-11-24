import 'dart:math';

import '../domain/contracts/generador_tablero.dart';
import '../domain/entities/celda.dart';
import '../domain/entities/tablero.dart';

/// Coloca las palabras en posiciones y direcciones aleatorias y rellena
/// el resto con letras al azar.
class GeneradorTableroAleatorio implements GeneradorTablero {
  GeneradorTableroAleatorio({
    Random? random,
    this.intentosPorPalabra = 150,
    this.abecedario = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ',
  }) : _random = random ?? Random();

  final Random _random;
  final int intentosPorPalabra;
  final String abecedario;

  static const _vacio = '-';

  @override
  Tablero generar({
    required int tamano,
    required List<String> palabras,
    required List<Celda> direcciones,
  }) {
    final matriz = List.generate(tamano, (_) => List.filled(tamano, _vacio));

    for (final palabra in palabras) {
      _colocar(matriz, palabra, direcciones);
    }
    _rellenar(matriz);

    return Tablero(matriz);
  }

  void _colocar(
    List<List<String>> matriz,
    String palabra,
    List<Celda> direcciones,
  ) {
    final n = matriz.length;
    for (var intento = 0; intento < intentosPorPalabra; intento++) {
      final fila = _random.nextInt(n);
      final col = _random.nextInt(n);
      final dir = direcciones[_random.nextInt(direcciones.length)];

      if (_cabe(matriz, palabra, fila, col, dir)) {
        for (var k = 0; k < palabra.length; k++) {
          matriz[fila + k * dir.x][col + k * dir.y] = palabra[k];
        }
        return;
      }
    }
  }

  bool _cabe(
    List<List<String>> matriz,
    String palabra,
    int fila,
    int col,
    Celda dir,
  ) {
    final n = matriz.length;
    for (var k = 0; k < palabra.length; k++) {
      final f = fila + k * dir.x;
      final c = col + k * dir.y;
      if (f < 0 || f >= n || c < 0 || c >= n) return false;

      final actual = matriz[f][c];
      if (actual != _vacio && actual != palabra[k]) return false;
    }
    return true;
  }

  void _rellenar(List<List<String>> matriz) {
    for (final fila in matriz) {
      for (var j = 0; j < fila.length; j++) {
        if (fila[j] == _vacio) {
          fila[j] = abecedario[_random.nextInt(abecedario.length)];
        }
      }
    }
  }
}
