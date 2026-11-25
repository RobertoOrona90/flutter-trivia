import '../entities/celda.dart';
import '../entities/tablero.dart';

/// Resultado de generar un tablero: el tablero y las palabras que sí
/// se lograron colocar (puede faltar alguna si no hubo espacio).
typedef TableroGenerado = ({Tablero tablero, List<String> colocadas});

/// Contrato para construir un tablero con las palabras colocadas (DIP).
abstract interface class GeneradorTablero {
  TableroGenerado generar({
    required int tamano,
    required List<String> palabras,
    required List<Celda> direcciones,
  });
}
