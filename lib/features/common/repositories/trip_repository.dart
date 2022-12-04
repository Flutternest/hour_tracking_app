import 'package:flux_mvp/global_providers.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../common/providers/trip.dart';
import 'firebase_trip_repository.dart';

final tripRepositoryProvider = Provider<TripRepository>(
  (ref) {
    final firestore = ref.watch(firestoreProvider);

    return FirebaseTripRepository(firestore: firestore);
  },
);

abstract class TripRepository {
  String get path;

  Future<List<Trip>> getAllTrips(String driverId);
  Future<Stream<List<Trip>>> getAllTripsStream(String driverId);

  // Returns null if there's no ongoing trip for the driver
  Future<Trip?> getCurrentOnGoingTrip(String driverId);

  Future<void> createTrip(Trip trip, {required String tripId});
  Future<void> pauseTrip(String tripId);
  Future<void> resumeTrip(String tripId);
  Future<void> stopTrip(
    String tripId, {
    required DateTime end,
    required double distanceInMiles,
    required double totalPayment,
  });

  Future<int> lastTripIdUsed();
}
