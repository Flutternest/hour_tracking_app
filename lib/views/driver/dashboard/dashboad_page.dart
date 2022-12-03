import 'package:flutter/material.dart';
import 'package:flux_mvp/core/common_widgets/app_padding.dart';
import 'package:flux_mvp/core/constants/paths.dart';
import 'package:flux_mvp/core/utils/ui_helper.dart';
import 'package:flux_mvp/routing/router.dart';

import '../../../core/constants/colors.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Dashboard")),
      body: SafeArea(
        child: DefaultAppPadding.horizontal(
          child: SingleChildScrollView(
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
                        const CircleAvatar(
                          radius: 4,
                          backgroundColor: Colors.red,
                        ),
                        horizontalSpaceSmall,
                        Text(
                          "Commute not started",
                          style: textTheme(context).titleMedium!,
                        ),
                      ],
                    ),
                  ),
                ),
                verticalSpaceMedium,
                ElevatedButton(
                  onPressed: () {},
                  child: const Text("Start Driving"),
                ),
                verticalSpaceMedium,
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kOverlayDarkBackground,
                        ),
                        child: const Text("Pause"),
                      ),
                    ),
                    horizontalSpaceRegular,
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          AppRouter.navigateToPage(AppRoutes.driverResultPage);
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red),
                        child: const Text("End Trip"),
                      ),
                    ),
                  ],
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
          ),
        ),
      ),
    );
  }
}
