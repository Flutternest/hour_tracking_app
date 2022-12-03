import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flux_mvp/auth/auth_repository.dart';
import 'package:flux_mvp/core/services/firebase_auth.dart';

import 'models/auth_user.dart';

class FirebaseAuthRepository implements AuthRepository {
  final FirebaseAuthService firebaseAuthService;
  final FirebaseFirestore firestore;

  FirebaseAuthRepository(
      {required this.firebaseAuthService, required this.firestore});

  @override
  String get path => "users";

  @override
  Future<AuthUser> login(
      {required String email, required String password}) async {
    firebaseAuthService.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = firebaseAuthService.auth.currentUser;
    if (user != null) {
      final authUser = await firestore.doc("$path/${user.uid}").get();
      return AuthUser.fromJson(authUser.data()!);
    } else {
      throw Exception("User not found");
    }
  }

  @override
  Future<void> logout() {
    return firebaseAuthService.logOut();
  }
}
