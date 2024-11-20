import 'package:dio/dio.dart';
import 'package:trivia/QuestionModel.dart';

class Questionrepository {
  final _dio = Dio();
  final urlEndpoint =
      'https://testsarca.blob.core.windows.net/files/trivia.json';

  List<QuestionModel> ConvertToList(List<dynamic> data) {
    List<QuestionModel> posts =
        data.map((e) => QuestionModel.fromJson(e)).toList();
    return posts;
  }

  Future<List<QuestionModel>> get() async {
    try {
      final response = await _dio.get(urlEndpoint);
      List<QuestionModel> posts = ConvertToList(response.data);
      return posts;
    } catch (e) {
      print(e.toString());
    }
    return [];
  }
}
