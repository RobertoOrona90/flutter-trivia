import 'dart:math';

import '../entities/celda.dart';

/// Calcula la línea recta (horizontal, vertical o diagonal a 45°)
/// entre la celda inicial y la actual. Si no es recta, solo devuelve el inicio.
class TrazarSeleccion {
  const TrazarSeleccion();

  List<Celda> call(Celda inicio, Celda fin) {
    final diffFila = fin.x - inicio.x;
    final diffCol = fin.y - inicio.y;

    final esRecta =
        diffFila == 0 || diffCol == 0 || diffFila.abs() == diffCol.abs();
    if (!esRecta) return [inicio];

    final pasoFila = diffFila.sign;
    final pasoCol = diffCol.sign;
    final pasos = max(diffFila.abs(), diffCol.abs());

    return [
      for (var i = 0; i <= pasos; i++)
        Point(inicio.x + i * pasoFila, inicio.y + i * pasoCol),
    ];
  }
}
