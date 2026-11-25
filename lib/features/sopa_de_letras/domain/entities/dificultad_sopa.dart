import 'celda.dart';

/// Nivel de dificultad de la sopa de letras.
///
/// Cada nivel define sus propias reglas (tamaño y direcciones permitidas),
/// así agregar un nivel nuevo no obliga a modificar otras clases (OCP).
enum DificultadSopa {
  facil(
    tamanoTablero: 8,
    cantidadPalabras: 5,
    direcciones: [
      Direccion.derecha,
      Direccion.abajo,
    ],
  ),
  media(
    tamanoTablero: 10,
    cantidadPalabras: 6,
    direcciones: [
      Direccion.derecha,
      Direccion.abajo,
      Direccion.diagonalAbajoDerecha,
      Direccion.diagonalArribaIzquierda,
    ],
  ),
  dificil(
    tamanoTablero: 12,
    cantidadPalabras: 7,
    direcciones: Direccion.todas,
  );

  const DificultadSopa({
    required this.tamanoTablero,
    required this.cantidadPalabras,
    required this.direcciones,
  });

  final int tamanoTablero;

  /// Cuántas palabras se esconden en cada partida.
  final int cantidadPalabras;
  final List<Celda> direcciones;

  /// Determina la dificultad recomendada según la edad del jugador.
  static DificultadSopa porEdad(int edad) {
    if (edad <= 7) return DificultadSopa.facil;
    if (edad <= 12) return DificultadSopa.media;
    return DificultadSopa.dificil;
  }
}

/// Atajos conservados por compatibilidad con el código existente.
DificultadSopa dificultadPorEdad(int edad) => DificultadSopa.porEdad(edad);

int tamanoTableroPorDificultad(DificultadSopa dificultad) =>
    dificultad.tamanoTablero;
