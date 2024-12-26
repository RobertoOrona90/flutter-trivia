import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trivia/QuestionProvider.dart';
import 'package:trivia/widgets/SecondaryListScreen.dart';
import 'package:trivia/widgets/clubsScreen.dart';

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
            //body: ClubsScreen(),
            body: SecondaryScreen(),
          ),
        ));
  }
}