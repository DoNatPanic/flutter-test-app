abstract class UserRepository {
  String? get getUserName;
  bool get getIsLoggedIn;
  Future<void> loadUserData();
  Future<void> logout();
  Future<bool> login(String name, String password);
}
