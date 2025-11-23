import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:smart_stock/app/config/api/auth.dart';
import 'package:smart_stock/app/config/preferences_manager.dart';
import 'package:smart_stock/app/data/dtos/login_dto.dart';
import 'package:smart_stock/app/ui/login/login_interface.dart';
import 'package:smart_stock/app/utils/logger.dart';

@RoutePage()
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const LoginContainer();
  }
}

class LoginContainer extends StatefulWidget {
  const LoginContainer({super.key});

  @override
  State<LoginContainer> createState() => _LoginContainerState();
}

class _LoginContainerState extends State<LoginContainer> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      final username = _usernameController.text;
      final password = _passwordController.text;

      try {
        final response = await AuthAPI.login(
          payload: LoginRequestDTO(password: password, username: username),
        );

        if (response.statusCode >= 200 && response.statusCode < 300) {
          if (!mounted) {
            return;
          }
          await PreferencesManager.setNotFirstTimeOnTheApp();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Login realizado com sucesso!!'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );
          await Future.delayed(const Duration(seconds: 2));
          if (mounted) {
            context.router.pop();
          }
        } else if (response.statusCode == 401) {
          if (!mounted) {
            return;
          }
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('E-mail ou senha inválidos!'),
              backgroundColor: Colors.red,
            ),
          );
        } else {
          if (!mounted) {
            return;
          }
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Erro no servidor! Por favor, aguarde.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        if (!mounted) {
          return;
        }
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Erro desconhecido! Por favor, aguarde.'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return LoginInterface(
      formKey: _formKey,
      usernameController: _usernameController,
      passwordController: _passwordController,
      onLogin: _login,
    );
  }
}
