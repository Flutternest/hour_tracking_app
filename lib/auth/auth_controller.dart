import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flux_mvp/auth/auth_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../core/constants/configs.dart';
import '../core/global_notifiers/app_notifier.dart';
import '../core/services/pref_storage/pref_storage_provider.dart';
import '../core/services/pref_storage/shared_pref_storage_service.dart';
import '../core/services/pref_storage/storage_service.dart';
import '../global_providers.dart';
import '../routing/router.dart';
import 'models/auth_user.dart';

final authControllerProvider =
    StateNotifierProvider.autoDispose<AuthController, AsyncValue>((ref) {
  return AuthController(ref);
});

class AuthController extends AppStateNotifier {
  AuthController(Ref ref) : super(ref) {
    prefs = ref.read(prefsStorageServiceProvider);
    repo = ref.read(authRepositoryProvider);
    firestore = ref.read(firestoreProvider);
  }

  late StorageService prefs;
  late AuthRepository repo;
  late FirebaseFirestore firestore;

  Future<void> login({required String email, required String password}) {
    return stateCallback(() async {
      final AuthUser user = await repo.login(email: email, password: password);

      await prefs.set(PrefKeys.isLoggedIn, true);

      if (user.type == "admin") {
        await prefs.set(PrefKeys.loginType, Configs.adminLoginType);
      } else {
        await prefs.set(PrefKeys.loginType, Configs.driverLoginType);
        await prefs.set(PrefKeys.userDetails, jsonEncode(user.toJson()));
        AppRouter.navigateAndRemoveUntil(AppRoutes.driverDashboardPage);
      }
    });
  }

  Future<void> logout() async {
    repo.logout();
    await ref.read(prefsStorageServiceProvider).clear();
    AppRouter.navigateAndRemoveUntil(AppRoutes.welcomePage);
  }
}