import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:olkonapp/data/converters/article_converter.dart';
import 'package:olkonapp/data/news_repository_impl.dart';
import 'package:olkonapp/data/user_repository_impl.dart';
import 'package:olkonapp/domain/news_repository.dart';
import 'package:olkonapp/domain/user_repository.dart';
import 'package:olkonapp/router.dart';
import 'package:olkonapp/services/news_api.dart';
import 'package:olkonapp/services/news_api_impl.dart';
import 'package:olkonapp/services/shared_preferences.dart';
import 'package:olkonapp/services/shared_preferences_impl.dart';
import 'package:olkonapp/ui/fragments/news_screen.dart';
import 'package:olkonapp/ui/view_models/article_view_model.dart';
import 'package:olkonapp/ui/view_models/login_view_model.dart';
import 'package:olkonapp/ui/view_models/news_view_model.dart';
import 'package:provider/provider.dart';

void main() async {
  await dotenv.load();
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<SharedPreferencesService>(
          create: (BuildContext context) => SharedPreferencesServiceImpl(),
        ),
        Provider<NewsApiService>(
          create: (BuildContext context) => NewsApiServiceImpl(),
        ),
        Provider<ArticleConverter>(
          create: (BuildContext context) => ArticleConverter(),
        ),
        Provider<UserRepository>(
          create:
              (BuildContext context) =>
                  UserRepositoryImpl(sharedPreferencesService: context.read())
                      as UserRepository,
        ),
        Provider<NewsRepository>(
          create:
              (BuildContext context) =>
                  NewsRepositoryImpl(
                        newsApiService: context.read(),
                        articleConverter: context.read(),
                      )
                      as NewsRepository,
        ),
        ChangeNotifierProvider<NewsViewModel>(
          create:
              (BuildContext context) => NewsViewModel(
                newsRepository: context.read<NewsRepository>(),
                userRepository: context.read<UserRepository>(),
              ),
          child: const NewsScreen(),
        ),
        ChangeNotifierProvider<ArticleViewModel>(
          create:
              (BuildContext context) => ArticleViewModel(
                userRepository: context.read<UserRepository>(),
              ),
        ),
        ChangeNotifierProvider<LoginViewModel>(
          create:
              (BuildContext context) => LoginViewModel(
                userRepository: context.read<UserRepository>(),
              ),
        ),
      ],
      child: FutureBuilder<void>(
        future: _loadStates(),
        builder: ((BuildContext context, AsyncSnapshot<void> snapshot) {
          UserRepository userRepository = Provider.of<UserRepository>(
            context,
            listen: false,
          );

          return FutureBuilder<void>(
            future: userRepository.loadUserData(),
            builder: ((BuildContext context, AsyncSnapshot<void> snapshot) {
              GoRouter router = getRouter(userRepository); // Получаем роутер

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

  Future<void> _loadStates() async {
    // TODO load some SP data
  }
}
