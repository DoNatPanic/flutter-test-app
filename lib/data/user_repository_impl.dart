import 'package:olkonapp/domain/user_repository.dart';
import 'package:olkonapp/services/shared_preferences.dart';

class UserRepositoryImpl implements UserRepository {
  final SharedPreferencesService spService;

  UserRepositoryImpl({required this.spService});

  bool _isLoggedIn = false;
  String? _userName;
  static const String _userNameSP = 'userName';
  static const String _isLoggedInSP = 'isLoggedIn';

  final bool isLoggedIn = false;
  final String? userName = null;

  @override
  bool getIsLoggedIn() {
    return _isLoggedIn;
  }

  @override
  String? getUserName() {
    return _userName;
  }

  @override
  Future<void> loadUserData() async {
    _userName = await spService.getString(_userNameSP);
    _isLoggedIn = await spService.getBool(_isLoggedInSP) ?? false;
  }

  @override
  Future<void> logout() async {
    _isLoggedIn = false;
    await spService.saveBool(_isLoggedInSP, _isLoggedIn);
  }

  @override
  Future<bool> login(String name, String password) async {
    _userName = name;
    _isLoggedIn = true;
    // Записываем данные в SharedPreferences
    await spService.saveString(_userNameSP, _userName!);
    await spService.saveBool(_isLoggedInSP, _isLoggedIn);

    // always true
    return true;
  }
}
