import 'package:flux_mvp/core/extensions/double_extension.dart';
import 'package:flux_mvp/features/common/providers/trip.dart';
import 'package:flux_mvp/features/common/repositories/trip_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final allPendingPaymentsTripsProvider = StreamProvider<List<Trip>>((ref) {
  return ref.read(tripRepositoryProvider).getAllTripsWithPendingPaymentStream();
});

final allPendingPaymentsTripsCountProvider =
    StreamProvider<double>((ref) async* {
  final trips = ref.watch(allPendingPaymentsTripsProvider);
  yield trips.when(
    data: (trips) {
      double sum = 0.0;
      for (final t in trips) {
        sum += t.amount!;
      }
      return sum.toPrecision(2);
    },
    loading: () => 0.0,
    error: (_, __) => 0.0,
  );
});
