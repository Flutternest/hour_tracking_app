import 'package:flux_mvp/global_providers.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../common/providers/trip.dart';
import '../../common/repositories/trip_repository.dart';

final onGoingTripProvider = FutureProvider<Trip?>((ref) async {
  return ref
      .watch(tripRepositoryProvider)
      .getCurrentOnGoingTrip(ref.read(currentUserProvider)!.driverId!);
});
