import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flux_mvp/core/common_widgets/app_padding.dart';
import 'package:flux_mvp/core/extensions/async_extension.dart';
import 'package:flux_mvp/core/utils/app_utils.dart';
import 'package:flux_mvp/core/utils/ui_helper.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../auth/auth_controller.dart';
import '../../../core/common_widgets/password_field.dart';
import '../../../core/constants/paths.dart';

class DriverLoginPage extends HookConsumerWidget {
  const DriverLoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<void> state = ref.watch(authControllerProvider);
    ref.listen<AsyncValue>(
        authControllerProvider, (_, state) => state.handleErrors(context, ref));

    final TextEditingController emailController = useTextEditingController();
    final TextEditingController passwordController = useTextEditingController();
    final formKey = useMemoized(() => GlobalKey<FormState>());

    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: DefaultAppPadding(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  verticalSpaceMedium,
                  Center(
                    child: Hero(
                      tag: "logo",
                      child: SvgPicture.asset(
                        SvgPaths.icLogo,
                        width: 200,
                      ),
                    ),
                  ),
                  verticalSpaceMedium,
                  Text(
                    "Driver Login",
                    style: textTheme(context).subtitle1,
                    textAlign: TextAlign.center,
                  ),
                  verticalSpaceLarge,
                  Text(
                    "Enter your login credentials",
                    style: textTheme(context).subtitle1,
                  ),
                  verticalSpaceMedium,
                  TextFormField(
                    controller: emailController,
                    validator: AppUtils.emailValidate,
                    decoration: const InputDecoration(
                      labelText: "Email",
                      hintText: "Enter your email",
                      prefixIcon: Icon(Icons.email_outlined),
                    ),
                  ),
                  verticalSpaceRegular,
                  PasswordTextField(
                    controller: passwordController,
                  ),
                  verticalSpaceMedium,
                  ElevatedButton(
                    onPressed: state.isLoading
                        ? null
                        : () {
                            if (formKey.currentState!.validate()) {
                              ref.read(authControllerProvider.notifier).login(
                                  email: emailController.text.trim(),
                                  password: passwordController.text.trim());
                            }
                          },
                    child: Text(state.isLoading ? 'Logging in' : 'Login'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
