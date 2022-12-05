import 'package:flutter/material.dart';
import 'package:flux_mvp/core/common_widgets/app_loader.dart';
import 'package:flux_mvp/core/common_widgets/error_view.dart';
import 'package:flux_mvp/core/extensions/double_extension.dart';
import 'package:flux_mvp/routing/router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/common_widgets/app_padding.dart';
import '../../../core/utils/ui_helper.dart';
import '../../common/providers/all_ongoing_trips_provider.dart';
import '../../common/repositories/trip_repository.dart';

class ManageTripsPage extends HookConsumerWidget {
  const ManageTripsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allOngoingTripsAsync = ref.watch(allOngoingTripsProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Trips'),
      ),
      body: SafeArea(
        child: allOngoingTripsAsync.when(
          data: (trips) {
            if (trips.isEmpty) {
              return const Center(
                child: Text('No trips yet'),
              );
            }
            return ListView.separated(
              itemCount: trips.length,
              itemBuilder: (context, index) {
                final trip = trips[index];
                return DefaultAppPadding.horizontal(
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.wallet_travel_rounded),
                    horizontalTitleGap: 4,
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          // "Mon, Nov 20, 05:44 PM",
                          DateFormat("EEEE, MMM dd, hh:mm aaa")
                              .format(trip.start!.toLocal()),
                          style: textTheme(context)
                              .titleSmall!
                              .copyWith(fontWeight: FontWeight.w700),
                        ),
                        verticalSpaceSmall,
                        Text(
                          "Trip: #${trip.tripId}",
                          style: textTheme(context)
                              .titleSmall!
                              .copyWith(fontWeight: FontWeight.w400),
                        ),
                        verticalSpaceSmall,
                      ],
                    ),
                    subtitle: Text(
                      "Driver: ${trip.driver!.driverName}",
                      style: textTheme(context)
                          .titleSmall!
                          .copyWith(fontWeight: FontWeight.w400),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.cancel),
                      color: Colors.red,
                      onPressed: () async {
                        final difference =
                            DateTime.now().difference(trip.start!);
                        final totalTimeInSeconds = difference.inSeconds;
                        final milesCovered = (difference.inSeconds / 3600) * 75;

                        await ref
                            .read(tripRepositoryProvider)
                            .stopTrip(
                              trip.tripId.toString(),
                              distanceInMiles: milesCovered.toPrecision(2),
                              end: DateTime.now(),
                              totalPayment: (milesCovered * (trip.payPerMile!))
                                  .toDouble()
                                  .toPrecision(1),
                              timeDrivenInSeconds: totalTimeInSeconds,
                            )
                            .catchError((e) {
                          showErrorSnackBar(
                              AppRouter.navigatorKey.currentContext, e);
                        });
                      },
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) => const Divider(height: 30),
            );
          },
          error: (err, st) => const ErrorView(),
          loading: () => const AppLoader(),
        ),
      ),
    );
  }
}
