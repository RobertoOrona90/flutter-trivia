import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trivia/QuestionProvider.dart';
import 'package:trivia/widgets/SopaDeLetrasWidget.dart';

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
          theme: ThemeData.dark(),
          title: 'Material App',
          home: Scaffold(
            appBar: AppBar(
              title: const Text('Futbol App '),
            ),
            body: const SingleChildScrollView(
              child: SopaDeLetrasWidget(
                gridSize: 10,
                palabras: ['CASA', 'AUTO', 'GATO', 'PERRO', 'ARBOL'],
              ),
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