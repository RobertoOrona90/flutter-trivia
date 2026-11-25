import 'dart:math';

import '../domain/contracts/repositorio_palabras.dart';
import 'banco_palabras_por_edad.dart';

/// Toma las palabras del banco local y elige algunas al azar,
/// así cada partida es diferente.
class RepositorioPalabrasLocal implements RepositorioPalabras {
  RepositorioPalabrasLocal({
    Random? random,
    this.banco = bancoPalabrasPorEdad,
  }) : _random = random ?? Random();

  final Random _random;
  final List<GrupoPalabras> banco;

  @override
  List<String> palabrasParaEdad(int edad, {required int cantidad}) {
    final grupo = banco.firstWhere(
      (g) => g.incluye(edad),
      // Fuera de rango: el grupo más cercano (primero o último).
      orElse: () => edad < banco.first.edadMinima ? banco.first : banco.last,
    );
    return ([...grupo.palabras]..shuffle(_random)).take(cantidad).toList();
  }
}
