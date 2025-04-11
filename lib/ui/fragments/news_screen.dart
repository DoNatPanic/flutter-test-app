import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:olkonapp/ui/view_models/news_view_model.dart';
import 'package:provider/provider.dart';
import 'package:olkonapp/domain/models/article.dart';
import 'package:olkonapp/ui/fragments/article_screen.dart';
import 'package:olkonapp/ui/fragments/login_screen.dart';

class NewsScreen extends StatelessWidget {
  const NewsScreen({super.key});
  static const routeName = 'news';

  void _navigateToArticle(
    BuildContext context,
    Article article, {
    bool scrollToComments = false,
  }) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (_) => ArticleScreen(
              article: article,
              scrollToComments: scrollToComments,
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NewsViewModel>(
      builder: (context, viewModel, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('News'),
            automaticallyImplyLeading: false,
          ),
          body:
              viewModel.isLoading
                  ? Center(child: CircularProgressIndicator())
                  : viewModel.error != null
                  ? Center(child: Text('Error: ${viewModel.error}'))
                  : Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        // Поиск
                        TextField(
                          controller: viewModel.searchFieldController,
                          decoration: const InputDecoration(
                            labelText: 'Enter text',
                            suffixIcon: Icon(Icons.search),
                            labelStyle: TextStyle(color: Colors.grey),
                            border: OutlineInputBorder(),
                          ),
                          onSubmitted: (_) => viewModel.fetchNews(),
                        ),
                        const SizedBox(height: 16),

                        // Имя пользователя и выход
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(viewModel.userName),
                            const SizedBox(width: 8.0),
                            IconButton(
                              icon: const Icon(Icons.exit_to_app),
                              tooltip: 'Log Out',
                              iconSize: 30.0,
                              onPressed: () async {
                                await viewModel.logout();
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
                          child: ListView.builder(
                            itemCount: viewModel.articles.length,
                            itemBuilder: (context, index) {
                              final article = viewModel.articles[index];
                              return Card(
                                margin: const EdgeInsets.symmetric(
                                  vertical: 4.0,
                                ),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                  onTap:
                                      () =>
                                          _navigateToArticle(context, article),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
        );
      },
    );
  }
}
