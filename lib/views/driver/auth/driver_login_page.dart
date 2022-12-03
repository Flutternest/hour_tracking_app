import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flux_mvp/core/common_widgets/app_padding.dart';
import 'package:flux_mvp/core/utils/ui_helper.dart';

import '../../../core/common_widgets/password_field.dart';
import '../../../core/constants/paths.dart';

class DriverLoginPage extends StatelessWidget {
  const DriverLoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          // title: const Text("Driver Login"),
          ),
      body: SafeArea(
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
                decoration: const InputDecoration(
                  labelText: "Email",
                  hintText: "Enter your email",
                  prefixIcon: Icon(Icons.email_outlined),
                ),
              ),
              verticalSpaceRegular,
              const PasswordTextField(),
              verticalSpaceMedium,
              ElevatedButton(
                onPressed: () {},
                child: const Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
