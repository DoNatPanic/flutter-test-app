import 'dart:convert';

import 'package:olkonapp/data/database/article_entity.dart';
import 'package:olkonapp/data/dto/article_dto.dart';
import 'package:olkonapp/data/dto/news_dto.dart';
import 'package:olkonapp/domain/models/article.dart';
import 'package:olkonapp/domain/models/comment.dart';
import 'package:olkonapp/domain/models/news.dart';

class ArticleConverter {
  News convertNews(NewsDto resultDto) {
    return _convertNews(resultDto);
  }

  News _convertNews(NewsDto resultDto) {
    List<Article> list =
        resultDto.articles
            ?.map((ArticleDto item) => _convertArticle(item))
            .toList() ??
        <Article>[];
    return News(totalResults: resultDto.totalResults ?? 0, articles: list);
  }

  Article _convertArticle(ArticleDto articleDto) {
    return Article(
      title: articleDto.title ?? "",
      description: articleDto.description ?? "",
      urlToImage: articleDto.urlToImage ?? "",
      content: articleDto.content ?? "",
      url: articleDto.url ?? "",
      commentsCount: 0,
      comments: <Comment>[],
    );
  }

  ArticleEntity convertFromArticleToEntity(Article article) {
    return ArticleEntity(
      title: article.title,
      description: article.description,
      urlToImage: article.urlToImage,
      content: article.content,
      url: article.url,
      commentsCount: article.commentsCount,
      comments: jsonEncode(
        article.comments.map((Comment c) => c.toJson()).toList(),
      ),
    );
  }

  // Метод преобразования из ArticleEntity в Article
  Article convertFromEntityToArticle(ArticleEntity entity) {
    return Article(
      title: entity.title,
      description: entity.description,
      urlToImage: entity.urlToImage,
      content: entity.content,
      url: entity.url,
      commentsCount: entity.commentsCount,
      comments:
          (json.decode(entity.comments) as List<dynamic>)
              .map((dynamic e) => Comment.fromJson(e))
              .toList(),
    );
  }
}
