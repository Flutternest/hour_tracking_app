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
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: SizedBox(
                width: 200,
                child: SvgPicture.asset(
                  SvgPaths.icLogo,
                ),
              ),
            ),
            verticalSpaceSemiLarge,
            Text(
              'Next-Generation Payroll For Trucking Industry',
              style: Theme.of(context).textTheme.bodyText1,
              textAlign: TextAlign.center,
            ),
            verticalSpaceSemiLarge,
            ElevatedButton(
              onPressed: () {},
              child: const Text('Admin Login'),
            ),
            verticalSpaceRegular,
            Row(
              children: [
                Expanded(
                  child: Divider(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                horizontalSpaceRegular,
                Text(
                  'Or',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                horizontalSpaceRegular,
                Expanded(
                  child: Divider(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),
            verticalSpaceRegular,
            ElevatedButton(
              onPressed: () {},
              child: const Text('Driver Login'),
            ),
          ],
        ),
      ),
    );
  }
}
