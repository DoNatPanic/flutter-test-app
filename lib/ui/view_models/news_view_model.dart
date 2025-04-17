import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:olkonapp/domain/models/article.dart';
import 'package:olkonapp/domain/models/news.dart';
import 'package:olkonapp/domain/repositories/articles_repository.dart';
import 'package:olkonapp/domain/repositories/news_repository.dart';
import 'package:olkonapp/domain/repositories/user_repository.dart';
import 'package:olkonapp/services/impls/news_api_service_impl.dart';

class NewsViewModel extends ChangeNotifier {
  final NewsRepository newsRepository;
  final UserRepository userRepository;
  final ArticlesRepository articlesRepository;
  List<Article> articles = <Article>[];
  bool isLoading = false;
  String? error;
  int _currentPage = 0;
  int _maxPages = 0;

  String get userName => userRepository.getUserName ?? "";

  NewsViewModel({
    required this.newsRepository,
    required this.userRepository,
    required this.articlesRepository,
  });

  void onReturnToScreen() {
    // Здесь можно обновить данные или что-то ещё
    if (kDebugMode) {
      print("Вернулись на экран, можно обновлять данные");
    }
  }

  Future<void> fetchNews(String text, bool isNewRequest) async {
    if (text.isEmpty) {
      return;
    }

    if (isLoading) {
      return;
    }

    isLoading = true;
    notifyListeners();

    if (isNewRequest) {
      _currentPage = 1;
      articles.clear();
    }

    try {
      News news = await newsRepository.getNews(text, _currentPage);
      _maxPages = news.totalResults ~/ pageSize;
      if (news.totalResults % pageSize != 0) {
        _maxPages++;
      }
      _currentPage++;

      // записать в базу
      news.articles = await articlesRepository.insertUpdate(news.articles);
      articles.addAll(news.articles);

      error = null;
    } catch (e) {
      error = e.toString();
    }

    isLoading = false;
    notifyListeners();
  }

  void onLastItemReached(String text) {
    if (_currentPage < _maxPages) {
      fetchNews(text, false);
    }
  }

  // void refresh(String text) {
  //   currentPage = 1;
  //   if (text.isNotEmpty) {
  //     fetchNews(text, true);
  //   }
  // }

  Future<void> logout() async {
    await userRepository.logout();
  }
}
