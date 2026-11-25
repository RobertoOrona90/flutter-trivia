import '../contracts/generador_tablero.dart';
import '../entities/dificultad_sopa.dart';
import '../entities/sopa_de_letras.dart';
import 'preparar_objetivos.dart';

/// Crea una nueva partida a partir de las palabras y la dificultad.
class GenerarSopa {
  const GenerarSopa({
    required GeneradorTablero generador,
    required PrepararObjetivos prepararObjetivos,
  })  : _generador = generador,
        _prepararObjetivos = prepararObjetivos;

  final GeneradorTablero _generador;
  final PrepararObjetivos _prepararObjetivos;

  SopaDeLetras call({
    required List<String> palabras,
    required int tamano,
    required DificultadSopa dificultad,
  }) {
    final objetivos = _prepararObjetivos(palabras, tamanoMaximo: tamano);
    final generado = _generador.generar(
      tamano: tamano,
      palabras: objetivos,
      direcciones: dificultad.direcciones,
    );
    // Solo se piden las palabras que realmente quedaron en el tablero,
    // para que la partida siempre se pueda completar.
    return SopaDeLetras(
      tablero: generado.tablero,
      objetivos: generado.colocadas,
    );
  }
}
