import 'package:flux_mvp/features/common/providers/trip.dart';
import 'package:flux_mvp/features/common/repositories/trip_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final allOngoingTripsProvider = StreamProvider<List<Trip>>((ref) {
  return ref.read(tripRepositoryProvider).getAllOngoingTripsStream();
});

final allOngoingTripsCountProvider = StreamProvider<int>((ref) async* {
  final trips = ref.watch(allOngoingTripsProvider);

  yield trips.when(
    data: (trips) => trips.length,
    loading: () => 0,
    error: (_, __) => 0,
  );
});
