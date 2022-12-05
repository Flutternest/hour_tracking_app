import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flux_mvp/auth/models/auth_user.dart';
import 'package:flux_mvp/core/services/pref_storage/pref_storage_provider.dart';
import 'package:flux_mvp/core/services/pref_storage/shared_pref_storage_service.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final firestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});

final currentUserProvider = Provider.autoDispose<AuthUser?>((ref) {
  final user = ref.read(prefsStorageServiceProvider).get(PrefKeys.userDetails);
  if (user != null) {
    return AuthUser.fromJson(jsonDecode(user));
  }
  return null;
});
