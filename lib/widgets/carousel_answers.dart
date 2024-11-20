import 'package:flutter/material.dart';
import 'package:trivia/QuestionModel.dart';

class CarouselAnswers extends StatefulWidget {
  final Answer answer;
  const CarouselAnswers({super.key, required this.answer});

  @override
  State<CarouselAnswers> createState() => _CarouselAnswersState();
}

class _CarouselAnswersState extends State<CarouselAnswers> {
  Color cardColor = Colors.black;

  @override
  Widget build(BuildContext context) {
    return Card(
        color: cardColor,
        child: InkWell(
          onLongPress: () {
            setState(() {
              cardColor = widget.answer.isCorrect
                  ? Colors.blue
                  : Colors.red; 
            });
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Image.network(widget.answer.image, width: 325, height: 200),
              Text(
                widget.answer.text,
                style: const TextStyle(fontSize: 24, color: Colors.white),
              )
            ],
          ),
        ));
  }
}
