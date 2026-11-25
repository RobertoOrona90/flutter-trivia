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
    this.mostrarContador = true,
  });

  final int encontradas;
  final int total;
  final VoidCallback onReiniciar;
  final bool mostrarContador;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: mostrarContador
          ? MainAxisAlignment.spaceBetween
          : MainAxisAlignment.end,
      children: [
        if (mostrarContador)
          TextoContador(encontradas: encontradas, total: total),
        BotonReiniciar(onPressed: onReiniciar),
      ],
    );
  }
}
