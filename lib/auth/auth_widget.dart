import 'package:flutter/material.dart';
import 'package:flux_mvp/features/driver/dashboard/dashboad_page.dart';
import 'package:flux_mvp/features/welcome_page.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../core/constants/configs.dart';
import '../core/services/pref_storage/pref_storage_provider.dart';
import '../core/services/pref_storage/shared_pref_storage_service.dart';

class AuthWidget extends HookConsumerWidget {
  const AuthWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prefs = ref.watch(prefsStorageServiceProvider);
    switch (prefs.get(PrefKeys.loginType)) {
      case null:
        return const WelcomePage();
      case Configs.adminLoginType:
        return const DashboardPage();
      case Configs.driverLoginType:
        return const DashboardPage();
      default:
        return const WelcomePage();
    }
  }
}
