import 'package:flutter/material.dart';

import '../../../domain/entities/dificultad_sopa.dart';

/// Edades que ofrece el selector.
const int kEdadMinima = 4;
const int kEdadMaxima = 18;

/// Datos visuales de cada dificultad (nombre, icono, color y texto).
///
/// Vive en presentación para que el dominio no dependa de Flutter.
/// Los rangos coinciden con [DificultadSopa.porEdad].
extension EstiloNivel on DificultadSopa {
  String get nombre => switch (this) {
        DificultadSopa.facil => 'Inicial',
        DificultadSopa.media => 'Explorador',
        DificultadSopa.dificil => 'Experto',
      };

  IconData get icono => switch (this) {
        DificultadSopa.facil => Icons.child_care,
        DificultadSopa.media => Icons.explore,
        DificultadSopa.dificil => Icons.workspace_premium,
      };

  Color get color => switch (this) {
        DificultadSopa.facil => const Color(0xFF43A047),
        DificultadSopa.media => const Color(0xFF1E88E5),
        DificultadSopa.dificil => const Color(0xFF8E24AA),
      };

  int get edadMinimaNivel => switch (this) {
        DificultadSopa.facil => kEdadMinima,
        DificultadSopa.media => 8,
        DificultadSopa.dificil => 13,
      };

  int get edadMaximaNivel => switch (this) {
        DificultadSopa.facil => 7,
        DificultadSopa.media => 12,
        DificultadSopa.dificil => kEdadMaxima,
      };

  String get rango => '$edadMinimaNivel–$edadMaximaNivel años';

  String get descripcion => switch (this) {
        DificultadSopa.facil =>
          'Palabras cortas de 4 a 5 letras en un tablero de 8×8. '
              'Solo se leen de izquierda a derecha y de arriba abajo.',
        DificultadSopa.media =>
          'Palabras de uso diario en un tablero de 10×10. '
              'Empiezan a aparecer palabras en diagonal.',
        DificultadSopa.dificil =>
          'Palabras largas en el tablero más grande (12×12), '
              'escondidas en las 8 direcciones, incluso al revés.',
      };
}
