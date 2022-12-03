import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flux_mvp/core/constants/paths.dart';
import 'package:flux_mvp/routing/router.dart';

import '../../../core/constants/colors.dart';

class DriverDrawer extends StatelessWidget {
  const DriverDrawer({super.key});

  @override
  Widget build(BuildContext context) {
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
                    onTap: () {},
                  ),
                  const Spacer(),
                  ListTile(
                    title: const Text('Logout'),
                    horizontalTitleGap: 5,
                    iconColor: Colors.red,
                    textColor: Colors.red,
                    leading: const Icon(Icons.logout),
                    onTap: () {},
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
