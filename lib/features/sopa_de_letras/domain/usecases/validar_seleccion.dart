import '../entities/celda.dart';
import '../entities/sopa_de_letras.dart';

/// Devuelve la palabra objetivo formada por la selección (en cualquier
/// sentido) o `null` si no coincide con ninguna pendiente.
class ValidarSeleccion {
  const ValidarSeleccion();

  String? call({
    required SopaDeLetras sopa,
    required List<Celda> seleccion,
    required Set<String> encontradas,
  }) {
    if (seleccion.isEmpty) return null;

    final formada = sopa.tablero.palabraEn(seleccion);
    final invertida = formada.split('').reversed.join();

    for (final objetivo in sopa.objetivos) {
      if (encontradas.contains(objetivo)) continue;
      if (formada == objetivo || invertida == objetivo) return objetivo;
    }
    return null;
  }
}
