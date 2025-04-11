import 'package:flutter/material.dart';
import 'package:olkonapp/domain/user_repository.dart';

class LoginViewModel extends ChangeNotifier {
  final UserRepository _userRepository;
  bool _isLoading = false;

  LoginViewModel({required UserRepository userRepository})
    : _userRepository = userRepository;

  bool get isLoading => _isLoading;

  // Контроллеры для полей ввода
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Валидация формы
  String? validateUserName(String? value) {
    return (value == null || value.isEmpty) ? 'Enter your name' : null;
  }

  String? validatePassword(String? value) {
    return (value == null || value.isEmpty) ? 'Enter your password' : null;
  }

  // Авторизация
  Future<void> login() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _userRepository.login(
        userNameController.text.trim(),
        passwordController.text.trim(),
      );
      clearControllers();
    } catch (e) {
      // Обработать ошибки, если необходимо
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearControllers() {
    userNameController.clear();
    passwordController.clear();
  }

  @override
  void dispose() {
    userNameController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
