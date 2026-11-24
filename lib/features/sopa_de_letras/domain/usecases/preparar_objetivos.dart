import '../contracts/normalizador_palabras.dart';

/// Normaliza, elimina duplicados y descarta palabras que no caben.
class PrepararObjetivos {
  const PrepararObjetivos(this._normalizador);

  final NormalizadorPalabras _normalizador;

  List<String> call(List<String> palabras, {required int tamanoMaximo}) {
    final objetivos = <String>{};
    for (final palabraRaw in palabras) {
      final palabra = _normalizador.normalizar(palabraRaw);
      if (palabra.isNotEmpty && palabra.length <= tamanoMaximo) {
        objetivos.add(palabra);
      }
    }
    return objetivos.toList();
  }
}
