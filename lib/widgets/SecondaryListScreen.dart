import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trivia/QuestionModel.dart';
import 'package:trivia/QuestionProvider.dart';
import 'package:trivia/widgets/FirstWidget.dart';
import 'package:trivia/widgets/carousel_answers.dart';

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
          //return ExpansionWidget(question: question);
          return Card(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                    leading: const Icon(Icons.question_answer),
                    title: Text(question.question)),
                Card(
                    child: SizedBox(
                        width: 325,
                        height: 250,
                        child: PageView.builder(
                          itemCount: question.answers.length,
                          itemBuilder: (context, index) {
                            final answer = question.answers[index];
                            return CarouselAnswers(answer: answer);
                          },
                        )))
              ],
            ),
          );

          // return ExpansionTile(
          //   title: Text(question.question),
          //   children: question.answers.map((answer) {
          //     return StatefulBuilder(
          //       builder: (context, setState) {
          //         return Answers(answer: answer);
          //       },
          //     );
          //   }).toList(),
          // );
        },
      ),
    );
  }
}
