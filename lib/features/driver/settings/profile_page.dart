import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flux_mvp/core/utils/ui_helper.dart';

import '../../../core/common_widgets/app_padding.dart';

class DriverProfilePage extends HookWidget {
  const DriverProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final idController = useTextEditingController(text: "1234-5678");
    final nameController = useTextEditingController(text: "John Doe");
    final emailController = useTextEditingController(text: "john@mail.com");

    return Scaffold(
        appBar: AppBar(
          title: const Text("Profile"),
        ),
        body: SafeArea(
          child: DefaultAppPadding.horizontal(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                verticalSpaceMedium,
                CircleAvatar(
                  radius: 50,
                  child: ValueListenableBuilder(
                      valueListenable: nameController,
                      builder: (context, value, child) {
                        return Text(
                          nameController.text.isNotEmpty
                              ? value.text[0].toUpperCase()
                              : "#",
                          style: textTheme(context).headlineMedium,
                        );
                      }),
                ),
                verticalSpaceMedium,
                TextFormField(
                  controller: idController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.fingerprint),
                    labelText: "ID",
                    hintText: "Enter your ID",
                  ),
                ),
                verticalSpaceMedium,
                TextFormField(
                  controller: nameController,
                  keyboardType: TextInputType.name,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.person_outline),
                    labelText: "Name",
                    hintText: "Enter your name",
                  ),
                ),
                verticalSpaceMedium,
                TextFormField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.email_outlined),
                    labelText: "Email",
                    hintText: "Enter your email address",
                  ),
                ),
                const Spacer(),
                verticalSpaceMedium,
                ElevatedButton(
                  onPressed: () {},
                  child: const Text("Update Profile"),
                )
              ],
            ),
          ),
        ));
  }
}
