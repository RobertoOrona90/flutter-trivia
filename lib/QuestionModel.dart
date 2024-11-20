import 'dart:convert';

class QuestionModel {
  final int id;
  final String question;
  final List<Answer> answers;

  QuestionModel({
    required this.id,
    required this.question,
    required this.answers,
  });

  QuestionModel copyWith({
    int? id,
    String? question,
    List<Answer>? answers,
  }) =>
      QuestionModel(
        id: id ?? this.id,
        question: question ?? this.question,
        answers: answers ?? this.answers,
      );

  factory QuestionModel.fromRawJson(String str) =>
      QuestionModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory QuestionModel.fromJson(Map<String, dynamic> json) => QuestionModel(
        id: json["id"],
        question: json["question"],
        answers:
            List<Answer>.from(json["answers"].map((x) => Answer.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "question": question,
        "answers": List<dynamic>.from(answers.map((x) => x.toJson())),
      };
}

class Answer {
  final String text;
  final bool isCorrect;
  final String image;

  Answer({
required    this.text,
    required this.isCorrect,
    required this.image,
  });

  Answer copyWith({
    String? text,
    bool? isCorrect,
    String? image,
  }) =>
      Answer(
        text: text ?? this.text,
        isCorrect: isCorrect ?? this.isCorrect,
        image: image ?? this.image,
      );

  factory Answer.fromRawJson(String str) => Answer.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Answer.fromJson(Map<String, dynamic> json) => Answer(
        text: json["text"],
        isCorrect: json["isCorrect"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "text": text,
        "isCorrect": isCorrect,
        "image": image,
      };
}
