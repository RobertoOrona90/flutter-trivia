import 'dart:math';

/// Posición en el tablero: `x` = fila, `y` = columna.
typedef Celda = Point<int>;

/// Desplazamientos (dFila, dCol) para colocar o recorrer palabras.
abstract final class Direccion {
  static const Celda derecha = Point(0, 1);
  static const Celda abajo = Point(1, 0);
  static const Celda diagonalAbajoDerecha = Point(1, 1);
  static const Celda izquierda = Point(0, -1);
  static const Celda arriba = Point(-1, 0);
  static const Celda diagonalArribaIzquierda = Point(-1, -1);
  static const Celda diagonalArribaDerecha = Point(-1, 1);
  static const Celda diagonalAbajoIzquierda = Point(1, -1);

  static const List<Celda> todas = [
    derecha,
    abajo,
    diagonalAbajoDerecha,
    izquierda,
    arriba,
    diagonalArribaIzquierda,
    diagonalArribaDerecha,
    diagonalAbajoIzquierda,
  ];
}
