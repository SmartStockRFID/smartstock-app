import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:forui/forui.dart';
import 'package:smart_stock/app/config/assets.dart';
import 'package:smart_stock/app/config/constants.dart';
import 'package:smart_stock/app/ui/_shared/auth_text_field.dart';
import 'package:smart_stock/app/ui/_themes/custom_forui.dart';

class LoginInterface extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController usernameController;
  final TextEditingController passwordController;
  final VoidCallback onLogin;

  const LoginInterface({
    super.key,
    required this.formKey,
    required this.usernameController,
    required this.passwordController,
    required this.onLogin,
  });

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: screenWidth,
            padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 56.0),
            constraints: BoxConstraints(
              minHeight: screenHeight * 0.4,
              maxHeight: screenHeight * 0.78,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                if (useNewlandTheme)
                  SvgPicture.asset(
                    Assets.newlandLogo,
                    color: Colors.black,
                    height: MediaQuery.of(context).size.height / 24,
                  )
                else
                  Icon(
                    FIcons.origami,
                    size: MediaQuery.of(context).size.height / 24,
                    color: Colors.black,
                  ),
                _buildWelcomeText(context),
                const SizedBox(height: 12),
                Text(
                  'Digite seu nome de usuário e senha',
                  textAlign: TextAlign.center,
                  style: context.theme.typography.sm,
                ),
                const SizedBox(height: 48.0),
                _buildForm(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeText(BuildContext context) {
    return Text(
      'Fazer login',
      textAlign: TextAlign.center,
      style: context.theme.typography.xl2.copyWith(fontWeight: FontWeight.bold),
    );
  }

  Widget _buildForm(BuildContext context) {
    return Expanded(
      child: Center(
        child: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                buildInputField(
                  context: context,
                  controller: usernameController,
                  labelText: 'Usuário',
                  obscureText: false,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Insira seu nome de usuário';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                buildInputField(
                  context: context,
                  controller: passwordController,
                  keyboardType: TextInputType.number,
                  labelText: 'Senha',
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Insira sua senha';
                    } else if (value.length < 6) {
                      return 'A senha deve ter pelo menos 6 caracteres';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24.0),
                const Spacer(),
                Text(
                  'Não tem uma conta?\nContate o administrador do sistema.',
                  textAlign: TextAlign.center,
                  style: context.theme.typography.sm,
                ),
                const SizedBox(height: 12),

                FButton(
                  onPress: onLogin,
                  style: primaryLargeButton(context),
                  child: Text(
                    'Entrar',
                    style: context.theme.typography.xl2.copyWith(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
