import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:olkonapp/ui/view_models/news_view_model.dart';
import 'package:provider/provider.dart';
import 'package:olkonapp/domain/models/article.dart';
import 'package:olkonapp/ui/fragments/article_screen.dart';
import 'package:olkonapp/ui/fragments/login_screen.dart';

class NewsScreen extends StatefulWidget {
  static const String routeName = 'news';

  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  static const Duration _searchDebounceDelay = Duration(milliseconds: 1200);

  final TextEditingController _searchController = TextEditingController();
  Timer? _debounceTimer;
  bool _isSearchTextEmpty = true;
  late NewsViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchTextChanged);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _viewModel = context.read<NewsViewModel>();
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchTextChanged);
    _searchController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // слушаем сигналы из view model
    _viewModel = context.watch<NewsViewModel>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('News'),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Поиск
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Enter text',
                suffixIcon:
                    _isSearchTextEmpty
                        ? null
                        : IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            // Очистка текста при нажатии на иконку
                            _clearSearch();
                          },
                        ),

                labelStyle: const TextStyle(color: Colors.grey),
                border: const OutlineInputBorder(),
              ),
              onSubmitted: (_) => _viewModel.fetchNews(_searchController.text),
            ),
            const SizedBox(height: 16),

            // Имя пользователя и выход
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(_viewModel.userName),
                const SizedBox(width: 8.0),
                IconButton(
                  icon: const Icon(Icons.exit_to_app),
                  tooltip: 'Log Out',
                  iconSize: 30.0,
                  onPressed: () async {
                    await _viewModel.logout();
                    if (context.mounted) {
                      context.goNamed(LoginScreen.routeName);
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Список новостей
            Expanded(
              child:
                  _viewModel.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : _viewModel.error != null
                      ? Center(
                        child: Text(
                          'Error: ${_viewModel.error}',
                          textAlign: TextAlign.center,
                        ),
                      )
                      : _viewModel.articles.isEmpty
                      ? const Center(
                        child: Text(
                          'Welcome to the news feed, start searching for a news article!',
                          textAlign: TextAlign.center,
                        ),
                      )
                      : ListView.builder(
                        itemCount: _viewModel.articles.length,
                        itemBuilder: (BuildContext context, int index) {
                          final Article article = _viewModel.articles[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 4.0),
                            elevation: 4.0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(16.0),
                              title: Text(
                                article.title,
                                style: const TextStyle(fontSize: 18),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    article.description,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                  TextButton(
                                    onPressed:
                                        () => _navigateToArticle(
                                          context,
                                          article,
                                          scrollToComments: true,
                                        ),
                                    child: Text(
                                      "Comments (${article.commentsCount})",
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.blue,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              onTap: () => _navigateToArticle(context, article),
                            ),
                          );
                        },
                      ),
            ),
          ],
        ),
      ),
    );
  }

  void _onSearchTextChanged() {
    String searchText = _searchController.text;

    setState(() {
      _isSearchTextEmpty = searchText.isEmpty;
    });

    if (searchText.isNotEmpty) {
      // Применяем debounce с задержкой
      if (_debounceTimer?.isActive ?? false) {
        _debounceTimer?.cancel();
      }
      _debounceTimer = Timer(_searchDebounceDelay, () {
        _enterSearch(searchText);
      });
    } else {
      _debounceTimer?.cancel();
    }
  }

  void _enterSearch(String searchText) {
    _viewModel.fetchNews(searchText);
  }

  void _clearSearch() {
    _viewModel.articles.clear();
    _searchController.clear();
  }

  void _navigateToArticle(
    BuildContext context,
    Article article, {
    bool scrollToComments = false,
  }) {
    Navigator.push(
      context,
      MaterialPageRoute<dynamic>(
        builder:
            (_) => ArticleScreen(
              article: article,
              scrollToComments: scrollToComments,
            ),
      ),
    );
  }
}
