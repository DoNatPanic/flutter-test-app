import 'package:flutter/material.dart';
import 'package:olkonapp/data/converters/article_converter.dart';
import 'package:olkonapp/data/news_repository_impl.dart';
import 'package:olkonapp/data/user_repository_impl.dart';
import 'package:olkonapp/domain/news_repository.dart';
import 'package:olkonapp/domain/user_repository.dart';
import 'package:olkonapp/router.dart';
import 'package:olkonapp/services/news_api.dart';
import 'package:olkonapp/services/shared_preferences.dart';
import 'package:olkonapp/ui/fragments/news_screen.dart';
import 'package:olkonapp/ui/view_models/article_view_model.dart';
import 'package:olkonapp/ui/view_models/login_view_model.dart';
import 'package:olkonapp/ui/view_models/news_view_model.dart';
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
        ChangeNotifierProvider(
          create:
              (context) => NewsViewModel(
                newsRepository: context.read<NewsRepository>(),
                userRepository: context.read<UserRepository>(),
              ),
          child: const NewsScreen(),
        ),
        ChangeNotifierProvider(
          create:
              (context) => ArticleViewModel(
                userRepository: context.read<UserRepository>(),
              ),
        ),
        ChangeNotifierProvider<LoginViewModel>(
          create:
              (context) => LoginViewModel(
                userRepository: context.read<UserRepository>(),
              ),
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
              var router = getRouter(userRepository); // Получаем роутер

              return MaterialApp.router(
                debugShowCheckedModeBanner: false,
                routerConfig: router,
              );
            }),
          );
        }),
      ),
    );
  }
}
