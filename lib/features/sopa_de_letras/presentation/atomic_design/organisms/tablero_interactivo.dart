import 'dart:math';

import 'package:flutter/material.dart';

import '../../../domain/entities/celda.dart';
import '../../../domain/entities/tablero.dart';
import '../atoms/letra_celda.dart';

/// Organismo: cuadrícula de letras que convierte el arrastre del dedo
/// en celdas y avisa mediante callbacks. No guarda estado de juego.
class TableroInteractivo extends StatelessWidget {
  const TableroInteractivo({
    super.key,
    required this.tablero,
    required this.seleccion,
    required this.resueltas,
    required this.onInicio,
    required this.onActualizar,
    required this.onFin,
  });

  final Tablero tablero;
  final List<Celda> seleccion;
  final Set<Celda> resueltas;
  final ValueChanged<Celda> onInicio;
  final ValueChanged<Celda> onActualizar;
  final VoidCallback onFin;

  @override
  Widget build(BuildContext context) {
    final n = tablero.tamano;

    return AspectRatio(
      aspectRatio: 1,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final tamanoCelda = constraints.biggest / n.toDouble();

          Celda? celdaEn(Offset posicion) {
            final celda = Point(
              (posicion.dy / tamanoCelda.height).floor(),
              (posicion.dx / tamanoCelda.width).floor(),
            );
            return tablero.contiene(celda) ? celda : null;
          }

          return GestureDetector(
            onPanStart: (d) {
              final celda = celdaEn(d.localPosition);
              if (celda != null) onInicio(celda);
            },
            onPanUpdate: (d) {
              final celda = celdaEn(d.localPosition);
              if (celda != null) onActualizar(celda);
            },
            onPanEnd: (_) => onFin(),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade400, width: 2),
              ),
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: n,
                ),
                itemCount: n * n,
                itemBuilder: (context, index) {
                  final celda = Point(index ~/ n, index % n);
                  return LetraCelda(
                    letra: tablero.letraEn(celda),
                    estado: _estadoDe(celda),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }

  EstadoCelda _estadoDe(Celda celda) {
    if (seleccion.contains(celda)) return EstadoCelda.seleccionada;
    if (resueltas.contains(celda)) return EstadoCelda.resuelta;
    return EstadoCelda.normal;
  }
}
