import 'package:flutter/material.dart';
import 'package:trivia/QuestionModel.dart';

class ExpansionWidget extends StatelessWidget {
  QuestionModel question;
  ExpansionWidget({super.key, required this.question});

  @override
  Widget build(BuildContext context) {
    //return Container();
    return ExpansionTile(
      title: Text(question.question),
      children: question.answers.map((answer) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Answers(answer: answer);
          },
        );
      }).toList(),
    );
  }
}

class Answers extends StatelessWidget {
  final Answer answer;
  const Answers({super.key, required this.answer});

  @override
  Widget build(BuildContext context) {
    bool isTapped = false;
    return StatefulBuilder(
      builder: (context, setState) {
        return ListTile(
          leading: Image.network(answer.image, width: 100, height: 100),
          textColor: ChooseColorFromAnswer(isTapped, answer),
          title: Text(answer.text),
          enabled: !isTapped,
          onTap: () {
            setState(() {
              isTapped = true;
            });
            final message = answer.isCorrect ? "¡Correcto!" : "Incorrecto.";
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(message)),
            );
          },
        );
      },
    );
  }

  Color ChooseColorFromAnswer(bool isTapped, Answer answer) {
    if (isTapped) {
      if (answer.isCorrect == false) {
        return Colors.red;
      }
    }
    return Colors.black;
  }
}
