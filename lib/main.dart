import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trivia/QuestionProvider.dart';
import 'package:trivia/features/sopa_de_letras/sopa_de_letras.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
              lazy: false, create: (_) => Questionprovider()..load())
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          // Tema claro: el texto oscuro se lee bien sobre el fondo amarillo.
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.amber),
            scaffoldBackgroundColor: Colors.yellow.shade300,
            appBarTheme: AppBarTheme(
              backgroundColor: Colors.amber.shade600,
              foregroundColor: Colors.black87,
            ),
          ),
          title: 'Sopa de letras',
          home: Scaffold(
            appBar: AppBar(
              title: const Text('Sopa de letras'),
            ),
            body: const SingleChildScrollView(
              child: SopaDeLetrasPorEdadPage(),
            ),
          ),
        ));
  }
}

// void main() => runApp(const MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: Scaffold(
//         body: SafeArea(
//           child: Center(
//             child: SingleChildScrollView(
//               child: SopaDeLetrasWidget(
//                 gridSize: 10,
//                 palabras: ['FLUTTER', 'DART', 'WIDGET', 'ESTADO', 'MATRIZ'],
//               ),
//             ),
//           ),
//         ),
//       ),
//     ));
