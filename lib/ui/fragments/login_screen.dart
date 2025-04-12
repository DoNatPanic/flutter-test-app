import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:olkonapp/ui/fragments/news_screen.dart';
import 'package:olkonapp/ui/view_models/login_view_model.dart';

class LoginScreen extends StatelessWidget {
  static const String routeName = 'login';

  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LoginViewModel>(
      builder: (BuildContext context, LoginViewModel viewModel, _) {
        return Scaffold(
          appBar: AppBar(title: const Text('Log In Page')),
          body: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    onChanged: (String value) {
                      viewModel.updateUserName(value); // Обновление пароля
                    },
                    decoration: InputDecoration(
                      labelText: 'Name',
                      labelStyle: const TextStyle(color: Colors.grey),
                      border: const OutlineInputBorder(),
                      errorText: viewModel.validateUserName(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    onChanged: (String value) {
                      viewModel.updatePassword(value); // Обновление пароля
                    },
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      labelStyle: const TextStyle(color: Colors.grey),
                      border: const OutlineInputBorder(),
                      errorText: viewModel.validatePassword(),
                    ),
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed:
                          viewModel.isLoading
                              ? null
                              : () async {
                                await viewModel.login();
                                if (context.mounted &&
                                    !viewModel.isLoginError) {
                                  context.goNamed(NewsScreen.routeName);
                                }
                              },
                      child:
                          viewModel.isLoading
                              ? const CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              )
                              : const Text('Login'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
