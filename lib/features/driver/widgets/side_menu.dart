import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flux_mvp/auth/auth_controller.dart';
import 'package:flux_mvp/core/constants/paths.dart';
import 'package:flux_mvp/routing/router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/constants/colors.dart';

class DriverDrawer extends HookConsumerWidget {
  const DriverDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: kDarkBackground,
            ),
            child: Center(
              child: SvgPicture.asset(
                SvgPaths.icLogo,
                width: 100,
              ),
            ),
          ),
          Expanded(
            child: SafeArea(
              top: false,
              right: false,
              left: false,
              child: Column(
                children: [
                  ListTile(
                    title: const Text('My Profile'),
                    horizontalTitleGap: 5,
                    leading: const Icon(Icons.person),
                    onTap: () {
                      AppRouter.navigateToPage(AppRoutes.driverProfilePage);
                    },
                  ),
                  ListTile(
                    title: const Text('My Earnings'),
                    horizontalTitleGap: 5,
                    leading: const Icon(Icons.attach_money),
                    onTap: () {
                      AppRouter.navigateToPage(AppRoutes.driverEarningsPage);
                    },
                  ),
                  ListTile(
                    title: const Text('Analytics'),
                    horizontalTitleGap: 5,
                    leading: const Icon(Icons.auto_graph_sharp),
                    onTap: () {
                      AppRouter.navigateToPage(AppRoutes.driverAnalyticsPage);
                    },
                  ),
                  const Spacer(),
                  ListTile(
                    title: const Text('Logout'),
                    horizontalTitleGap: 5,
                    iconColor: Colors.red,
                    textColor: Colors.red,
                    leading: const Icon(Icons.logout),
                    onTap: () async {
                      await ref.read(authControllerProvider.notifier).logout();
                    },
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
