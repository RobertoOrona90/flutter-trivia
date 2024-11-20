import 'package:flutter/material.dart';
import 'package:trivia/QuestionModel.dart';
import 'package:trivia/QuestionRepository.dart';

class Questionprovider extends ChangeNotifier {
  final Questionrepository postRepository = Questionrepository();
  List<QuestionModel> questions = [];
  Future<void> load() async {
    questions = await postRepository.get();
    notifyListeners();
  }
}