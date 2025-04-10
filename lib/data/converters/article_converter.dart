import 'package:olkonapp/data/dto/article_dto.dart';
import 'package:olkonapp/domain/models/article.dart';

class ArticleConverter {
  List<Article> convertNews(List<ArticleDto> news) {
    var list = news.map((item) => convert(item)).toList();
    return list;
  }

  Article convert(ArticleDto articleDto) {
    return Article(
      title: articleDto.title ?? "",
      description: articleDto.description ?? "",
      urlToImage: articleDto.urlToImage ?? "",
      content: articleDto.content ?? "",
      url: articleDto.url ?? "",
    );
  }
}
