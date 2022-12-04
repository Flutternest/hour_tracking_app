import 'package:flux_mvp/features/common/providers/driver_all_trips_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

enum FilterType {
  all,
  pending,
  paid,
}

final filterTypeProvider = StateProvider<FilterType>((ref) => FilterType.all);

final filteredTripsProvider =
    FutureProvider.family((ref, String? driverId) async {
  final FilterType filter = ref.watch(filterTypeProvider);
  final trips = await ref.watch(driverAllTripsProvider(driverId).future);

  switch (filter) {
    case FilterType.all:
      return trips;
    case FilterType.paid:
      return trips.where((t) => t.paymentStatus == "paid").toList();
    case FilterType.pending:
      return trips.where((t) => t.paymentStatus == "pending").toList();
  }
});
