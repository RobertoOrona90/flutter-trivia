import 'tablero.dart';

/// Una partida generada: el tablero y las palabras que hay que encontrar.
class SopaDeLetras {
  SopaDeLetras({
    required this.tablero,
    required List<String> objetivos,
  }) : objetivos = List.unmodifiable(objetivos);

  final Tablero tablero;
  final List<String> objetivos;
}
