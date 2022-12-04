import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flux_mvp/core/common_widgets/app_loader.dart';
import 'package:flux_mvp/core/common_widgets/app_padding.dart';
import 'package:flux_mvp/core/common_widgets/error_view.dart';
import 'package:flux_mvp/core/utils/ui_helper.dart';
import 'package:flux_mvp/features/common/providers/pending_payments_trips_proivder.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/constants/colors.dart';
import '../../common/providers/all_ongoing_trips_provider.dart';
import '../widgets/side_menu.dart';

class AdminDashboardPage extends HookConsumerWidget {
  const AdminDashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allPendingPaymentsAsync = ref.watch(allPendingPaymentsTripsProvider);
    final allOngoingTripsCountAsync = ref.watch(allOngoingTripsCountProvider);
    final allPendingPaymentsCountAsync =
        ref.watch(allPendingPaymentsTripsCountProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
      ),
      drawer: const AdminDrawer(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: DefaultAppPadding(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 32),
                        decoration: BoxDecoration(
                          color: kOverlayDarkBackground,
                          // color: Colors.redAccent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                            child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              allPendingPaymentsCountAsync.hasValue
                                  ? "\$${allPendingPaymentsCountAsync.value.toString()}"
                                  : "#",
                              style: textTheme(context)
                                  .headlineMedium!
                                  .copyWith(fontWeight: FontWeight.bold),
                            ),
                            verticalSpaceSmall,
                            const Text("Pending Payments"),
                          ],
                        )),
                      ),
                    ),
                    horizontalSpaceRegular,
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 32),
                        decoration: BoxDecoration(
                          color: kOverlayDarkBackground,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                            child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              allOngoingTripsCountAsync.hasValue
                                  ? allOngoingTripsCountAsync.value
                                      .toString()
                                      .padLeft(2, "0")
                                  : "#",
                              style: textTheme(context)
                                  .headlineMedium!
                                  .copyWith(fontWeight: FontWeight.bold),
                            ),
                            verticalSpaceSmall,
                            const Text("Ongoing Trips"),
                          ],
                        )),
                      ),
                    ),
                  ],
                ),
                verticalSpaceMedium,
                allPendingPaymentsAsync.when(
                  data: (trips) {
                    trips.sort((a, b) => b.amount!.compareTo(a.amount!));
                    double maxAmount = 0.0;

                    if (trips.isNotEmpty) {
                      maxAmount = trips.first.amount!;
                    }

                    return Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: kOverlayDarkBackground,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            "Pending Payments - (Range: \$0 - \$${maxAmount.toStringAsFixed(2)})",
                            style: const TextStyle(color: Colors.grey),
                          ),
                          verticalSpaceSmall,
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: List.generate(
                              trips.length,
                              (index) {
                                final trip = trips[index];
                                return Padding(
                                  padding: const EdgeInsets.only(top: 12.0),
                                  child: Row(
                                    children: [
                                      Text(trip.driverName!),
                                      horizontalSpaceSmall,
                                      Expanded(
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          child: LinearProgressIndicator(
                                            minHeight: 10,
                                            color: Colors.red,
                                            value: trip.amount! / maxAmount,
                                          ),
                                        ),
                                      ),
                                      horizontalSpaceSmall,
                                      Text(
                                        "\$${trip.amount!}",
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  error: (error, stackTrace) => const ErrorView(),
                  loading: () => const AppLoader(),
                ),
                verticalSpaceMedium,
                const OngoingTripsContainer(),
                verticalSpaceMedium,
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.auto_graph_sharp),
                  label: const Text("View Analytics"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class OngoingTripsContainer extends HookConsumerWidget {
  const OngoingTripsContainer({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allOngoingTripsAsync = ref.watch(allOngoingTripsProvider);

    final aController =
        useAnimationController(duration: const Duration(seconds: 2))..repeat();

    useListenable(aController);

    return allOngoingTripsAsync.when(
      data: (trips) {
        trips.sort((a, b) => b.start!.compareTo(a.start!));
        double maxMiles = 0.0;
        maxMiles = 3500;

        return Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: kOverlayDarkBackground,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "Ongoing Trips - (Range: 0 - $maxMiles miles)",
                style: const TextStyle(color: Colors.grey),
              ),
              verticalSpaceSmall,
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: List.generate(
                  trips.length,
                  (index) {
                    final trip = trips[index];
                    final hours =
                        ((DateTime.now().difference(trip.start!).inSeconds /
                            3600));

                    final currentTripMiles = (hours * (74).abs().toDouble());

                    return Padding(
                      padding: const EdgeInsets.only(top: 12.0),
                      child: Row(
                        children: [
                          Text(trip.driverName!),
                          horizontalSpaceSmall,
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: LinearProgressIndicator(
                                minHeight: 10,
                                color: kPrimaryColor,
                                value: currentTripMiles / maxMiles,
                              ),
                            ),
                          ),
                          horizontalSpaceSmall,
                          Text(
                            "~${currentTripMiles.toStringAsFixed(2)} miles",
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
      error: (error, stackTrace) => const ErrorView(),
      loading: () => const AppLoader(),
    );
  }
}
