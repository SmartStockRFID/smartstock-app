import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/experimental/mutation.dart';
import 'package:flutter_svg/svg.dart';
import 'package:forui/forui.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:smart_stock/app/config/assets.dart';
import 'package:smart_stock/app/config/constants.dart';
import 'package:smart_stock/app/config/preferences_manager.dart';
import 'package:smart_stock/app/ui/_core/theme/custom_forui.dart';
import 'package:smart_stock/app/ui/_core/widgets/auth_text_field.dart';
import 'package:smart_stock/app/ui/_core/widgets/loading_widget.dart';

const notOnLoginsText = 'Não está listado?';

final backendUrlProvider = FutureProvider.autoDispose<String>((ref) async {
  return AppConfig.getBackUrl();
});

final loginMutation = Mutation<void>();

final savedInfoProvider = FutureProvider.autoDispose<(String?, List<String>?)>((ref) async {
  final [currentUser, savedLogins] = await Future.wait([
    CurrentUserStorage.getValue(),
    SavedLoginsStorage.getValues(),
  ]);
  return (currentUser as String?, savedLogins as List<String>?);
});

class LoginForm extends HookConsumerWidget {
  final GlobalKey<FormState> formKey;
  final GlobalKey<FormState> newBackendServerURLFormKey;
  final TextEditingController newBackendServerURLController;
  final TextEditingController usernameController;
  final TextEditingController passwordController;
  final FSelectController<String> usernameSelectController;
  final Future<void> Function() onLogin;
  final BuildContext context;
  const LoginForm({
    super.key,
    required this.newBackendServerURLFormKey,
    required this.formKey,
    required this.newBackendServerURLController,
    required this.usernameController,
    required this.passwordController,
    required this.onLogin,
    required this.context,
    required this.usernameSelectController,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wantToUseSelect = useState(true);

    Widget usernameInputField() => buildInputField(
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
    );

    final loginPending = ref.watch(loginMutation.select((state) => state is MutationPending));

    return Expanded(
      child: Center(
        child: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ref
                    .watch(savedInfoProvider)
                    .when(
                      data: (data) {
                        final String? currentUser = data.$1;
                        final List<String>? savedLogins = data.$2;

                        if (wantToUseSelect.value &&
                            savedLogins != null &&
                            savedLogins.isNotEmpty &&
                            currentUser != null) {
                          return FSelect<String>.rich(
                            style: (style) => style.copyWith(
                              selectFieldStyle: (contStyle) => contStyle.copyWith(
                                hintTextStyle: FWidgetStateMap.all(context.theme.typography.sm),
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 21, // AUMENTA ALTURA
                                  horizontal: 8,
                                ),
                              ),
                            ),
                            onChange: (value) {
                              if (value == notOnLoginsText) {
                                wantToUseSelect.value = false;
                              }
                            },
                            controller: usernameSelectController,
                            autofocus: true,
                            hint: 'Selecione seu usuário',
                            format: (s) => s,
                            // validator: _validateDepartment,
                            children: [
                              for (final login in [...savedLogins, notOnLoginsText])
                                FSelectItem(title: Text(login), value: login),
                            ],
                          );
                        } else {
                          return usernameInputField();
                        }
                      },
                      error: (err, trace) {
                        return usernameInputField();
                      },
                      loading: () {
                        return const Expanded(child: LoadingWidget());
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
                ref
                    .watch(backendUrlProvider)
                    .when(
                      data: (backendUrl) {
                        return InkWell(
                          onTap: () => showDialog(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              title: Text('Mudar servidor', style: context.theme.typography.xl2),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                spacing: 24,
                                children: [
                                  Text.rich(
                                    TextSpan(
                                      children: [
                                        TextSpan(
                                          text: 'Atual: ',
                                          style: context.theme.typography.sm.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextSpan(
                                          text: backendUrl,
                                          style: context.theme.typography.sm,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Form(
                                    key: newBackendServerURLFormKey,
                                    child: buildInputField(
                                      context: context,
                                      controller: newBackendServerURLController,
                                      labelText: 'URL do novo servidor',
                                      obscureText: false,
                                      validator: (value) =>
                                          (Uri.tryParse(
                                                newBackendServerURLController.text,
                                              )?.host.isNotEmpty ??
                                              false)
                                          ? null
                                          : 'Não é uma URL válida',
                                    ),
                                  ),
                                ],
                              ),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () => Navigator.pop(context, 'Cancel'),
                                  child: const Text('Cancelar'),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    final formOk = newBackendServerURLFormKey.currentState
                                        ?.validate();
                                    if (formOk == true) {
                                      await BackendApiUrlStorage.setValue(
                                        newBackendServerURLController.text,
                                      );
                                      ref.invalidate(backendUrlProvider, asReload: true);
                                      newBackendServerURLController.text = '';
                                      if (context.mounted) {
                                        Navigator.pop(context);
                                      }
                                    }
                                  },
                                  child: const Text('OK'),
                                ),
                              ],
                            ),
                          ),

                          child: ref
                              .watch(backendUrlProvider)
                              .when(
                                data: (backendUrl) {
                                  return SizedBox(
                                    height: 64,
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      spacing: 5,
                                      children: [
                                        Flexible(
                                          child: Text.rich(
                                            overflow: TextOverflow.ellipsis,
                                            TextSpan(
                                              children: [
                                                const TextSpan(text: 'Conectando-se a: '),
                                                TextSpan(
                                                  text:
                                                      Uri.tryParse(backendUrl)?.host ??
                                                      'Servidor desconhecido',
                                                  style: context.theme.typography.sm.copyWith(
                                                    color: Colors.blueAccent,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            style: context.theme.typography.sm,
                                          ),
                                        ),
                                        Icon(
                                          FIcons.chevronDown,
                                          size: context.theme.typography.sm.fontSize,
                                          color: Colors.blueAccent,
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                error: (err, trace) => const SizedBox(),
                                loading: () => const SizedBox(),
                              ),
                        );
                      },
                      error: (err, trace) => const SizedBox(),
                      loading: () => const SizedBox(),
                    ),
                FButton(
                  onPress: () {
                    if (loginPending) {
                      return;
                    }
                    loginMutation.run(ref, (tsx) async {
                      await onLogin();
                    });
                  },
                  style: primaryLargeButton(context, disabled: loginPending),
                  child: Text(
                    loginPending ? 'Entrando...' : 'Entrar',
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

class LoginInterface extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final GlobalKey<FormState> newBackendServerURLFormKey;
  final TextEditingController newBackendServerURLController;
  final TextEditingController usernameController;
  final TextEditingController passwordController;
  final Future<void> Function() onLogin;
  final FSelectController<String> usernameSelectController;

  const LoginInterface({
    super.key,
    required this.formKey,
    required this.newBackendServerURLFormKey,
    required this.newBackendServerURLController,
    required this.usernameController,
    required this.passwordController,
    required this.onLogin,
    required this.usernameSelectController,
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
                if (AppConfig.useNewlandTheme)
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
                LoginForm(
                  newBackendServerURLFormKey: newBackendServerURLFormKey,
                  newBackendServerURLController: newBackendServerURLController,
                  formKey: formKey,
                  usernameSelectController: usernameSelectController,
                  usernameController: usernameController,
                  passwordController: passwordController,
                  onLogin: onLogin,
                  context: context,
                ),
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
}
