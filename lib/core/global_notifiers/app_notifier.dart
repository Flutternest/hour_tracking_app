import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Used [AsyncValue] to cover all possible states of the repository.
///
/// [AsyncValue.data] does not return any value.
///
/// Used for using the magic of async value (mostly for onClick event based providers).
///
/// Params:
/// [ref] -> for dependency injection.
class AppStateNotifier extends StateNotifier<AsyncValue<void>> {
  AppStateNotifier(this.ref) : super(const AsyncData<void>(null));

  final Ref ref;

  /// State callback should be called before every function that needs to update the state.
  Future<dynamic> stateCallback(dynamic Function() function,
      {bool showLoader = true}) async {
    try {
      if (showLoader) state = const AsyncValue.loading();
      state = await AsyncValue.guard<void>(() async {
        await function.call();
        return;
      });
    } on FirebaseAuthException catch (he, st) {
      state = AsyncValue.error(he.message ?? "Something went wrong", st);
    } catch (e, st) {
      state = AsyncValue.error("Something went wrong", st);
    }
  }
}
