import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:smart_stock/app/config/api/auth.dart';
import 'package:smart_stock/app/config/preferences_manager.dart';
import 'package:smart_stock/app/data/dtos/login_dto.dart';
import 'package:smart_stock/app/routing/router.dart';
import 'package:smart_stock/app/ui/login/login_interface.dart';

@RoutePage()
class LoginScreen extends StatefulWidget {
  const LoginScreen({this.shouldRedirect = false});

  final bool shouldRedirect;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  late final _usernameSelectController = FSelectController<String>(vsync: this);

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _usernameSelectController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      final username = _usernameSelectController.value ?? _usernameController.text;
      final password = _passwordController.text;

      try {
        final response = await AuthAPI.login(
          payload: LoginRequestDTO(password: password, username: username),
        );

        if (response.statusCode >= 200 && response.statusCode < 300) {
          if (!mounted) {
            return;
          }

          if (widget.shouldRedirect) {
            context.router.replaceAll([const HomeRoute()]);
          } else {
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
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Erro desconhecido! Por favor, aguarde.'),
            backgroundColor: Colors.red,
          ),
        );

        rethrow;
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
      usernameSelectController: _usernameSelectController,
    );
  }
}
