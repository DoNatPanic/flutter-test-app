import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:olkonapp/data/dto/news_dto.dart';
import 'package:olkonapp/services/news_api.dart';

class NewsApiServiceImpl extends NewsApiService {
  static final String? _apiKey = dotenv.env['API_KEY'];

  // Получение данных с API (GET-запрос)
  @override
  Future<NewsDto> fetchData(String text) async {
    final http.Response response = await http.get(Uri.parse(_getUrl(text)));

    if (response.statusCode == 200) {
      // Если запрос успешен, возвращаем список новостей
      dynamic responseBody = json.decode(response.body);
      return NewsDto.fromJson(responseBody);
    } else {
      // Если запрос не успешен, выбрасываем исключение
      throw Exception('Failed to load data');
    }
  }

  String _getUrl(String text) {
    return "https://newsapi.org/v2/everything?q=$text&sortBy=popularity&apiKey=$_apiKey";
  }
}
