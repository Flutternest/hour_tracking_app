import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class PasswordTextField extends HookWidget {
  const PasswordTextField({super.key});

  @override
  Widget build(BuildContext context) {
    final isVisible = useState(false);
    return TextFormField(
      obscureText: !isVisible.value,
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
