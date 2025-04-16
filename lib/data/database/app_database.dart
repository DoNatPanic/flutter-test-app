// database.dart

// required package imports
import 'dart:async';
import 'package:floor/floor.dart';
import 'package:olkonapp/data/database/article_dao.dart';
import 'package:olkonapp/data/database/article_entity.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

part 'app_database.g.dart'; // the generated code will be there

@Database(version: 1, entities: <Type>[ArticleEntity])
abstract class AppDatabase extends FloorDatabase {
  ArticleDao get articleDao;
}
