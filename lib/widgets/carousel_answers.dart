import 'package:flutter/material.dart';
import 'package:trivia/QuestionModel.dart';
import 'dart:math';
import 'package:confetti/confetti.dart';

class CarouselAnswers extends StatefulWidget {
  final Answer answer;
  const CarouselAnswers({super.key, required this.answer});

  @override
  State<CarouselAnswers> createState() => _CarouselAnswersState();
}

class _CarouselAnswersState extends State<CarouselAnswers> {
  Color cardColor = Colors.black;
  late ConfettiController _controllerCenter;

  @override
  void initState() {
    super.initState();
    _controllerCenter =
        ConfettiController(duration: const Duration(seconds: 10));
  }

  @override
  void dispose() {
    _controllerCenter.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        color: cardColor,
        child: InkWell(
          onLongPress: () {
            setState(() {
              if (widget.answer.isCorrect) {
                cardColor = Colors.blue;
                _controllerCenter.play();
              } else {
                cardColor = Colors.red;
                _controllerCenter.stop();
              }
            });
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ConfettiWidget(
                confettiController: _controllerCenter,
                blastDirectionality: BlastDirectionality.explosive,
                shouldLoop:
                    false, // start again as soon as the animation is finished
                colors: const [
                  Colors.green,
                  Colors.blue,
                  Colors.pink,
                  Colors.orange,
                  Colors.purple
                ], // manually specify the colors to be used
                createParticlePath: drawStar, // define a custom shape/path.
              ),
              Image.network(widget.answer.image, width: 325, height: 200),
              Text(
                widget.answer.text,
                style: const TextStyle(fontSize: 24, color: Colors.white),
              )
            ],
          ),
        ));
  }

  Path drawStar(Size size) {
    double degToRad(double deg) => deg * (pi / 180.0);
    const numberOfPoints = 5;
    final halfWidth = size.width / 2;
    final externalRadius = halfWidth;
    final internalRadius = halfWidth / 2.5;
    final degreesPerStep = degToRad(360 / numberOfPoints);
    final halfDegreesPerStep = degreesPerStep / 2;
    final path = Path();
    final fullAngle = degToRad(360);
    path.moveTo(size.width, halfWidth);
    for (double step = 0; step < fullAngle; step += degreesPerStep) {
      path.lineTo(halfWidth + externalRadius * cos(step),
          halfWidth + externalRadius * sin(step));
      path.lineTo(halfWidth + internalRadius * cos(step + halfDegreesPerStep),
          halfWidth + internalRadius * sin(step + halfDegreesPerStep));
    }
    path.close();
    return path;
  }
}
