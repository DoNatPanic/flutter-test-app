import 'package:flutter/material.dart';
import 'package:olkonapp/domain/repositories/user_repository.dart';

class LoginViewModel extends ChangeNotifier {
  final UserRepository userRepository;

  bool _isLoading = false;
  String _userName = '';
  String _password = '';
  bool _isLoginError = false;
  bool _isSubmitting = false; // Флаг для отслеживания попытки отправки формы

  LoginViewModel({required this.userRepository});

  bool get isLoading => _isLoading;
  bool get isLoginError => _isLoginError;

  // Метод для обновления имени пользователя
  void updateUserName(String value) {
    _userName = value;
    notifyListeners(); // Обновление состояния модели
  }

  // Метод для обновления пароля
  void updatePassword(String value) {
    _password = value;
    notifyListeners(); // Обновление состояния модели
  }

  // Валидация имени пользователя
  String? validateUserName() {
    return _isSubmitting && _userName.isEmpty ? 'Enter your name' : null;
  }

  // Валидация пароля
  String? validatePassword() {
    return _isSubmitting && _password.isEmpty ? 'Enter your password' : null;
  }

  // Авторизация с валидацией
  Future<void> login() async {
    _isSubmitting = true; // Устанавливаем флаг, что форма пытается отправиться
    notifyListeners();

    // Проверка валидности данных при нажатии кнопки
    String? userNameError = validateUserName();
    String? passwordError = validatePassword();

    // Если есть ошибки, возвращаем и не продолжаем
    if (userNameError != null || passwordError != null) {
      _isLoginError = true;
      notifyListeners();
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      await userRepository.login(_userName.trim(), _password.trim());
      clearData(); // Очистить данные после успешного входа
      _isLoginError = false;
    } catch (e) {
      _isLoginError = true;
    } finally {
      _isLoading = false;
      _isSubmitting = false; // Сбрасываем флаг после попытки авторизации
      notifyListeners();
    }
  }

  // Очистка данных
  void clearData() {
    _userName = '';
    _password = '';
    notifyListeners();
  }
}
