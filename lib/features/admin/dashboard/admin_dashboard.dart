import 'package:flutter/material.dart';
import 'package:flux_mvp/core/common_widgets/app_padding.dart';
import 'package:flux_mvp/core/utils/ui_helper.dart';

import '../../../core/constants/colors.dart';

class AdminDashboardPage extends StatelessWidget {
  const AdminDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
      ),
      body: SafeArea(
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
                            "\$100",
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
                            "3".padLeft(2, "0"),
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
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: kOverlayDarkBackground,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      "Pending Payments",
                      style: TextStyle(color: Colors.grey),
                    ),
                    verticalSpaceSmall,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: List.generate(
                        4,
                        (index) => Padding(
                          padding: const EdgeInsets.only(top: 12.0),
                          child: Row(
                            children: [
                              const Text("John Doe"),
                              horizontalSpaceSmall,
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child: LinearProgressIndicator(
                                    minHeight: 10,
                                    color: Colors.red,
                                    value: (index + .2) * 0.12,
                                  ),
                                ),
                              ),
                              horizontalSpaceSmall,
                              const Text(
                                "\$200",
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              verticalSpaceMedium,
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: kOverlayDarkBackground,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      "Ongoing Trips",
                      style: TextStyle(color: Colors.grey),
                    ),
                    verticalSpaceSmall,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: List.generate(
                        4,
                        (index) => Padding(
                          padding: const EdgeInsets.only(top: 12.0),
                          child: Row(
                            children: [
                              const Text("John Doe"),
                              horizontalSpaceSmall,
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child: LinearProgressIndicator(
                                    minHeight: 10,
                                    color: kPrimaryColor,
                                    value: (index + .2) * 0.12,
                                  ),
                                ),
                              ),
                              horizontalSpaceSmall,
                              const Text(
                                "\$200",
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
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
    );
  }
}
