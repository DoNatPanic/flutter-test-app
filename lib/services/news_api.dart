import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:olkonapp/data/dto/article_dto.dart';

class NewsApiService {
  static final String? apiKey = dotenv.env['API_KEY'];

  String getUrl(String text) {
    if (text.isEmpty) {
      // если запрос пустой, покажем актуальные новости для США
      return "https://newsapi.org/v2/top-headlines?country=us&apiKey=$apiKey";
    } else {
      return "https://newsapi.org/v2/everything?q=$text&sortBy=popularity&apiKey=$apiKey";
    }
  }

  // Получение данных с API (GET-запрос)
  Future<List<ArticleDto>> fetchData(String text) async {
    final response = await http.get(Uri.parse(getUrl(text)));

    if (response.statusCode == 200) {
      // Если запрос успешен, возвращаем список новостей
      var responseBody = json.decode(response.body);
      return (responseBody['articles'] as List)
          .map((i) => ArticleDto.fromJson(i))
          .toList();
    } else {
      // Если запрос не успешен, выбрасываем исключение
      throw Exception('Failed to load data');
    }
  }
}
