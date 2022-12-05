import 'dart:async';
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
import 'package:flux_mvp/features/driver/controllers/trip_details_controller.dart';
import 'package:flux_mvp/routing/router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pausable_timer/pausable_timer.dart';

import '../../../core/common_widgets/app_loader.dart';
import '../../../core/constants/colors.dart';
import '../../../global_providers.dart';
import '../../common/providers/trip.dart';
import '../controllers/driver_trip_controller.dart';
import '../widgets/side_menu.dart';

final tripNotificationProvider = StreamProvider.autoDispose<Trip?>((ref) {
  StreamSubscription? subscription;

  ref.onDispose(() {
    subscription?.cancel();
  });

  return ref.watch(onGoingTripProvider).maybeWhen(
      data: (trip) {
        if (trip == null) return const Stream.empty();
        subscription?.cancel();
        return ref.watch(tripDetailsStreamProvider(trip.tripId!).stream);
      },
      orElse: () => const Stream.empty());
});

class DashboardPage extends HookConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ongoingTripAsync = ref.watch(onGoingTripProvider);
    final prefs = ref.watch(prefsStorageServiceProvider);

    final currentTimer = useState(0);
    final milesCovered = useState(0.0);
    final timer = useRef<PausableTimer?>(null);

    final random = useMemoized(() => Random());

    final streamController = useRef<StreamSubscription?>(null);

    final initiateTimer = useCallback(() {
      if (!(timer.value?.isCancelled ?? true)) return;

      timer.value = PausableTimer(const Duration(seconds: 1), () async {
        currentTimer.value++;
        final randomSpeed = random.nextDoubleInRange(45, 75); //miles per hour
        milesCovered.value += randomSpeed / 3600;

        timer.value
          ?..reset()
          ..start();

        await prefs.set(PrefKeys.timerCount, currentTimer.value);
        await prefs.set(
          PrefKeys.timerLoggingDateTime,
          DateTime.now().toIso8601String(),
        );
        await prefs.set(PrefKeys.milesCovered, milesCovered.value);
      });
    }, []);

    useEffect(() {
      // currentTimer.value = prefs.get(PrefKeys.timerCount) ?? 0;
      // milesCovered.value = prefs.get(PrefKeys.milesCovered) ?? 0.0;

      // final timerLoggingDateTime = prefs.get(PrefKeys.timerLoggingDateTime);
      // if (timerLoggingDateTime != null) {
      //   final difference =
      //       DateTime.now().difference(DateTime.parse(timerLoggingDateTime));
      //   currentTimer.value += difference.inSeconds;
      //   milesCovered.value += (difference.inSeconds / 3600) * 75;
      // }

      initiateTimer.call();
      // final isOnGoing = prefs.get(PrefKeys.isTimerOnGoing) ?? false;
      // if (isOnGoing) {
      //   timer.value?.start();
      // }

      return () {
        timer.value?.cancel();
        streamController.value?.cancel();
      };
    }, []);

    useMemoized(
      () => ref.watch(onGoingTripProvider).whenData(
        (trip) {
          if (trip == null) return;
          final difference = DateTime.now().difference(trip.start!);
          currentTimer.value += difference.inSeconds;
          milesCovered.value += (difference.inSeconds / 3600) * 75;
          timer.value?.start();
        },
      ),
      [],
    );

    ref.listen(tripNotificationProvider, ((previous, tripAsync) {
      if (previous?.value?.tripStatus == tripAsync.value?.tripStatus) return;
      debugPrint("trip notification");

      if (tripAsync.value == null) return;

      final trip = tripAsync.value!;

      if (trip.tripStatus == "completed") {
        ref.invalidate(onGoingTripProvider);
        ref.invalidate(driverAllTripsProvider);
        ref.invalidate(filteredTripsProvider);

        timer.value?.cancel();

        currentTimer.value = 0;
        milesCovered.value = 0;

        AppRouter.navigateToPage(
          AppRoutes.driverResultPage,
          arguments: trip.tripId,
        );

        return;
      }
    }));

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
                                            driver: Driver(
                                              driverId: cu.driverId,
                                              driverName: cu.name,
                                              driverEmail: cu.email,
                                            ),
                                            driverId: cu.driverId,
                                            amount: 0,
                                            eldSerialId: cu.eldSerialId,
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
                                  const DataCell(Text("Earnings")),
                                  DataCell(Text(
                                    ((milesCovered.value * (trip.payPerMile!))
                                            .toDouble()
                                            .toPrecision(1))
                                        .toStringAsFixed(1),
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
