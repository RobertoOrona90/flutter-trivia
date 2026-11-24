import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trivia/features/sopa_de_letras/data/generador_tablero_aleatorio.dart';
import 'package:trivia/features/sopa_de_letras/data/normalizador_palabras_espanol.dart';
import 'package:trivia/features/sopa_de_letras/domain/contracts/generador_tablero.dart';
import 'package:trivia/features/sopa_de_letras/domain/entities/tablero.dart';
import 'package:trivia/features/sopa_de_letras/domain/usecases/generar_sopa.dart';
import 'package:trivia/features/sopa_de_letras/domain/usecases/preparar_objetivos.dart';
import 'package:trivia/features/sopa_de_letras/domain/usecases/trazar_seleccion.dart';
import 'package:trivia/features/sopa_de_letras/sopa_de_letras.dart';

void main() {
  group('DificultadSopa', () {
    test('por edad', () {
      expect(dificultadPorEdad(7), DificultadSopa.facil);
      expect(dificultadPorEdad(12), DificultadSopa.media);
      expect(dificultadPorEdad(13), DificultadSopa.dificil);
      expect(tamanoTableroPorDificultad(DificultadSopa.dificil), 12);
    });
  });

  test('normaliza, deduplica y descarta palabras largas', () {
    const preparar = PrepararObjetivos(NormalizadorPalabrasEspanol());
    expect(
      preparar(['Árbol', 'arbol', 'Niño!', 'DEMASIADOLARGA', ''],
          tamanoMaximo: 8),
      ['ARBOL', 'NINO'],
    );
  });

  test('traza solo líneas rectas', () {
    const trazar = TrazarSeleccion();
    expect(trazar(const Point(0, 0), const Point(2, 2)),
        [const Point(0, 0), const Point(1, 1), const Point(2, 2)]);
    expect(trazar(const Point(0, 0), const Point(1, 2)), [const Point(0, 0)]);
  });

  test('el generador coloca todas las palabras', () {
    final generar = GenerarSopa(
      generador: GeneradorTableroAleatorio(random: Random(1)),
      prepararObjetivos: const PrepararObjetivos(NormalizadorPalabrasEspanol()),
    );
    final sopa = generar(
      palabras: ['COCA', 'FANTA', 'JOYA'],
      tamano: 8,
      dificultad: DificultadSopa.facil,
    );
    for (final palabra in sopa.objetivos) {
      expect(_existeHorizontalOVertical(sopa.tablero, palabra), isTrue,
          reason: palabra);
    }
  });

  testWidgets('encontrar una palabra la marca y actualiza el contador',
      (tester) async {
    final controller = SopaDeLetrasController(
      generarSopa: GenerarSopa(
        generador: _GeneradorFijo(),
        prepararObjetivos:
            const PrepararObjetivos(NormalizadorPalabrasEspanol()),
      ),
    );

    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: SingleChildScrollView(
          child: SopaDeLetrasWidget(
            gridSize: 4,
            palabras: const ['SOL'],
            controller: controller,
          ),
        ),
      ),
    ));

    expect(find.text('Encontradas: 0 / 1'), findsOneWidget);

    controller
      ..iniciarSeleccion(const Point(0, 0))
      ..actualizarSeleccion(const Point(0, 2))
      ..finalizarSeleccion();
    await tester.pumpAndSettle();

    expect(find.text('Encontradas: 1 / 1'), findsOneWidget);
    expect(find.text('¡Completado! Jugar de nuevo'), findsOneWidget);
  });
}

class _GeneradorFijo implements GeneradorTablero {
  @override
  Tablero generar({
    required int tamano,
    required List<String> palabras,
    required List<Point<int>> direcciones,
  }) =>
      Tablero([
        ['S', 'O', 'L', 'X'],
        ['X', 'X', 'X', 'X'],
        ['X', 'X', 'X', 'X'],
        ['X', 'X', 'X', 'X'],
      ]);
}

bool _existeHorizontalOVertical(Tablero t, String palabra) {
  final n = t.tamano;
  for (var i = 0; i < n; i++) {
    final fila = [for (var j = 0; j < n; j++) t.letraEn(Point(i, j))].join();
    final col = [for (var j = 0; j < n; j++) t.letraEn(Point(j, i))].join();
    if (fila.contains(palabra) || col.contains(palabra)) return true;
  }
  return false;
}
