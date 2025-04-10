import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:olkonapp/domain/models/article.dart';
import 'package:olkonapp/domain/news_repository.dart';
import 'package:olkonapp/domain/user_repository.dart';
import 'package:olkonapp/ui/login_screen.dart';
import 'package:olkonapp/ui/article_screen.dart';
import 'package:provider/provider.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  static const routeName = 'news';

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  late UserRepository _userRepository;
  late NewsRepository _newsRepository;
  late Future<List<Article>> news;
  final _searchFieldController = TextEditingController();

  @override
  void initState() {
    _userRepository = Provider.of<UserRepository>(context, listen: false);
    _newsRepository = Provider.of<NewsRepository>(context, listen: false);
    news = _newsRepository.getNewsList(_searchFieldController.text);
    super.initState();
  }

  void navigateToArticle(Article article, {isScrollable = false}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) =>
                ArticleScreen(article: article, scrollToComments: isScrollable),
      ),
    );
    //почему не работает с GoRouter?
    // GoRouter.of(context).pushNamed(
    //   'article',
    //   extra: article,
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('News'),
        automaticallyImplyLeading: false,
      ),
      body: FutureBuilder(
        future: news,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('No data available'));
          } else {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Expanded(
                    flex: 1,
                    child: TextField(
                      controller: _searchFieldController,
                      decoration: const InputDecoration(
                        labelText: 'Enter text',
                        suffixIcon: Icon(Icons.search),
                        labelStyle: TextStyle(color: Colors.grey),
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text("${_userRepository.getUserName()}"),
                        SizedBox(width: 8.0),
                        IconButton(
                          icon: const Icon(Icons.exit_to_app),
                          tooltip: 'Log Out',
                          iconSize: 30.0,
                          onPressed: () async {
                            await _userRepository.logout();
                            if (context.mounted) {
                              context.goNamed(LoginScreen.routeName);
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 8,
                    child: ListView.builder(
                      itemCount:
                          snapshot
                              .data!
                              .length, // Количество элементов в списке
                      itemBuilder: (context, index) {
                        return Card(
                          margin: EdgeInsets.symmetric(
                            vertical: 4.0,
                          ), // Отступы между карточками
                          elevation: 4.0, // Тень под карточкой
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              10,
                            ), // Скругление углов
                          ),
                          child: ListTile(
                            contentPadding: EdgeInsets.all(16.0),

                            title: Text(
                              snapshot.data![index].title, // Текст на карточке
                              style: TextStyle(fontSize: 18),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  snapshot.data![index].description,
                                  maxLines: 2, // Максимальное количество строк
                                  overflow:
                                      TextOverflow
                                          .ellipsis, // Троеточие в конце
                                  style: TextStyle(fontSize: 16),
                                ),

                                TextButton(
                                  onPressed:
                                      () => navigateToArticle(
                                        snapshot.data![index],
                                        isScrollable: true,
                                      ),
                                  child: Text(
                                    "Comments (${snapshot.data![index].commentsCount})",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            onTap:
                                () => navigateToArticle(snapshot.data![index]),
                          ),
                        );
                      },
                      // );
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
