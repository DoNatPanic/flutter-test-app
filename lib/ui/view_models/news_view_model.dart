import 'dart:async';

import 'package:flutter/material.dart';
import 'package:olkonapp/domain/models/article.dart';
import 'package:olkonapp/domain/models/news.dart';
import 'package:olkonapp/domain/news_repository.dart';
import 'package:olkonapp/domain/user_repository.dart';
import 'package:olkonapp/services/news_api_impl.dart';

class NewsViewModel extends ChangeNotifier {
  final NewsRepository newsRepository;
  final UserRepository userRepository;
  List<Article> articles = <Article>[];
  bool isLoading = false;
  String? error;
  int currentPage = 0;
  int maxPages = 0;

  String get userName => userRepository.getUserName ?? "";

  NewsViewModel({required this.newsRepository, required this.userRepository});

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
      currentPage = 1;
      articles.clear();
    }

    try {
      News news = await newsRepository.getNews(text, currentPage);
      maxPages = news.totalResults ~/ pageSize;
      if (news.totalResults % pageSize != 0) {
        maxPages++;
      }
      currentPage++;
      articles.addAll(news.articles);
      error = null;
    } catch (e) {
      error = e.toString();
    }

    isLoading = false;
    notifyListeners();
  }

  void onLastItemReached(String text) {
    if (currentPage < maxPages) {
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
