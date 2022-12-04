import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flux_mvp/core/common_widgets/app_padding.dart';
import 'package:flux_mvp/core/common_widgets/error_view.dart';
import 'package:flux_mvp/core/utils/ui_helper.dart';
import 'package:flux_mvp/routing/router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/common_widgets/app_loader.dart';
import '../../../core/constants/colors.dart';
import '../../../core/utils/app_utils.dart';
import '../controllers/trip_details_controller.dart';

class DriverResultPage extends HookConsumerWidget {
  const DriverResultPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final int tripId =
        useMemoized(() => ModalRoute.of(context)!.settings.arguments as int);
    final tripDetailsAsync = ref.watch(tripDetailsProvider(tripId));

    return Scaffold(
      appBar: AppBar(title: const Text("Today's log result")),
      body: SafeArea(
        child: tripDetailsAsync.when(
          data: (trip) {
            return SingleChildScrollView(
              child: DefaultAppPadding(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      "You've completed your trip today!",
                      style: textTheme(context).titleLarge!,
                      textAlign: TextAlign.center,
                    ),
                    verticalSpaceMedium,
                    Container(
                      padding: const EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                          color: kOverlayDarkBackground,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey[800]!),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: const Offset(
                                  0, 3), // changes position of shadow
                            ),
                          ]),
                      child: Column(
                        children: [
                          Text(
                            "\$${trip.amount}",
                            style: textTheme(context).displaySmall!.copyWith(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                ),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            "Earnings",
                            style: textTheme(context).subtitle1,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
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
                                  AppUtils.formatTimer(Duration(
                                      seconds: trip.timeDrivenInSeconds!)),
                                )),
                              ]),
                              // const DataRow(cells: [
                              //   DataCell(Text("Time Paused")),
                              //   DataCell(Text("00:00:00")),
                              // ]),
                              DataRow(cells: [
                                const DataCell(Text("Miles Covered")),
                                DataCell(Text("${trip.miles}")),
                              ]),
                              DataRow(cells: [
                                const DataCell(Text("Pay/Mile")),
                                DataCell(Text("\$${trip.payPerMile}")),
                              ]),
                              DataRow(cells: [
                                const DataCell(Text("Payment")),
                                DataCell(Text(
                                  "\$${trip.amount}",
                                  style: const TextStyle(color: Colors.green),
                                )),
                              ]),
                            ],
                          ),
                        ],
                      ),
                    ),
                    verticalSpaceRegular,
                    ElevatedButton.icon(
                      onPressed: () => AppRouter.navigateToPage(
                          AppRoutes.driverAnalyticsPage),
                      icon: const Icon(Icons.auto_graph_sharp),
                      label: const Text("View All Trips"),
                    ),
                    verticalSpaceRegular,
                    ElevatedButton.icon(
                      onPressed: () => AppRouter.navigateToPage(
                          AppRoutes.driverEarningsPage),
                      icon: const Icon(Icons.attach_money),
                      label: const Text("View All Earnings"),
                    ),
                    verticalSpaceMedium,
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
