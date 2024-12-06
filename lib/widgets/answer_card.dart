import 'package:flutter/material.dart';
import 'package:trivia/QuestionModel.dart';

class AnswerdCard extends StatefulWidget {
  final Answer answer;
  final double height;
  final double width;

  const AnswerdCard({
    super.key,
    required this.answer,
    required this.height,
    required this.width,
  });

  @override
  State<AnswerdCard> createState() => _AnswerCardState();
}

class _AnswerCardState extends State<AnswerdCard> {
  Color defaultGrayColor = const Color.fromARGB(68, 68, 68, 68);
  Color answerColor = const Color.fromARGB(68, 68, 68, 68);
  String responseAnswer = "";
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: showAnswer,
      child: Stack(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(left: 30),
            height: widget.height,
            width: widget.width,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(24)),
              color: defaultGrayColor,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                responseAnswer == "" ? const SizedBox.shrink() :  headerAnswerResponse(responseAnswer),
                answerResultCardAlignment()
              ],
            ),
          ),
          imageCard(),
        ],
      ),
    );
  }
  
  Row headerAnswerResponse(String answer) {
    return Row(
      children: [
        Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                answer,
                style:   TextStyle(color: answerColor, fontSize: 18.0),
              ),
            )),
          IconButton(
                    icon: responseAnswer == "Correcta" ? const Icon(Icons.check) : const Icon(Icons.warning_amber),
                    onPressed: () {},
                    color: answerColor),
      ],
    );
  }

  Column answerResultCardAlignment() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        answerResultCard(widget.answer.text),
      ],
    );
  }

  Align answerResultCard(String answerText) {
    return Align(
      alignment: Alignment.topRight,
      child: Container(
          margin: const EdgeInsets.only(bottom: 12.0),
          padding: const EdgeInsets.fromLTRB(8.0, 4.0, 12.0, 4.0),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10), bottomLeft: Radius.circular(10)),
            color: answerColor,
          ),
          child: answerResult(answerText)),
    );
  }

  Text answerResult(String answerText) {
    return Text(
      answerText,
      style: const TextStyle(
          color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  Align imageCard() {
    return Align(
      alignment: Alignment.center,
      child: Image.network(
        widget.answer.image,
        height: widget.height / 1.7,
        width: widget.width / 1.4,
        fit: BoxFit.contain,
      ),
    );
  }

  void showAnswer() {
    setState(() {
      if (widget.answer.isCorrect) {
        answerColor = Colors.green;
        responseAnswer = "Correcta";
      } else {
        answerColor = Colors.red;
        responseAnswer = "Incorrecta";
      }
    });
  }
}
