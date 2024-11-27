import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trivia/QuestionProvider.dart';
import 'package:trivia/widgets/CardSwiperList.dart';

class SecondaryScreen extends StatelessWidget {
  const SecondaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final postProvider = context.watch<Questionprovider>();
    return Scaffold(
      body: ListView.builder(
        itemCount: postProvider.questions.length,
        itemBuilder: (context, index) {
          final question = postProvider.questions[index];
          return Card(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                    leading: const Icon(Icons.question_answer),
                    title: Text(question.question)),
                Card(
                    child: CardSwiperList(
                  answers: question.answers,
                ))
              ],
            ),
          );
        },
      ),
    );
  }
}
