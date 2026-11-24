import 'celda.dart';

/// Matriz cuadrada de letras, inmutable desde fuera.
class Tablero {
  Tablero(List<List<String>> celdas)
      : _celdas = List.unmodifiable(
          celdas.map((fila) => List<String>.unmodifiable(fila)),
        );

  final List<List<String>> _celdas;

  int get tamano => _celdas.length;

  String letraEn(Celda celda) => _celdas[celda.x][celda.y];

  bool contiene(Celda celda) =>
      celda.x >= 0 && celda.x < tamano && celda.y >= 0 && celda.y < tamano;

  /// Palabra formada por las letras de un recorrido de celdas.
  String palabraEn(List<Celda> recorrido) => recorrido.map(letraEn).join();
}
