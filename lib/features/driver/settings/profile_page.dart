import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flux_mvp/core/utils/ui_helper.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/common_widgets/app_padding.dart';
import '../../../global_providers.dart';
import '../controllers/update_driver_controller.dart';

class DriverProfilePage extends HookConsumerWidget {
  const DriverProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider);
    final idController =
        useTextEditingController(text: currentUser?.eldSerialId);
    final nameController = useTextEditingController(text: currentUser?.name);
    final emailController = useTextEditingController(text: currentUser?.email);

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
                verticalSpaceLarge,
                Consumer(
                  builder: (context, ref, child) {
                    final updateDriverAsync = ref.watch(updateDriverProvider);
                    return ElevatedButton(
                      onPressed: updateDriverAsync.isLoading
                          ? null
                          : () {
                              final updatedUser = currentUser!.copyWith(
                                name: nameController.text,
                                email: emailController.text,
                                eldSerialId: idController.text,
                              );
                              ref
                                  .read(updateDriverProvider.notifier)
                                  .updateDriver(
                                    currentUser.uid!,
                                    updatedUser,
                                  )
                                  .then((value) => showSnackBar(context,
                                      message: "Profile updated successfully"));
                            },
                      child: Text(updateDriverAsync.isLoading
                          ? "Updating..."
                          : "Update Profile"),
                    );
                  },
                ),
                verticalSpaceMedium,
              ],
            ),
          ),
        ));
  }
}
