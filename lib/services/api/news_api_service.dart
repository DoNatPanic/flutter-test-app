import 'package:olkonapp/data/dto/news_dto.dart';

abstract class NewsApiService {
  // Получение данных с API (GET-запрос)
  Future<NewsDto> fetchData(String text, int page);
}
