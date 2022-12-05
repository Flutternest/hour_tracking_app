import 'package:flux_mvp/auth/models/auth_user.dart';
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

  Future<List<Trip>> getAllTrips(String? driverId,
      {bool includeOngoing = false});
  Stream<List<Trip>> getAllTripsStream(String? driverId,
      {bool includeOngoing = false});

  // Returns null if there's no ongoing trip for the driver
  Future<Trip?> getCurrentOnGoingTrip(String driverId);

  Future<Trip> getTripDetails(String tripId);

  Future<void> createTrip(Trip trip, {required String tripId});
  Future<void> pauseTrip(String tripId);
  Future<void> resumeTrip(String tripId);
  Future<void> stopTrip(
    String tripId, {
    required DateTime end,
    required double distanceInMiles,
    required double totalPayment,
    required int timeDrivenInSeconds,
  });

  Future<int> lastTripIdUsed();

  Future<List<Trip>> getAllOngoingTrips();
  Stream<List<Trip>> getAllOngoingTripsStream();

  Future<List<Trip>> getAllTripsWithPendingPayment();
  Stream<List<Trip>> getAllTripsWithPendingPaymentStream();

  Future<List<AuthUser>> getAllDrivers();
  Future<void> updateDriver(String driverId, AuthUser driver);

  Future<void> markAsPaid(String tripId);
}
