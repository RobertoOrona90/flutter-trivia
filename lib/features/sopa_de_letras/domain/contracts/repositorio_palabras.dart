/// Contrato para obtener palabras acordes al vocabulario de una edad (DIP).
/// Hoy se implementa con listas locales; mañana podría ser una API.
abstract interface class RepositorioPalabras {
  /// Devuelve hasta [cantidad] palabras al azar para la [edad] indicada.
  List<String> palabrasParaEdad(int edad, {required int cantidad});
}
