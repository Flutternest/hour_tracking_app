import 'package:flutter/material.dart';
import 'package:flux_mvp/core/common_widgets/app_loader.dart';
import 'package:flux_mvp/core/common_widgets/app_padding.dart';
import 'package:flux_mvp/core/common_widgets/error_view.dart';
import 'package:flux_mvp/core/utils/ui_helper.dart';
import 'package:flux_mvp/global_providers.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/utils/app_utils.dart';
import '../../common/providers/driver_all_trips_provider.dart';

class DriverEarningsPage extends HookConsumerWidget {
  const DriverEarningsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allTripsAsync = ref.watch(
        driverAllTripsProvider(ref.read(currentUserProvider)!.driverId!));

    return Scaffold(
      appBar: AppBar(
        title: const Text("Earnings"),
      ),
      body: SafeArea(
        child: allTripsAsync.when(
          data: (trips) {
            if (trips.isEmpty) {
              return const Center(
                child: Text("No trips yet"),
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                ref.invalidate(driverAllTripsProvider);
                await ref.watch(driverAllTripsProvider(
                        ref.read(currentUserProvider)!.driverId!)
                    .future);
              },
              child: ListView.separated(
                itemCount: trips.length,
                padding: const EdgeInsets.only(top: 16, bottom: 16),
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
                        "${trip.miles} miles completed in ${AppUtils.convertSecondstoTimeframe(Duration(seconds: trip.timeDrivenInSeconds!))}",
                        style: textTheme(context)
                            .titleSmall!
                            .copyWith(fontWeight: FontWeight.w400),
                      ),
                      trailing: Text(
                        "+ \$${trip.amount}",
                        style: textTheme(context).titleSmall!.copyWith(
                              fontWeight: FontWeight.w500,
                              color: Colors.green,
                            ),
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) => const Divider(height: 30),
              ),
            );
          },
          error: (err, st) {
            print("Error(my_earnings): $err");
            return const ErrorView();
          },
          loading: () => const AppLoader(),
        ),
      ),
    );
  }
}
