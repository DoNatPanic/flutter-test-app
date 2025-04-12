import 'package:olkonapp/data/dto/article_dto.dart';
import 'package:olkonapp/domain/models/article.dart';

class ArticleConverter {
  List<Article> convertNews(List<ArticleDto> news) {
    List<Article> list = news.map((ArticleDto item) => _convert(item)).toList();
    return list;
  }

  Article _convert(ArticleDto articleDto) {
    return Article(
      title: articleDto.title ?? "",
      description: articleDto.description ?? "",
      urlToImage: articleDto.urlToImage ?? "",
      content: articleDto.content ?? "",
      url: articleDto.url ?? "",
    );
  }
}
