import 'package:olkonapp/data/dto/article_dto.dart';

abstract class NewsApiService {
  // Получение данных с API (GET-запрос)
  Future<List<ArticleDto>> fetchData(String text);
}
