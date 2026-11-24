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
    final tablero = _generador.generar(
      tamano: tamano,
      palabras: objetivos,
      direcciones: dificultad.direcciones,
    );
    return SopaDeLetras(tablero: tablero, objetivos: objetivos);
  }
}
