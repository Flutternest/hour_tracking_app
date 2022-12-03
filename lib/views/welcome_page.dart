import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flux_mvp/core/utils/ui_helper.dart';

import '../core/common_widgets/app_padding.dart';
import '../core/constants/paths.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultAppPadding(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              SvgPaths.icLogo,
              width: 200,
              height: 200,
            ),
            verticalSpaceMedium,
            Text(
              'Next-Generation Payroll For Trucking Industry',
              style: Theme.of(context).textTheme.bodyText1,
            ),
            verticalSpaceMedium,
            ElevatedButton(
              onPressed: () {},
              child: const Text('Get Started'),
            ),
          ],
        ),
      ),
    );
  }
}
