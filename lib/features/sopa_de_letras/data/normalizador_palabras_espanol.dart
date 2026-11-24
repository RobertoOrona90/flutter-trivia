import '../domain/contracts/normalizador_palabras.dart';

/// Pasa a mayúsculas, quita acentos y la Ñ, y elimina todo lo que no sea A-Z.
class NormalizadorPalabrasEspanol implements NormalizadorPalabras {
  const NormalizadorPalabrasEspanol();

  static final _reemplazos = <RegExp, String>{
    RegExp(r'[ÁÀÄÂ]'): 'A',
    RegExp(r'[ÉÈËÊ]'): 'E',
    RegExp(r'[ÍÌÏÎ]'): 'I',
    RegExp(r'[ÓÒÖÔ]'): 'O',
    RegExp(r'[ÚÙÜÛ]'): 'U',
    RegExp('Ñ'): 'N',
  };
  static final _noLetras = RegExp(r'[^A-Z]');

  @override
  String normalizar(String palabra) {
    var resultado = palabra.toUpperCase().trim();
    _reemplazos.forEach((patron, letra) {
      resultado = resultado.replaceAll(patron, letra);
    });
    return resultado.replaceAll(_noLetras, '');
  }
}
