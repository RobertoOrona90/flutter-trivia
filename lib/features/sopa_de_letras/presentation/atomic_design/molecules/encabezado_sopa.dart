import 'package:flutter/material.dart';

import '../atoms/boton_reiniciar.dart';
import '../atoms/texto_contador.dart';

/// Molécula: contador de progreso + botón de reinicio.
class EncabezadoSopa extends StatelessWidget {
  const EncabezadoSopa({
    super.key,
    required this.encontradas,
    required this.total,
    required this.onReiniciar,
  });

  final int encontradas;
  final int total;
  final VoidCallback onReiniciar;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextoContador(encontradas: encontradas, total: total),
        BotonReiniciar(onPressed: onReiniciar),
      ],
    );
  }
}
