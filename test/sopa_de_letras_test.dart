import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trivia/features/sopa_de_letras/data/banco_palabras_por_edad.dart';
import 'package:trivia/features/sopa_de_letras/data/generador_tablero_aleatorio.dart';
import 'package:trivia/features/sopa_de_letras/data/repositorio_palabras_local.dart';
import 'package:trivia/features/sopa_de_letras/domain/entities/celda.dart';
import 'package:trivia/features/sopa_de_letras/domain/usecases/obtener_palabras_por_edad.dart';
import 'package:trivia/features/sopa_de_letras/data/normalizador_palabras_espanol.dart';
import 'package:trivia/features/sopa_de_letras/domain/contracts/generador_tablero.dart';
import 'package:trivia/features/sopa_de_letras/domain/entities/tablero.dart';
import 'package:trivia/features/sopa_de_letras/domain/usecases/generar_sopa.dart';
import 'package:trivia/features/sopa_de_letras/domain/usecases/preparar_objetivos.dart';
import 'package:trivia/features/sopa_de_letras/domain/usecases/trazar_seleccion.dart';
import 'package:trivia/features/sopa_de_letras/presentation/atomic_design/atoms/estilo_nivel.dart';
import 'package:trivia/features/sopa_de_letras/presentation/atomic_design/atoms/letra_celda.dart';
import 'package:trivia/features/sopa_de_letras/presentation/atomic_design/molecules/pildora_edad.dart';
import 'package:trivia/features/sopa_de_letras/sopa_de_letras.dart';

void main() {
  group('DificultadSopa', () {
    test('por edad', () {
      expect(dificultadPorEdad(7), DificultadSopa.facil);
      expect(dificultadPorEdad(12), DificultadSopa.media);
      expect(dificultadPorEdad(13), DificultadSopa.dificil);
      expect(tamanoTableroPorDificultad(DificultadSopa.dificil), 12);
    });

    test('los rangos que se muestran coinciden con porEdad', () {
      for (var e = kEdadMinima; e <= kEdadMaxima; e++) {
        final nivel = DificultadSopa.porEdad(e);
        expect(
            e, inInclusiveRange(nivel.edadMinimaNivel, nivel.edadMaximaNivel),
            reason: '$e años');
      }
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

  group('Banco de palabras por edad', () {
    test('cada palabra es A-Z, sin repetir y del largo de su grupo', () {
      for (final grupo in bancoPalabrasPorEdad) {
        final tablero = DificultadSopa.porEdad(grupo.edadMinima).tamanoTablero;
        expect(grupo.palabras.toSet().length, grupo.palabras.length,
            reason: '${grupo.nombre}: hay palabras repetidas');
        expect(
            grupo.palabras.length,
            greaterThanOrEqualTo(
                DificultadSopa.porEdad(grupo.edadMinima).cantidadPalabras * 4),
            reason: '${grupo.nombre}: muy pocas palabras para variar');
        for (final p in grupo.palabras) {
          expect(p, matches(RegExp(r'^[A-Z]+$')), reason: p);
          expect(
              p.length, inInclusiveRange(grupo.largoMinimo, grupo.largoMaximo),
              reason: '${grupo.nombre}: $p');
          expect(p.length, lessThanOrEqualTo(tablero), reason: p);
        }
      }
    });

    test('los rangos de edad coinciden con la dificultad', () {
      for (final grupo in bancoPalabrasPorEdad) {
        expect(DificultadSopa.porEdad(grupo.edadMinima),
            DificultadSopa.porEdad(grupo.edadMaxima),
            reason: grupo.nombre);
      }
    });

    test('elige la cantidad correcta del grupo de la edad', () {
      final obtener =
          ObtenerPalabrasPorEdad(RepositorioPalabrasLocal(random: Random(3)));
      final ninos = bancoPalabrasPorEdad.first.palabras;
      final adolescentes = bancoPalabrasPorEdad.last.palabras;

      final paraNino = obtener(6);
      expect(paraNino, hasLength(5));
      expect(paraNino.every(ninos.contains), isTrue);

      final paraAdolescente = obtener(15);
      expect(paraAdolescente, hasLength(7));
      expect(paraAdolescente.every(adolescentes.contains), isTrue);

      expect(obtener(10), hasLength(6));
    });

    test('la partida solo pide palabras que sí están en el tablero', () {
      for (var semilla = 0; semilla < 50; semilla++) {
        final generar = GenerarSopa(
          generador: GeneradorTableroAleatorio(random: Random(semilla)),
          prepararObjetivos:
              const PrepararObjetivos(NormalizadorPalabrasEspanol()),
        );
        final sopa = generar(
          palabras: ObtenerPalabrasPorEdad(
              RepositorioPalabrasLocal(random: Random(semilla)))(15),
          tamano: 12,
          dificultad: DificultadSopa.dificil,
        );
        for (final p in sopa.objetivos) {
          expect(_existeEnCualquierDireccion(sopa.tablero, p), isTrue,
              reason: 'semilla $semilla: $p');
        }
      }
    });
  });

  testWidgets('cambiar la edad cambia la dificultad y el tablero',
      (tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: SopaDeLetrasPorEdadPage(palabras: ['SOL'], edadInicial: 7),
    ));

    // Estado inicial: contador sin etiqueta junto al título.
    expect(find.text('7 años'), findsOneWidget);
    expect(find.text('Nivel Inicial'), findsOneWidget);
    expect(
        find.descendant(of: find.byType(AppBar), matching: find.text('0 / 1')),
        findsOneWidget);
    expect(find.textContaining('Encontradas'), findsNothing);
    expect(find.byType(LetraCelda), findsNWidgets(8 * 8));

    // Abrir la hoja.
    await tester.tap(find.byType(PildoraEdad));
    await tester.pumpAndSettle();
    expect(find.text('¿Cuántos años tienes?'), findsOneWidget);

    // Girar la ruleta 3 posiciones: 7 -> 10 años (Explorador).
    await tester.drag(find.text('7 años').last, const Offset(0, -120));
    await tester.pumpAndSettle();
    expect(find.text('Listo: 10 años'), findsOneWidget);

    await tester.tap(find.text('Listo: 10 años'));
    await tester.pumpAndSettle();

    expect(find.text('10 años'), findsOneWidget);
    expect(find.text('Nivel Explorador'), findsOneWidget);
    expect(
      tester
          .widget<SopaDeLetrasWidget>(find.byType(SopaDeLetrasWidget))
          .gridSize,
      10,
    );
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
  TableroGenerado generar({
    required int tamano,
    required List<String> palabras,
    required List<Point<int>> direcciones,
  }) =>
      (
        tablero: Tablero([
          ['S', 'O', 'L', 'X'],
          ['X', 'X', 'X', 'X'],
          ['X', 'X', 'X', 'X'],
          ['X', 'X', 'X', 'X'],
        ]),
        colocadas: palabras,
      );
}

bool _existeEnCualquierDireccion(Tablero t, String palabra) {
  final n = t.tamano;
  for (var f = 0; f < n; f++) {
    for (var c = 0; c < n; c++) {
      for (final d in Direccion.todas) {
        final recorrido = [
          for (var k = 0; k < palabra.length; k++)
            Point(f + k * d.x, c + k * d.y),
        ];
        if (recorrido.every(t.contiene) && t.palabraEn(recorrido) == palabra) {
          return true;
        }
      }
    }
  }
  return false;
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
