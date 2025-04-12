import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:olkonapp/data/dto/article_dto.dart';

class NewsApiService {
  static final String? _apiKey = dotenv.env['API_KEY'];

  // Получение данных с API (GET-запрос)
  Future<List<ArticleDto>> fetchData(String text) async {
    final http.Response response = await http.get(Uri.parse(_getUrl(text)));

    if (response.statusCode == 200) {
      // Если запрос успешен, возвращаем список новостей
      dynamic responseBody = json.decode(response.body);
      return (responseBody['articles'] as List<dynamic>)
          .map((dynamic i) => ArticleDto.fromJson(i))
          .toList();
    } else {
      // Если запрос не успешен, выбрасываем исключение
      throw Exception('Failed to load data');
    }
  }

  String _getUrl(String text) {
    return "https://newsapi.org/v2/everything?q=$text&sortBy=popularity&apiKey=$_apiKey";
  }
}
