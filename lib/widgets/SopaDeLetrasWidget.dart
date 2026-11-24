import 'dart:math';
import 'package:flutter/material.dart';

class SopaDeLetrasWidget extends StatefulWidget {
  final int gridSize;
  final List<String> palabras;

  const SopaDeLetrasWidget({
    super.key,
    this.gridSize = 10,
    this.palabras = const ['CASA', 'AUTO', 'GATO', 'PERRO', 'ARBOL']
  });

  @override
  State<SopaDeLetrasWidget> createState() => _SopaDeLetrasWidgetState();
}

class _SopaDeLetrasWidgetState extends State<SopaDeLetrasWidget> {
  late List<List<String>> _tablero;
  final Set<String> _palabrasEncontradas = {};
  final Set<Point<int>> _celdasResueltas = {};

  // Variables para el control táctil (arrastre)
  Point<int>? _inicioSeleccion;
  List<Point<int>> _seleccionActual = [];
  final GlobalKey _gridKey = GlobalKey();

  // 8 direcciones posibles: (dFila, dCol)
  final List<Point<int>> _direcciones = const [
    Point(0, 1),   // Derecha
    Point(1, 0),   // Abajo
    Point(1, 1),   // Diagonal abajo-derecha
    Point(0, -1),  // Izquierda
    Point(-1, 0),  // Arriba
    Point(-1, -1), // Diagonal arriba-izquierda
    Point(-1, 1),  // Diagonal arriba-derecha
    Point(1, -1),  // Diagonal abajo-izquierda
  ];

  @override
  void initState() {
    super.initState();
    _generarTablero();
  }

  void _generarTablero() {
    final random = Random();
    final n = widget.gridSize;

    // 1. Inicializar matriz con '-'
    _tablero = List.generate(n, (_) => List.filled(n, '-'));
    _palabrasEncontradas.clear();
    _celdasResueltas.clear();
    _seleccionActual.clear();

    // 2. Colocar cada palabra
    for (final palabra in _objetivos) {
      bool colocada = false;
      int intentos = 0;

      while (!colocada && intentos < 150) {
        intentos++;
        int f = random.nextInt(n);
        int c = random.nextInt(n);
        Point<int> dir = _direcciones[random.nextInt(_direcciones.length)];

        if (_puedeColocarse(palabra, f, c, dir)) {
          for (int k = 0; k < palabra.length; k++) {
            _tablero[f + k * dir.x][c + k * dir.y] = palabra[k];
          }
          colocada = true;
        }
      }
    }

    // 3. Rellenar espacios vacíos con letras aleatorias
    const abecedario = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    for (int i = 0; i < n; i++) {
      for (int j = 0; j < n; j++) {
        if (_tablero[i][j] == '-') {
          _tablero[i][j] = abecedario[random.nextInt(abecedario.length)];
        }
      }
    }

    setState(() {});
  }

  bool _puedeColocarse(String palabra, int f, int c, Point<int> dir) {
    final n = widget.gridSize;
    for (int k = 0; k < palabra.length; k++) {
      int nuevaF = f + k * dir.x;
      int nuevaC = c + k * dir.y;

      if (nuevaF < 0 || nuevaF >= n || nuevaC < 0 || nuevaC >= n) {
        return false;
      }

      String celdaActual = _tablero[nuevaF][nuevaC];
      if (celdaActual != '-' && celdaActual != palabra[k]) {
        return false;
      }
    }
    return true;
  }

  // Convierte la posición (x, y) del dedo en coordenadas (fila, columna)
  Point<int>? _obtenerCeldaDesdePosicion(Offset localPosition) {
    final RenderBox? box =
        _gridKey.currentContext?.findRenderObject() as RenderBox?;
    if (box == null) return null;

    final size = box.size;
    final cellWidth = size.width / widget.gridSize;
    final cellHeight = size.height / widget.gridSize;

    int col = (localPosition.dx / cellWidth).floor();
    int row = (localPosition.dy / cellHeight).floor();

    if (row >= 0 &&
        row < widget.gridSize &&
        col >= 0 &&
        col < widget.gridSize) {
      return Point(row, col);
    }
    return null;
  }

  // Calcula una línea recta válida (horizontal, vertical o diagonal) entre inicio y fin
  List<Point<int>> _calcularLineaSeleccion(Point<int> inicio, Point<int> fin) {
    int diffRow = fin.x - inicio.x;
    int diffCol = fin.y - inicio.y;

    // Validar que sea horizontal, vertical o diagonal a 45 grados
    if (diffRow == 0 || diffCol == 0 || diffRow.abs() == diffCol.abs()) {
      int stepRow = diffRow == 0 ? 0 : (diffRow > 0 ? 1 : -1);
      int stepCol = diffCol == 0 ? 0 : (diffCol > 0 ? 1 : -1);
      int pasos = max(diffRow.abs(), diffCol.abs());

      List<Point<int>> puntos = [];
      for (int i = 0; i <= pasos; i++) {
        puntos.add(Point(inicio.x + i * stepRow, inicio.y + i * stepCol));
      }
      return puntos;
    }
    return [inicio];
  }

  void _validarSeleccion() {
    if (_seleccionActual.isEmpty) return;

    String palabraFormada = _seleccionActual
        .map((p) => _tablero[p.x][p.y])
        .join();
    String palabraInvertida = palabraFormada.split('').reversed.join();

    for (final objetivo in _objetivos) {
      if ((palabraFormada == objetivo || palabraInvertida == objetivo) &&
          !_palabrasEncontradas.contains(objetivo)) {
        setState(() {
          _palabrasEncontradas.add(objetivo);
          _celdasResueltas.addAll(_seleccionActual);
        });
        break;
      }
    }

    setState(() {
      _inicioSeleccion = null;
      _seleccionActual.clear();
    });
  }

  List<String> get _objetivos {
    final objetivos = <String>{};

    for (final palabraRaw in widget.palabras) {
      var palabra = palabraRaw
          .toUpperCase()
          .trim()
          .replaceAll(RegExp(r'[ÁÀÄÂ]'), 'A')
          .replaceAll(RegExp(r'[ÉÈËÊ]'), 'E')
          .replaceAll(RegExp(r'[ÍÌÏÎ]'), 'I')
          .replaceAll(RegExp(r'[ÓÒÖÔ]'), 'O')
          .replaceAll(RegExp(r'[ÚÙÜÛ]'), 'U')
          .replaceAll('Ñ', 'N')
          .replaceAll(RegExp(r'[^A-Z]'), '');

      if (palabra.isNotEmpty && palabra.length <= widget.gridSize) {
        objetivos.add(palabra);
      }
    }

    return objetivos.toList();
  }

  @override
  void didUpdateWidget(covariant SopaDeLetrasWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.gridSize != widget.gridSize ||
        oldWidget.palabras.toString() != widget.palabras.toString()) {
      _generarTablero();
    }
  }

  @override
  Widget build(BuildContext context) {
    final todasEncontradas =
        _objetivos.isNotEmpty &&
        _palabrasEncontradas.length == _objetivos.length;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Encabezado y botón de reinicio
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Encontradas: ${_palabrasEncontradas.length} / ${_objetivos.length}',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              IconButton(
                onPressed: _generarTablero,
                icon: const Icon(Icons.refresh),
                tooltip: 'Nuevo tablero',
              ),
            ],
          ),
        ),

        // Tablero interactivo
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: AspectRatio(
            aspectRatio: 1,
            child: GestureDetector(
              onPanStart: (details) {
                final celda = _obtenerCeldaDesdePosicion(details.localPosition);
                if (celda != null) {
                  setState(() {
                    _inicioSeleccion = celda;
                    _seleccionActual = [celda];
                  });
                }
              },
              onPanUpdate: (details) {
                if (_inicioSeleccion == null) return;
                final celda = _obtenerCeldaDesdePosicion(details.localPosition);
                if (celda != null) {
                  setState(() {
                    _seleccionActual =
                        _calcularLineaSeleccion(_inicioSeleccion!, celda);
                  });
                }
              },
              onPanEnd: (_) => _validarSeleccion(),
              child: Container(
                key: _gridKey,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade400, width: 2),
                ),
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: widget.gridSize,
                  ),
                  itemCount: widget.gridSize * widget.gridSize,
                  itemBuilder: (context, index) {
                    int row = index ~/ widget.gridSize;
                    int col = index % widget.gridSize;
                    Point<int> punto = Point(row, col);

                    bool estaSeleccionada = _seleccionActual.contains(punto);
                    bool estaResuelta = _celdasResueltas.contains(punto);

                    Color bgColor = Colors.transparent;
                    Color textColor = Colors.black87;

                    if (estaSeleccionada) {
                      bgColor = Colors.amber.shade400;
                    } else if (estaResuelta) {
                      bgColor = Colors.green.shade400;
                      textColor = Colors.white;
                    }

                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 120),
                      margin: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: bgColor,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        _tablero[row][col],
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),

        // Lista de palabras objetivo
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: _objetivos.map((palabra) {
              final encontrada = _palabrasEncontradas.contains(palabra);

              return ElevatedButton(
                onPressed: null,
                style: ElevatedButton.styleFrom(
                  disabledBackgroundColor:
                      encontrada ? Colors.green : Colors.grey.shade700,
                  disabledForegroundColor:
                      encontrada ? Colors.white : Colors.grey.shade300,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  palabra,
                  style: TextStyle(
                    decoration:
                        encontrada ? TextDecoration.lineThrough : null,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            }).toList(),
          ),
        ),

        if (todasEncontradas)
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: ElevatedButton.icon(
              onPressed: _generarTablero,
              icon: const Icon(Icons.celebration),
              label: const Text('¡Completado! Jugar de nuevo'),
            ),
          ),
      ],
    );
  }
}