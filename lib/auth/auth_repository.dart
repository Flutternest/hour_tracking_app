import 'package:flux_mvp/auth/firebase_auth_repository.dart';
import 'package:flux_mvp/core/services/firebase_auth.dart';
import 'package:flux_mvp/global_providers.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'models/auth_user.dart';

final authRepositoryProvider = Provider<FirebaseAuthRepository>(
  (ref) {
    final firebaseAuthService = ref.watch(firebaseAuthServiceProvider);
    final firestore = ref.watch(firestoreProvider);

    return FirebaseAuthRepository(
        firebaseAuthService: firebaseAuthService, firestore: firestore);
  },
);

abstract class AuthRepository {
  String get path;

  Future<AuthUser> login({
    required String email,
    required String password,
  });

  Future<void> logout();
}
