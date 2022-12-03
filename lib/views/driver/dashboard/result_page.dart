import 'package:flutter/material.dart';
import 'package:flux_mvp/core/common_widgets/app_padding.dart';
import 'package:flux_mvp/core/utils/ui_helper.dart';

import '../../../core/constants/colors.dart';

class DriverResultPage extends StatelessWidget {
  const DriverResultPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Today's log result")),
      body: SafeArea(
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
                        offset:
                            const Offset(0, 3), // changes position of shadow
                      ),
                    ]),
                child: Column(
                  children: [
                    Text(
                      "\$300.0",
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
                        DataRow(cells: [
                          DataCell(Text("Payment")),
                          DataCell(Text(
                            "\$300.0",
                            style: TextStyle(color: Colors.green),
                          )),
                        ]),
                      ],
                    ),
                  ],
                ),
              ),
              verticalSpaceMedium,
              ElevatedButton(onPressed: () {}, child: const Text("Done"))
            ],
          ),
        ),
      ),
    );
  }
}
