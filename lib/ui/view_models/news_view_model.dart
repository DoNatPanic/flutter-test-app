import 'dart:async';

import 'package:flutter/material.dart';
import 'package:olkonapp/domain/models/article.dart';
import 'package:olkonapp/domain/news_repository.dart';
import 'package:olkonapp/domain/user_repository.dart';

class NewsViewModel extends ChangeNotifier {
  final NewsRepository newsRepository;
  final UserRepository userRepository;
  List<Article> articles = <Article>[];
  bool isLoading = false;
  String? error;

  String get userName => userRepository.getUserName ?? "";

  NewsViewModel({required this.newsRepository, required this.userRepository});

  Future<void> fetchNews(String searchText) async {
    if (searchText.isEmpty) {
      return;
    }
    isLoading = true;
    notifyListeners();

    try {
      articles = await newsRepository.getNewsList(searchText);
      error = null;
    } catch (e) {
      error = e.toString();
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> logout() async {
    await userRepository.logout();
  }
}
