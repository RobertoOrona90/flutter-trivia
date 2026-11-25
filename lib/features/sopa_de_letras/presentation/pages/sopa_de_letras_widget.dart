import 'package:flutter/material.dart';

import '../../data/generador_tablero_aleatorio.dart';
import '../../data/normalizador_palabras_espanol.dart';
import '../../domain/entities/dificultad_sopa.dart';
import '../../domain/usecases/generar_sopa.dart';
import '../../domain/usecases/preparar_objetivos.dart';
import '../atomic_design/atoms/boton_jugar_de_nuevo.dart';
import '../atomic_design/molecules/encabezado_sopa.dart';
import '../atomic_design/molecules/lista_palabras.dart';
import '../atomic_design/organisms/tablero_interactivo.dart';
import '../atomic_design/templates/sopa_de_letras_template.dart';
import '../controller/sopa_de_letras_controller.dart';

/// Página (atomic design) y punto de composición: conecta el controlador
/// con la plantilla. Mantiene la misma API pública que antes.
class SopaDeLetrasWidget extends StatefulWidget {
  const SopaDeLetrasWidget({
    super.key,
    this.gridSize = 10,
    required this.palabras,
    this.dificultad = DificultadSopa.media,
    this.controller,
    this.onNuevaPartida,
  });

  final int gridSize;
  final List<String> palabras;
  final DificultadSopa dificultad;

  /// Opcional: inyecta un controlador propio (p. ej. en pruebas).
  final SopaDeLetrasController? controller;

  /// Opcional: qué hacer al pedir un tablero nuevo (p. ej. cambiar las
  /// palabras). Si es `null`, se reacomodan las mismas palabras.
  final VoidCallback? onNuevaPartida;

  @override
  State<SopaDeLetrasWidget> createState() => _SopaDeLetrasWidgetState();
}

class _SopaDeLetrasWidgetState extends State<SopaDeLetrasWidget> {
  late SopaDeLetrasController _controller;
  bool _esPropio = false;

  @override
  void initState() {
    super.initState();
    _crearControlador();
  }

  void _crearControlador() {
    _esPropio = widget.controller == null;
    _controller = widget.controller ?? _controladorPorDefecto();
    _configurar();
  }

  SopaDeLetrasController _controladorPorDefecto() => SopaDeLetrasController(
        generarSopa: GenerarSopa(
          generador: GeneradorTableroAleatorio(),
          prepararObjetivos:
              const PrepararObjetivos(NormalizadorPalabrasEspanol()),
        ),
      );

  void _configurar() => _controller.configurar(
        palabras: widget.palabras,
        tamano: widget.gridSize,
        dificultad: widget.dificultad,
      );

  @override
  void didUpdateWidget(covariant SopaDeLetrasWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      if (_esPropio) _controller.dispose();
      _crearControlador();
      return;
    }
    if (oldWidget.gridSize != widget.gridSize ||
        oldWidget.dificultad != widget.dificultad ||
        oldWidget.palabras.toString() != widget.palabras.toString()) {
      _configurar();
    }
  }

  @override
  void dispose() {
    if (_esPropio) _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _controller,
      builder: (context, _) {
        final c = _controller;
        final nuevaPartida = widget.onNuevaPartida ?? c.reiniciar;
        return SopaDeLetrasTemplate(
          encabezado: EncabezadoSopa(
            encontradas: c.encontradas.length,
            total: c.sopa.objetivos.length,
            onReiniciar: nuevaPartida,
          ),
          tablero: TableroInteractivo(
            tablero: c.sopa.tablero,
            seleccion: c.seleccion,
            resueltas: c.celdasResueltas,
            onInicio: c.iniciarSeleccion,
            onActualizar: c.actualizarSeleccion,
            onFin: c.finalizarSeleccion,
          ),
          palabras: ListaPalabras(
            palabras: c.sopa.objetivos,
            encontradas: c.encontradas,
          ),
          pie: c.completado ? BotonJugarDeNuevo(onPressed: nuevaPartida) : null,
        );
      },
    );
  }
}
