import 'package:flutter/material.dart';
import 'package:flux_mvp/core/common_widgets/app_padding.dart';
import 'package:flux_mvp/core/utils/ui_helper.dart';

class DriverEarningsPage extends StatelessWidget {
  const DriverEarningsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Earnings"),
      ),
      body: SafeArea(
        child: DefaultAppPadding(
          child: ListView.separated(
            itemCount: 30,
            itemBuilder: (context, index) {
              return ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.wallet_travel_rounded),
                horizontalTitleGap: 4,
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Mon, Nov 20, 05:44 PM",
                      style: textTheme(context)
                          .titleSmall!
                          .copyWith(fontWeight: FontWeight.w700),
                    ),
                    verticalSpaceSmall,
                    Text(
                      "Trip: #229",
                      style: textTheme(context)
                          .titleSmall!
                          .copyWith(fontWeight: FontWeight.w400),
                    ),
                    verticalSpaceSmall,
                  ],
                ),
                subtitle: Text(
                  "200 miles completed in 1h 20m",
                  style: textTheme(context)
                      .titleSmall!
                      .copyWith(fontWeight: FontWeight.w400),
                ),
                trailing: Text(
                  "+ \$100",
                  style: textTheme(context).titleSmall!.copyWith(
                        fontWeight: FontWeight.w500,
                        color: Colors.green,
                      ),
                ),
              );
            },
            separatorBuilder: (context, index) => const Divider(height: 30),
          ),
        ),
      ),
    );
  }
}
