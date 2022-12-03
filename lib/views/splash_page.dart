import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flux_mvp/core/common_widgets/app_padding.dart';
import 'package:flux_mvp/core/constants/paths.dart';

import '../routing/router.dart';

class SplashPage extends HookWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    useEffect(() {
      Future.delayed(const Duration(seconds: 3), () {
        AppRouter.navigateToPage(AppRoutes.welcomePage, replace: true);
      });
      return null;
    }, []);

    return Scaffold(
      body: DefaultAppPadding(
        child: Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * .5,
            child: SvgPicture.asset(
              SvgPaths.icLogo,
            ),
          ),
        ),
      ),
    );
  }
}
