import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trivia/QuestionModel.dart';
import 'package:trivia/QuestionProvider.dart';

class CardListScreen extends StatelessWidget {
  const CardListScreen({super.key});

  Widget buildCard(QuestionModel item) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item.question,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(item.answers[0].text),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    final postProvider = context.watch<Questionprovider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Multiple Cards')),
      body: ListView.builder(
        itemCount: postProvider.questions.length,
        itemBuilder: (context, index) {
          return buildCard(postProvider.questions[index]);
        },
      ),
    );
  }
}
