import 'package:flux_mvp/features/common/providers/trip.dart';
import 'package:flux_mvp/features/common/repositories/trip_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final driverAllTripsProvider =
    StreamProvider.family<List<Trip>, String?>((ref, driverId) {
  return ref.read(tripRepositoryProvider).getAllTripsStream(driverId);
});
