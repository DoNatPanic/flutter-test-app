import 'package:olkonapp/domain/user_repository.dart';
import 'package:olkonapp/services/shared_preferences.dart';

class UserRepositoryImpl implements UserRepository {
  final SharedPreferencesService sharedPreferencesService;

  static const String _userNameSP = 'userName';
  static const String _isLoggedInSP = 'isLoggedIn';

  bool _isLoggedIn = false;
  String? _userName;
  final bool isLoggedIn = false;
  final String? userName = null;

  @override
  bool get getIsLoggedIn => _isLoggedIn;

  @override
  String? get getUserName => _userName;

  UserRepositoryImpl({required this.sharedPreferencesService});

  @override
  Future<void> loadUserData() async {
    // извлекаем данные из SharedPreferences
    _userName = await sharedPreferencesService.getString(_userNameSP);
    _isLoggedIn =
        await sharedPreferencesService.getBool(_isLoggedInSP) ?? false;
  }

  @override
  Future<void> logout() async {
    _isLoggedIn = false;
    await sharedPreferencesService.saveBool(_isLoggedInSP, _isLoggedIn);
  }

  @override
  Future<bool> login(String name, String password) async {
    _userName = name;
    _isLoggedIn = true;
    // Записываем данные в SharedPreferences
    await sharedPreferencesService.saveString(_userNameSP, _userName!);
    await sharedPreferencesService.saveBool(_isLoggedInSP, _isLoggedIn);

    // always true
    return true;
  }
}
