import 'package:flux_mvp/auth/models/auth_user.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/global_notifiers/app_notifier.dart';
import '../../common/repositories/trip_repository.dart';

final updateDriverProvider =
    StateNotifierProvider.autoDispose<UpdateDriverState, AsyncValue<void>>(
  (ref) => UpdateDriverState(ref),
);

class UpdateDriverState extends AppStateNotifier {
  UpdateDriverState(super.ref);

  Future<void> updateDriver(
    String uid,
    AuthUser driver,
  ) async {
    return stateCallback(
      () async {
        await ref.read(tripRepositoryProvider).updateDriver(uid, driver);
      },
    );
  }
}
