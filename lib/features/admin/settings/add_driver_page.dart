import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flux_mvp/core/common_widgets/app_padding.dart';
import 'package:flux_mvp/core/utils/ui_helper.dart';

class AddDriverPage extends HookWidget {
  const AddDriverPage({super.key});

  @override
  Widget build(BuildContext context) {
    final eldIdController = useTextEditingController(text: "");
    final nameController = useTextEditingController(text: "");
    final emailController = useTextEditingController(text: "");

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Driver'),
      ),
      body: DefaultAppPadding(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
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
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                hintText: 'Enter your name',
              ),
            ),
            verticalSpaceSmall,
            TextFormField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                hintText: 'Enter your email',
              ),
            ),
            verticalSpaceSmall,
            TextFormField(
              controller: eldIdController,
              decoration: const InputDecoration(
                labelText: 'ELD ID',
                hintText: 'Enter your ELD ID',
              ),
            ),
            const Spacer(),
            const ElevatedButton(
              onPressed: null,
              child: Text("Add Driver"),
            ),
          ],
        ),
      ),
    );
  }
}
