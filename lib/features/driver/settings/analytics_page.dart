import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flux_mvp/core/common_widgets/app_loader.dart';
import 'package:flux_mvp/core/common_widgets/app_padding.dart';
import 'package:flux_mvp/core/common_widgets/error_view.dart';
import 'package:flux_mvp/core/constants/colors.dart';
import 'package:flux_mvp/core/utils/ui_helper.dart';
import 'package:flux_mvp/global_providers.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import '../../common/providers/filtered_tips_provider.dart';
import '../../common/providers/trip.dart';

class AnalyticsFilter {
  final String filterName;
  final FilterType filterType;

  AnalyticsFilter({required this.filterName, required this.filterType});
}

class DriverAnalyticsPage extends HookConsumerWidget {
  const DriverAnalyticsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<AnalyticsFilter> filters = useMemoized(
      () => [
        AnalyticsFilter(filterName: "All", filterType: FilterType.all),
        AnalyticsFilter(filterName: "Paid", filterType: FilterType.paid),
        AnalyticsFilter(filterName: "Unpaid", filterType: FilterType.pending),
      ],
    );

    final filteredTripsAsync = ref
        .watch(filteredTripsProvider(ref.read(currentUserProvider)!.driverId!));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics'),
      ),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            verticalSpaceMedium,
            Container(
              color: kDarkBackground,
              height: 40,
              child: ListView.separated(
                itemCount: filters.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      final filter = filters[index];

                      ref.read(filterTypeProvider.notifier).state =
                          filter.filterType;
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 6),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(1000),
                        color: filters[index].filterType ==
                                ref.watch(filterTypeProvider)
                            ? kPrimaryColor
                            : kOverlayDarkBackground,
                      ),
                      margin: EdgeInsets.only(
                        left: index == 0 ? 24.0 : 0,
                        right: index == filters.length - 1 ? 24.0 : 0,
                      ),
                      child: Center(child: Text(filters[index].filterName)),
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) =>
                    horizontalSpaceSmall,
              ),
            ),
            verticalSpaceMedium,
            Expanded(
              child: filteredTripsAsync.when(
                data: (trips) {
                  if (trips.isEmpty) {
                    return const Center(
                      child: Text('No trips found'),
                    );
                  }
                  return DefaultAppPadding.horizontal(
                    child: ListView.separated(
                      itemCount: trips.length,
                      itemBuilder: (context, index) {
                        final trip = trips[index];
                        return AnalyticsItem(
                            isPaid: trip.paymentStatus == "paid", trip: trip);
                      },
                      separatorBuilder: (context, index) =>
                          verticalSpaceRegular,
                    ),
                  );
                },
                error: (error, stackTrace) => const ErrorView(),
                loading: () => const AppLoader(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AnalyticsItem extends StatelessWidget {
  const AnalyticsItem({
    required this.trip,
    this.isPaid = false,
    Key? key,
  }) : super(key: key);

  final bool isPaid;
  final Trip trip;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      color: kOverlayDarkBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Row(
              children: [
                const Icon(Icons.directions_car),
                horizontalSpaceSmall,
                Text.rich(
                  TextSpan(
                    text: 'Trip ',
                    style: const TextStyle(color: Colors.grey),
                    children: [
                      TextSpan(
                        text: '#${trip.tripId}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      )
                    ],
                  ),
                ),
                const Spacer(),
                CircleAvatar(
                  radius: 3,
                  backgroundColor: isPaid ? Colors.green : Colors.red,
                ),
                horizontalSpaceSmall,
                Text.rich(
                  TextSpan(
                    text: '\$${trip.amount}',
                    style: TextStyle(
                      color: isPaid ? Colors.green : Colors.red,
                    ),
                    children: const [
                      TextSpan(
                        text: '',
                      )
                    ],
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Divider(),
                Text.rich(
                  TextSpan(
                    text: 'Start: ',
                    style: const TextStyle(color: Colors.grey),
                    children: [
                      TextSpan(
                        // text: 'Thur, 2 Nov at 05:30 PM',
                        text: DateFormat("EEEE dd MMM, hh:mm aaa")
                            .format(trip.start!),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      )
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(2, (index) => const Text(".")),
                ),
                Text.rich(
                  TextSpan(
                    text: 'End: ',
                    style: const TextStyle(color: Colors.grey),
                    children: [
                      TextSpan(
                        text: DateFormat("EEEE dd MMM, hh:mm aaa")
                            .format(trip.end!),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      )
                    ],
                  ),
                ),
                const Divider(),
                verticalSpaceSmall,
                Text.rich(
                  TextSpan(
                    text: 'ELD# ',
                    style: const TextStyle(color: Colors.grey),
                    children: [
                      TextSpan(
                        text: trip.eldSerialId,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      )
                    ],
                  ),
                ),
                verticalSpaceSmall,
                Text.rich(
                  TextSpan(
                    text: 'Miles Covered: ',
                    style: const TextStyle(color: Colors.grey),
                    children: [
                      TextSpan(
                        text: trip.miles.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      )
                    ],
                  ),
                ),
                const Divider(
                  height: 30,
                ),
                Text.rich(
                  TextSpan(
                    text: 'Payment Status: ',
                    style: const TextStyle(color: Colors.grey),
                    children: [
                      TextSpan(
                        text: isPaid ? 'Paid' : 'Pending',
                        style: TextStyle(
                          color: isPaid ? Colors.green : Colors.red,
                          fontWeight: FontWeight.w700,
                        ),
                      )
                    ],
                  ),
                ),
                const Divider(
                  height: 30,
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: kDarkBackground,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 14,
                        backgroundColor: Colors.grey,
                        child: Text(trip.driverName![0].toUpperCase()),
                      ),
                      horizontalSpaceSmall,
                      Text(trip.driverName!),
                      const Spacer(),
                      Text(trip.driverEmail!),
                    ],
                  ),
                ),
                // if (!isPaid) ...[
                //   verticalSpaceRegular,
                //   ElevatedButton.icon(
                //     onPressed: () {},
                //     style: ElevatedButton.styleFrom(
                //       padding: const EdgeInsets.symmetric(
                //           horizontal: 12, vertical: 10),
                //     ),
                //     icon: const Icon(Icons.check_circle),
                //     label: const Text("Mark as Paid"),
                //   ),
                // ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
