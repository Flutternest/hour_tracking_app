import 'package:flux_mvp/auth/models/auth_user.dart';
import 'package:flux_mvp/features/common/repositories/trip_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final allDriversProvider = FutureProvider<List<AuthUser>>((ref) async {
  return ref.read(tripRepositoryProvider).getAllDrivers();
});
