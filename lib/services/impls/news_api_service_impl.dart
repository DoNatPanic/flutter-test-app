import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:olkonapp/data/dto/news_dto.dart';
import 'package:olkonapp/services/api/news_api_service.dart';

const int pageSize = 20;

class NewsApiServiceImpl implements NewsApiService {
  static final String? _apiKey = dotenv.env['API_KEY'];

  // Получение данных с API (GET-запрос)
  @override
  Future<NewsDto> fetchData(String text, int page) async {
    final http.Response response = await http.get(
      Uri.parse(_getUrl(text, pageSize, page)),
    );

    if (response.statusCode == 200) {
      // Если запрос успешен, возвращаем список новостей
      dynamic responseBody = json.decode(response.body);

      return NewsDto.fromJson(responseBody);
    } else {
      // Если запрос не успешен, выбрасываем исключение
      throw Exception('Failed to load data');
    }
  }

  String _getUrl(String text, int pageSize, int page) {
    return "https://newsapi.org/v2/everything?q=$text&pageSize=$pageSize&page=$page&sortBy=popularity&apiKey=$_apiKey";
  }
}
