/// Grupo de palabras pensado para el vocabulario de un rango de edad.
class GrupoPalabras {
  const GrupoPalabras({
    required this.nombre,
    required this.edadMinima,
    required this.edadMaxima,
    required this.largoMinimo,
    required this.largoMaximo,
    required this.palabras,
  });

  final String nombre;
  final int edadMinima;
  final int edadMaxima;
  final int largoMinimo;
  final int largoMaximo;
  final List<String> palabras;

  bool incluye(int edad) => edad >= edadMinima && edad <= edadMaxima;
}

/// Banco de palabras en español, ordenado por edad.
///
/// Reglas para agregar palabras (las pruebas las verifican):
/// - Sin acentos ni Ñ: el tablero solo usa A-Z y así la palabra
///   se ve igual en la lista y en el tablero.
/// - Respetar el largo del grupo, para que quepa en su tablero.
const List<GrupoPalabras> bancoPalabrasPorEdad = [
  // Niños (hasta 7 años) · tablero 8x8 · palabras básicas de 4 a 5 letras.
  GrupoPalabras(
    nombre: 'Niños',
    edadMinima: 0,
    edadMaxima: 7,
    largoMinimo: 4,
    largoMaximo: 5,
    palabras: [
      'CASA',
      'GATO',
      'PERRO',
      'MESA',
      'LUNA',
      'PATO',
      'AGUA',
      'ROSA',
      'PERA',
      'FLOR',
      'NUBE',
      'MANO',
      'BOCA',
      'PELO',
      'SAPO',
      'VACA',
      'LORO',
      'TREN',
      'BARCO',
      'PLAYA',
      'CAMA',
      'SOPA',
      'QUESO',
      'MANGO',
      'CARRO',
      'LIBRO',
      'PATIO',
      'GLOBO',
      'DEDO',
      'MONO',
      'PLATO',
      'VASO',
      'LECHE',
      'FRESA',
      'OSITO',
      'SILLA',
      'PIZZA',
      'NIDO',
      'FOCA',
      'RANA',
    ],
  ),

  // Preadolescentes (8 a 12 años) · tablero 10x10 · de 5 a 8 letras.
  GrupoPalabras(
    nombre: 'Preadolescentes',
    edadMinima: 8,
    edadMaxima: 12,
    largoMinimo: 5,
    largoMaximo: 8,
    palabras: [
      'ESCUELA',
      'PLANETA',
      'VENTANA',
      'CIUDAD',
      'CAMINO',
      'BOSQUE',
      'CABALLO',
      'TORTUGA',
      'CUADERNO',
      'FAMILIA',
      'AMIGOS',
      'DEPORTE',
      'PINTURA',
      'VERANO',
      'INVIERNO',
      'CEREBRO',
      'PLANTA',
      'ESTRELLA',
      'COCINA',
      'PELOTA',
      'NARANJA',
      'HERMANO',
      'GUITARRA',
      'MAESTRO',
      'PUENTE',
      'DESIERTO',
      'MERCADO',
      'ABUELA',
      'MAPACHE',
      'CARTERO',
      'VIAJERO',
      'TECLADO',
      'PAYASO',
      'CASTILLO',
    ],
  ),

  // Adolescentes y adultos (13 años o más) · tablero 12x12 · de 7 a 10 letras.
  GrupoPalabras(
    nombre: 'Adolescentes',
    edadMinima: 13,
    edadMaxima: 120,
    largoMinimo: 7,
    largoMaximo: 10,
    palabras: [
      'CIENCIA',
      'HISTORIA',
      'LITERATURA',
      'DEMOCRACIA',
      'AMBIENTE',
      'LIBERTAD',
      'RESPETO',
      'EMPRESA',
      'PROYECTO',
      'SOCIEDAD',
      'CULTURA',
      'INVESTIGAR',
      'ARGUMENTO',
      'COMUNIDAD',
      'DERECHOS',
      'ESFUERZO',
      'CREATIVO',
      'DESARROLLO',
      'UNIVERSO',
      'PROGRAMAR',
      'INTERNET',
      'CIUDADANO',
      'LIDERAZGO',
      'EVIDENCIA',
      'IDENTIDAD',
      'DIVERSIDAD',
      'EQUILIBRIO',
      'VOLUNTARIO',
      'CONTRATO',
      'ESTRATEGIA',
      'AUTOESTIMA',
      'ESTUDIANTE',
    ],
  ),
];
