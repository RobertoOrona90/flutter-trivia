import '../entities/celda.dart';
import '../entities/tablero.dart';

/// Contrato para construir un tablero con las palabras colocadas (DIP).
abstract interface class GeneradorTablero {
  Tablero generar({
    required int tamano,
    required List<String> palabras,
    required List<Celda> direcciones,
  });
}
