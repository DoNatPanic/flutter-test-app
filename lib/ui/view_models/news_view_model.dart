import 'package:flutter/material.dart';
import 'package:olkonapp/domain/models/article.dart';
import 'package:olkonapp/domain/news_repository.dart';
import 'package:olkonapp/domain/user_repository.dart';

class NewsViewModel extends ChangeNotifier {
  final NewsRepository newsRepository;
  final UserRepository userRepository;

  final TextEditingController searchFieldController = TextEditingController();
  List<Article> articles = [];
  bool isLoading = false;
  String? error;

  NewsViewModel({required this.newsRepository, required this.userRepository}) {
    fetchNews();
  }

  String get userName => userRepository.getUserName() ?? "";

  Future<void> fetchNews() async {
    isLoading = true;
    notifyListeners();

    try {
      articles = await newsRepository.getNewsList(searchFieldController.text);
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

  @override
  void dispose() {
    searchFieldController.dispose();
    super.dispose();
  }
}
