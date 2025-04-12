import 'package:olkonapp/services/shared_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesServiceImpl extends SharedPreferencesService {
  // Получить объект SharedPreferences
  Future<SharedPreferences> _getPreferences() async {
    return await SharedPreferences.getInstance();
  }

  // Сохранение строки
  @override
  Future<void> saveString(String key, String value) async {
    final SharedPreferences prefs = await _getPreferences();
    await prefs.setString(key, value);
  }

  // Получение строки
  @override
  Future<String?> getString(String key) async {
    final SharedPreferences prefs = await _getPreferences();
    return prefs.getString(key);
  }

  // Сохранение целого числа
  @override
  Future<void> saveInt(String key, int value) async {
    final SharedPreferences prefs = await _getPreferences();
    await prefs.setInt(key, value);
  }

  // Получение целого числа
  @override
  Future<int?> getInt(String key) async {
    final SharedPreferences prefs = await _getPreferences();
    return prefs.getInt(key);
  }

  // Сохранение булевого значения
  @override
  Future<void> saveBool(String key, bool value) async {
    final SharedPreferences prefs = await _getPreferences();
    await prefs.setBool(key, value);
  }

  // Получение булевого значения
  @override
  Future<bool?> getBool(String key) async {
    final SharedPreferences prefs = await _getPreferences();
    return prefs.getBool(key);
  }

  // Удаление значения по ключу
  @override
  Future<void> remove(String key) async {
    final SharedPreferences prefs = await _getPreferences();
    await prefs.remove(key);
  }

  // Проверка, существует ли ключ
  @override
  Future<bool> containsKey(String key) async {
    final SharedPreferences prefs = await _getPreferences();
    return prefs.containsKey(key);
  }

  // Очистка всех данных
  @override
  Future<void> clear() async {
    final SharedPreferences prefs = await _getPreferences();
    await prefs.clear();
  }
}
