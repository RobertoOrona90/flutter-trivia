/// Contrato para convertir una palabra libre en una palabra jugable
/// (solo letras que existen en el tablero).
abstract interface class NormalizadorPalabras {
  String normalizar(String palabra);
}
