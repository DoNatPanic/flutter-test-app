abstract class UserRepository {
  Future<void> loadUserData();
  Future<void> logout();
  Future<bool> login(String name, String password);
  String? getUserName();
  bool getIsLoggedIn();
}
