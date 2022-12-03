import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../utils/app_utils.dart';

class PasswordTextField extends HookWidget {
  const PasswordTextField({
    super.key,
    required this.controller,
  });
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final isVisible = useState(false);
    return TextFormField(
      obscureText: !isVisible.value,
      controller: controller,
      validator: AppUtils.passwordValidate,
      decoration: InputDecoration(
        labelText: "Password",
        hintText: "Enter your password",
        prefixIcon: const Icon(Icons.password_outlined),
        suffixIcon: IconButton(
          onPressed: () {
            isVisible.value = !isVisible.value;
          },
          icon: isVisible.value
              ? const Icon(Icons.remove_red_eye)
              : const Icon(Icons.remove_red_eye_outlined),
        ),
      ),
    );
  }
}
