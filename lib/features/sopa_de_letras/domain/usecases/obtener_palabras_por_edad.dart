import '../contracts/repositorio_palabras.dart';
import '../entities/dificultad_sopa.dart';

/// Elige las palabras de una partida según la edad del jugador.
/// La cantidad la define la dificultad que corresponde a esa edad.
class ObtenerPalabrasPorEdad {
  const ObtenerPalabrasPorEdad(this._repositorio);

  final RepositorioPalabras _repositorio;

  List<String> call(int edad) {
    final dificultad = DificultadSopa.porEdad(edad);
    return _repositorio.palabrasParaEdad(
      edad,
      cantidad: dificultad.cantidadPalabras,
    );
  }
}
