import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flux_mvp/auth/models/auth_user.dart';
import 'package:flux_mvp/core/common_widgets/app_loader.dart';
import 'package:flux_mvp/core/common_widgets/app_padding.dart';
import 'package:flux_mvp/core/common_widgets/error_view.dart';
import 'package:flux_mvp/core/constants/colors.dart';
import 'package:flux_mvp/core/utils/ui_helper.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/common_widgets/analytics_item.dart';
import '../../common/providers/all_drivers_provider.dart';
import '../../common/providers/filtered_tips_provider.dart';
import '../../driver/settings/analytics_page.dart';

class AdminAnalyticsPage extends HookConsumerWidget {
  const AdminAnalyticsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<AnalyticsFilter> filters = useMemoized(
      () => [
        AnalyticsFilter(filterName: "All", filterType: FilterType.all),
        AnalyticsFilter(filterName: "Paid", filterType: FilterType.paid),
        AnalyticsFilter(filterName: "Unpaid", filterType: FilterType.pending),
      ],
    );

    final driverId = useState<String?>(null);
    final filteredTripsAsync = ref.watch(filteredTripsProvider(driverId.value));
    final allDriversAsync = ref.watch(allDriversProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics'),
      ),
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            verticalSpaceMedium,
            DefaultAppPadding.horizontal(
              child: Row(
                children: [
                  Text(
                    "Driver:",
                    style: textTheme(context).subtitle1,
                  ),
                  horizontalSpaceSmall,
                  Expanded(
                    child: allDriversAsync.when(
                      data: (data) {
                        data = [
                          ...data,
                          const AuthUser(driverId: null, name: "All")
                        ];
                        return DropdownButton<String>(
                          value: driverId.value,
                          items: data
                              .map(
                                (e) => DropdownMenuItem(
                                  value: e.driverId,
                                  child: Text(e.name!),
                                ),
                              )
                              .toList(),
                          onChanged: (value) => driverId.value = value,
                          isExpanded: true,
                        );
                      },
                      error: (err, st) => const SizedBox.shrink(),
                      loading: () => const AppLoader(),
                    ),
                  ),
                ],
              ),
            ),
            verticalSpaceMedium,
            Container(
              color: kDarkBackground,
              height: 40,
              child: ListView.separated(
                itemCount: filters.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      final filter = filters[index];

                      ref.read(filterTypeProvider.notifier).state =
                          filter.filterType;
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 6),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(1000),
                        color: filters[index].filterType ==
                                ref.watch(filterTypeProvider)
                            ? kPrimaryColor
                            : kOverlayDarkBackground,
                      ),
                      margin: EdgeInsets.only(
                        left: index == 0 ? 24.0 : 0,
                        right: index == filters.length - 1 ? 24.0 : 0,
                      ),
                      child: Center(child: Text(filters[index].filterName)),
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) =>
                    horizontalSpaceSmall,
              ),
            ),
            verticalSpaceMedium,
            Expanded(
              child: filteredTripsAsync.when(
                data: (trips) {
                  if (trips.isEmpty) {
                    return const Center(
                      child: Text('No trips found'),
                    );
                  }
                  return DefaultAppPadding.horizontal(
                    child: ListView.separated(
                      itemCount: trips.length,
                      itemBuilder: (context, index) {
                        final trip = trips[index];
                        return AnalyticsItem(
                            isPaid: trip.paymentStatus == "paid", trip: trip);
                      },
                      separatorBuilder: (context, index) =>
                          verticalSpaceRegular,
                    ),
                  );
                },
                error: (error, stackTrace) => const ErrorView(),
                loading: () => const AppLoader(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
