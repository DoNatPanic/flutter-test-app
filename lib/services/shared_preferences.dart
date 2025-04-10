import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  // Получить объект SharedPreferences
  Future<SharedPreferences> _getPreferences() async {
    return await SharedPreferences.getInstance();
  }

  // Сохранение строки
  Future<void> saveString(String key, String value) async {
    final prefs = await _getPreferences();
    await prefs.setString(key, value);
  }

  // Получение строки
  Future<String?> getString(String key) async {
    final prefs = await _getPreferences();
    return prefs.getString(key);
  }

  // Сохранение целого числа
  Future<void> saveInt(String key, int value) async {
    final prefs = await _getPreferences();
    await prefs.setInt(key, value);
  }

  // Получение целого числа
  Future<int?> getInt(String key) async {
    final prefs = await _getPreferences();
    return prefs.getInt(key);
  }

  // Сохранение булевого значения
  Future<void> saveBool(String key, bool value) async {
    final prefs = await _getPreferences();
    await prefs.setBool(key, value);
  }

  // Получение булевого значения
  Future<bool?> getBool(String key) async {
    final prefs = await _getPreferences();
    return prefs.getBool(key);
  }

  // Удаление значения по ключу
  Future<void> remove(String key) async {
    final prefs = await _getPreferences();
    await prefs.remove(key);
  }

  // Проверка, существует ли ключ
  Future<bool> containsKey(String key) async {
    final prefs = await _getPreferences();
    return prefs.containsKey(key);
  }

  // Очистка всех данных
  Future<void> clear() async {
    final prefs = await _getPreferences();
    await prefs.clear();
  }
}
