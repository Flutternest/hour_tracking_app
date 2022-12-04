import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flux_mvp/auth/auth_controller.dart';
import 'package:flux_mvp/core/common_widgets/app_padding.dart';
import 'package:flux_mvp/core/common_widgets/error_view.dart';
import 'package:flux_mvp/core/constants/paths.dart';
import 'package:flux_mvp/core/extensions/double_extension.dart';
import 'package:flux_mvp/core/extensions/random_extension.dart';
import 'package:flux_mvp/core/services/pref_storage/pref_storage_provider.dart';
import 'package:flux_mvp/core/services/pref_storage/shared_pref_storage_service.dart';
import 'package:flux_mvp/core/utils/app_utils.dart';
import 'package:flux_mvp/core/utils/ui_helper.dart';
import 'package:flux_mvp/features/common/providers/driver_all_trips_provider.dart';
import 'package:flux_mvp/features/common/providers/filtered_tips_provider.dart';
import 'package:flux_mvp/features/driver/controllers/ongoing_trip.dart';
import 'package:flux_mvp/routing/router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pausable_timer/pausable_timer.dart';

import '../../../core/common_widgets/app_loader.dart';
import '../../../core/constants/colors.dart';
import '../../../global_providers.dart';
import '../../common/providers/trip.dart';
import '../controllers/driver_trip_controller.dart';
import '../widgets/side_menu.dart';

class DashboardPage extends HookConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ongoingTripAsync = ref.watch(onGoingTripProvider);
    final currentTimer = useState(0);
    final timer = useRef<PausableTimer?>(null);
    final prefs = ref.watch(prefsStorageServiceProvider);
    final random = useMemoized(() => Random());
    final milesCovered = useState(0.0);

    final initiateTimer = useCallback(() {
      if (!(timer.value?.isCancelled ?? true)) return;

      timer.value = PausableTimer(const Duration(seconds: 1), () async {
        currentTimer.value++;
        milesCovered.value = ((currentTimer.value / 3600) * (74)).abs();

        timer.value
          ?..reset()
          ..start();

        await prefs.set(PrefKeys.timerCount, currentTimer.value);
        await prefs.set(
          PrefKeys.timerLoggingDateTime,
          DateTime.now().toIso8601String(),
        );
      });
    }, []);

    useEffect(() {
      currentTimer.value = prefs.get(PrefKeys.timerCount) ?? 0;
      final timerLoggingDateTime = prefs.get(PrefKeys.timerLoggingDateTime);
      if (timerLoggingDateTime != null) {
        final difference =
            DateTime.now().difference(DateTime.parse(timerLoggingDateTime));
        currentTimer.value += difference.inSeconds;
      }

      initiateTimer.call();

      final isOnGoing = prefs.get(PrefKeys.isTimerOnGoing) ?? false;
      if (isOnGoing) {
        timer.value?.start();
      }

      return () {
        timer.value?.cancel();
      };
    }, []);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
      ),
      drawer: const DriverDrawer(),
      body: SafeArea(
        child: ongoingTripAsync.when(
          data: (Trip? trip) {
            final isTripOnGoing = trip != null;
            bool isPaused = false;
            String tripStatus = "";
            Color tripStatusColor = Colors.green;

            switch (trip?.tripStatus) {
              case "ongoing":
                tripStatus = "Commute ongoing";
                tripStatusColor = Colors.green;
                // currentTimer.value =
                //     DateTime.now().difference(trip!.start!).inSeconds;
                break;
              case "paused":
                isPaused = true;
                tripStatus = "Commute paused";
                tripStatusColor = Colors.orange;
                // currentTimer.value =
                //     DateTime.now().difference(trip!.start!).inSeconds;
                break;
              default:
                tripStatus = "Commute not started";
                tripStatusColor = Colors.red;
                break;
            }

            return SingleChildScrollView(
              child: DefaultAppPadding.horizontal(
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
                                AppUtils.formatTimer(
                                    Duration(seconds: currentTimer.value)),
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
                                : () async {
                                    final cu = ref.read(currentUserProvider);
                                    if (cu == null) {
                                      showSnackBar(context,
                                          message:
                                              "Please login again to continue.");

                                      await ref
                                          .read(authControllerProvider.notifier)
                                          .logout();
                                      return;
                                    }
                                    initiateTimer();
                                    await prefs.set(
                                        PrefKeys.isTimerOnGoing, true);
                                    await prefs
                                        .remove(PrefKeys.timerLoggingDateTime);
                                    timer.value?.start();
                                    return ref
                                        .read(createTripProvider.notifier)
                                        .createTrip(
                                          Trip(
                                            tripStatus: "ongoing",
                                            driverId: cu.driverId,
                                            amount: 0,
                                            driverName: cu.name,
                                            eldSerialId: cu.eldSerialId,
                                            driverEmail: cu.email,
                                            start: DateTime.now(),
                                            miles: 0,
                                            paymentStatus: "pending",
                                            payPerMile: random
                                                .nextDoubleInRange(2.47, 3.56),
                                            timeDrivenInSeconds: 0,
                                          ),
                                        )
                                        .catchError((e) =>
                                            showErrorSnackBar(context, e))
                                        .then(
                                          (_) => ref
                                              .invalidate(onGoingTripProvider),
                                        );
                                  },
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
                                            timer.value?.start();
                                            prefs.set(
                                                PrefKeys.isTimerOnGoing, true);
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
                                          timer.value?.pause();
                                          prefs.set(
                                              PrefKeys.isTimerOnGoing, false);
                                          prefs.remove(
                                              PrefKeys.timerLoggingDateTime);
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
                                          final shouldEndTrip =
                                              await showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return AlertDialog(
                                                      title: Center(
                                                        child: Column(
                                                          children: const [
                                                            Text("End Trip"),
                                                            verticalSpaceRegular,
                                                            Icon(
                                                              Icons.warning,
                                                              color:
                                                                  Colors.orange,
                                                              size: 70,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      content: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .stretch,
                                                        children: [
                                                          const Text(
                                                              "Are you sure you want to end this trip?"),
                                                          verticalSpaceRegular,
                                                          ElevatedButton(
                                                            onPressed: () {
                                                              Navigator.pop(
                                                                  context,
                                                                  true);
                                                            },
                                                            style: ElevatedButton
                                                                .styleFrom(
                                                                    backgroundColor:
                                                                        Colors
                                                                            .red),
                                                            child: const Text(
                                                                "End Trip"),
                                                          ),
                                                          verticalSpaceSmall,
                                                          ElevatedButton(
                                                            onPressed: () {
                                                              Navigator.pop(
                                                                  context,
                                                                  false);
                                                            },
                                                            style: ElevatedButton
                                                                .styleFrom(
                                                                    backgroundColor:
                                                                        Colors
                                                                            .grey),
                                                            child: const Text(
                                                                "No, continue driving"),
                                                          )
                                                        ],
                                                      ),
                                                    );
                                                  });

                                          if (shouldEndTrip == null ||
                                              !shouldEndTrip) {
                                            return;
                                          }

                                          ref
                                              .read(stopTripProvider.notifier)
                                              .stopTrip(
                                                trip.tripId.toString(),
                                                distanceInMiles: milesCovered
                                                    .value
                                                    .toPrecision(2),
                                                end: DateTime.now(),
                                                totalPayment:
                                                    (milesCovered.value *
                                                            (trip.payPerMile!))
                                                        .toDouble()
                                                        .toPrecision(1),
                                                timeDrivenInSeconds:
                                                    currentTimer.value,
                                              )
                                              .catchError((e) =>
                                                  showErrorSnackBar(context, e))
                                              .then((_) async {
                                            currentTimer.value = 0;
                                            timer.value?.cancel();
                                            await Future.wait([
                                              prefs.remove(PrefKeys
                                                  .timerLoggingDateTime),
                                              prefs.remove(
                                                  PrefKeys.isTimerOnGoing),
                                              prefs.remove(PrefKeys.timerCount),
                                            ]);
                                            ref.invalidate(onGoingTripProvider);
                                            ref.invalidate(
                                                driverAllTripsProvider);
                                            ref.invalidate(
                                                filteredTripsProvider);
                                            AppRouter.navigateToPage(
                                              AppRoutes.driverResultPage,
                                              arguments: trip.tripId,
                                            );
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
                    if (isTripOnGoing) ...[
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
                              rows: [
                                DataRow(cells: [
                                  const DataCell(Text("Time Driven")),
                                  DataCell(Text(
                                    AppUtils.formatTimer(
                                        Duration(seconds: currentTimer.value)),
                                  )),
                                ]),
                                // const DataRow(cells: [
                                //   DataCell(Text("Time Paused")),
                                //   DataCell(Text("00:00:00")),
                                // ]),
                                DataRow(cells: [
                                  const DataCell(Text("Miles Covered")),
                                  DataCell(Text(
                                    milesCovered.value.toStringAsFixed(2),
                                  )),
                                ]),
                                DataRow(cells: [
                                  const DataCell(Text("Pay/Mile")),
                                  DataCell(Text("\$${trip.payPerMile}")),
                                ]),
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ],
                ),
              ),
            );
          },
          error: (err, st) => const ErrorView(),
          loading: () => const AppLoader(),
        ),
      ),
    );
  }
}
