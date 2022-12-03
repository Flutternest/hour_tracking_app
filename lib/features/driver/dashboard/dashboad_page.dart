import 'package:flutter/material.dart';
import 'package:flux_mvp/core/common_widgets/app_padding.dart';
import 'package:flux_mvp/core/common_widgets/error_view.dart';
import 'package:flux_mvp/core/constants/paths.dart';
import 'package:flux_mvp/core/utils/ui_helper.dart';
import 'package:flux_mvp/features/driver/controllers/ongoing_trip.dart';
import 'package:flux_mvp/routing/router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/common_widgets/app_loader.dart';
import '../../../core/constants/colors.dart';
import '../../common/providers/trip.dart';
import '../controllers/driver_trip_controller.dart';
import '../widgets/side_menu.dart';

class DashboardPage extends HookConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ongoingTripAsync = ref.watch(onGoingTripProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
      ),
      drawer: const DriverDrawer(),
      body: SafeArea(
        child: DefaultAppPadding.horizontal(
          child: ongoingTripAsync.when(
            data: (Trip? trip) {
              final isTripOnGoing = trip != null;
              bool isPaused = false;
              String tripStatus = "";
              Color tripStatusColor = Colors.green;

              switch (trip?.tripStatus) {
                case "ongoing":
                  tripStatus = "Commute on going";
                  tripStatusColor = Colors.green;
                  break;
                case "paused":
                  isPaused = true;
                  tripStatus = "Commute paused";
                  tripStatusColor = Colors.orange;
                  break;
                default:
                  tripStatus = "Commute not started";
                  tripStatusColor = Colors.red;
                  break;
              }

              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    verticalSpaceMedium,
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          constraints: const BoxConstraints(maxWidth: 400),
                          child: Image.asset(AppPaths.odoMeter,
                              width: double.infinity),
                        ),
                        Positioned(
                          child: Column(
                            children: [
                              verticalSpaceMedium,
                              Text(
                                "00:00:00",
                                style: textTheme(context).headlineMedium,
                              ),
                              Text(
                                "Timer",
                                style: textTheme(context)
                                    .headlineSmall!
                                    .copyWith(color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Center(
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey[800]!),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircleAvatar(
                              radius: 4,
                              backgroundColor: tripStatusColor,
                            ),
                            horizontalSpaceSmall,
                            Text(
                              tripStatus,
                              style: textTheme(context).titleMedium!,
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (!isTripOnGoing) ...[
                      verticalSpaceMedium,
                      Consumer(
                        builder: (context, ref, child) {
                          final createTripAsync = ref.watch(createTripProvider);

                          return ElevatedButton(
                            onPressed: createTripAsync.isLoading
                                ? null
                                : () async => ref
                                    .read(createTripProvider.notifier)
                                    .createTrip()
                                    .catchError(
                                        (e) => showErrorSnackBar(context, e))
                                    .then(
                                      (_) =>
                                          ref.invalidate(onGoingTripProvider),
                                    ),
                            child: const Text("Start Driving"),
                          );
                        },
                      ),
                    ] else ...[
                      verticalSpaceMedium,
                      Row(
                        children: [
                          Expanded(
                            child: Consumer(
                              builder: (context, ref, child) {
                                final pauseTripAsync =
                                    ref.watch(pauseTripProvider);

                                return ElevatedButton(
                                  onPressed: pauseTripAsync.isLoading
                                      ? null
                                      : () async {
                                          if (isPaused) {
                                            ref
                                                .read(
                                                    pauseTripProvider.notifier)
                                                .resumeTrip(
                                                    trip.tripId.toString())
                                                .catchError((e) =>
                                                    showErrorSnackBar(
                                                        context, e))
                                                .then((_) => ref.invalidate(
                                                    onGoingTripProvider));
                                            return;
                                          }
                                          ref
                                              .read(pauseTripProvider.notifier)
                                              .pauseTrip(trip.tripId.toString())
                                              .catchError((e) =>
                                                  showErrorSnackBar(context, e))
                                              .then((_) => ref.invalidate(
                                                  onGoingTripProvider));
                                        },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: isPaused
                                        ? Colors.orange
                                        : kOverlayDarkBackground,
                                  ),
                                  child: Text(isPaused ? "Resume" : "Pause"),
                                );
                              },
                            ),
                          ),
                          horizontalSpaceRegular,
                          Expanded(
                            child: Consumer(
                              builder: (context, ref, child) {
                                final stopTripAsync =
                                    ref.watch(stopTripProvider);

                                return ElevatedButton(
                                  onPressed: stopTripAsync.isLoading
                                      ? null
                                      : () async {
                                          ref
                                              .read(stopTripProvider.notifier)
                                              .stopTrip(trip.tripId.toString())
                                              .catchError((e) =>
                                                  showErrorSnackBar(context, e))
                                              .then((_) {
                                            ref.invalidate(onGoingTripProvider);
                                            AppRouter.navigateToPage(
                                                AppRoutes.driverResultPage);
                                          });
                                        },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                  ),
                                  child: const Text("End Trip"),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                    verticalSpaceMedium,
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: kOverlayDarkBackground,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            "Log Details",
                            style: textTheme(context)
                                .titleMedium!
                                .copyWith(fontWeight: FontWeight.w700),
                          ),
                          verticalSpaceRegular,
                          DataTable(
                            headingRowHeight: 0,
                            columns: const [
                              DataColumn(label: Text("Type,")),
                              DataColumn(label: Text("Value")),
                            ],
                            rows: const [
                              DataRow(cells: [
                                DataCell(Text("Time Driven")),
                                DataCell(Text("00:00:00")),
                              ]),
                              DataRow(cells: [
                                DataCell(Text("Time Paused")),
                                DataCell(Text("00:00:00")),
                              ]),
                              DataRow(cells: [
                                DataCell(Text("Miles Covered")),
                                DataCell(Text("0.0")),
                              ]),
                              DataRow(cells: [
                                DataCell(Text("Pay/Mile")),
                                DataCell(Text("\$0.0")),
                              ]),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              );
            },
            error: (err, st) => const ErrorView(),
            loading: () => const AppLoader(),
          ),
        ),
      ),
    );
  }
}
