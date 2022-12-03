import 'package:flux_mvp/core/global_notifiers/app_notifier.dart';
import 'package:flux_mvp/features/common/repositories/trip_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../common/providers/trip.dart';

final createTripProvider =
    StateNotifierProvider.autoDispose<CreateTripState, AsyncValue<void>>(
  (ref) => CreateTripState(ref),
);

class CreateTripState extends AppStateNotifier {
  CreateTripState(super.ref);

  Future<void> createTrip() async {
    return stateCallback(
      () async {
        final lastId = await ref.read(tripRepositoryProvider).lastTripIdUsed();

        ref.read(tripRepositoryProvider).createTrip(
              Trip(
                tripStatus: "ongoing",
                driverId: "1",
                amount: 0,
                driverName: "John Doe",
                eldSerialId: "123123",
                start: DateTime.now(),
                end: DateTime.now(),
                miles: 200,
                paymentStatus: "pending",
                tripId: lastId + 1,
              ),
              tripId: (lastId + 1).toString(),
            );
      },
    );
  }
}

final pauseTripProvider =
    StateNotifierProvider.autoDispose<PauseTripState, AsyncValue<void>>(
  (ref) => PauseTripState(ref),
);

class PauseTripState extends AppStateNotifier {
  PauseTripState(super.ref);

  Future<void> pauseTrip(String tripId) async {
    return stateCallback(() async {
      ref.read(tripRepositoryProvider).pauseTrip(tripId);
    });
  }

  Future<void> resumeTrip(String tripId) async {
    return stateCallback(() async {
      ref.read(tripRepositoryProvider).resumeTrip(tripId);
    });
  }
}

final stopTripProvider =
    StateNotifierProvider.autoDispose<StopTripState, AsyncValue<void>>(
  (ref) => StopTripState(ref),
);

class StopTripState extends AppStateNotifier {
  StopTripState(super.ref);

  Future<void> stopTrip(String tripId) async {
    return stateCallback(() async {
      ref.read(tripRepositoryProvider).stopTrip(tripId);
    });
  }
}
