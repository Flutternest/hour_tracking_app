import 'package:flux_mvp/features/common/repositories/trip_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../common/providers/trip.dart';

final tripDetailsProvider =
    FutureProvider.autoDispose.family<Trip, int>((ref, tripId) async {
  return ref.read(tripRepositoryProvider).getTripDetails(tripId.toString());
});
