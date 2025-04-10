import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:olkonapp/data/converters/article_converter.dart';
import 'package:olkonapp/data/news_repository_impl.dart';
import 'package:olkonapp/data/user_repository_impl.dart';
import 'package:olkonapp/domain/models/article.dart';
import 'package:olkonapp/domain/news_repository.dart';
import 'package:olkonapp/domain/user_repository.dart';
import 'package:olkonapp/services/news_api.dart';
import 'package:olkonapp/services/shared_preferences.dart';
import 'package:olkonapp/ui/login_screen.dart';
import 'package:olkonapp/ui/news_screen.dart';
import 'package:olkonapp/ui/article_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<void> _loadStates() async {
    // TODO load some SP data
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (context) => SharedPreferencesService()),
        Provider(create: (context) => NewsApiService()),
        Provider(create: (context) => ArticleConverter()),
        Provider(
          create:
              (context) =>
                  UserRepositoryImpl(spService: context.read())
                      as UserRepository,
        ),
        Provider(
          create:
              (context) =>
                  NewsRepositoryImpl(
                        newsApiService: context.read(),
                        articleConverter: context.read(),
                      )
                      as NewsRepository,
        ),
      ],
      child: FutureBuilder(
        future: _loadStates(),
        builder: ((context, snapshot) {
          var userRepository = Provider.of<UserRepository>(
            context,
            listen: false,
          );

          return FutureBuilder(
            future: userRepository.loadUserData(),
            builder: ((context, snapshot) {
              final GoRouter _router = GoRouter(
                initialLocation: '/${LoginScreen.routeName}',
                routes: [
                  GoRoute(
                    path: '/${LoginScreen.routeName}',
                    name: LoginScreen.routeName,
                    builder: (context, state) => const LoginScreen(),
                  ),
                  GoRoute(
                    path: '/${NewsScreen.routeName}',
                    name: NewsScreen.routeName,
                    builder: (context, state) => const NewsScreen(),
                    routes: [
                      GoRoute(
                        path: ArticleScreen.routeName,
                        name: ArticleScreen.routeName,
                        builder: (context, state) {
                          final article = state.extra as Article;
                          return ArticleScreen(article: article);
                        },
                      ),
                    ],
                  ),
                ],
                redirect: (context, state) {
                  if (userRepository.getIsLoggedIn()) {
                    return '/${NewsScreen.routeName}';
                  }
                  // no need to redirect at all
                  return null;
                },
              );

              return MaterialApp.router(
                debugShowCheckedModeBanner: false,
                routerConfig: _router,
              );
            }),
          );
        }),
      ),
    );
  }
}
