abstract class SharedPreferencesService {
  // Сохранение строки
  Future<void> saveString(String key, String value);

  // Получение строки
  Future<String?> getString(String key);

  // Сохранение целого числа
  Future<void> saveInt(String key, int value);

  // Получение целого числа
  Future<int?> getInt(String key);

  // Сохранение булевого значения
  Future<void> saveBool(String key, bool value);

  // Получение булевого значения
  Future<bool?> getBool(String key);

  // Удаление значения по ключу
  Future<void> remove(String key);

  // Проверка, существует ли ключ
  Future<bool> containsKey(String key);

  // Очистка всех данных
  Future<void> clear();
}
