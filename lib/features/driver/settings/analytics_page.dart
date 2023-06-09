import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flux_mvp/core/common_widgets/app_loader.dart';
import 'package:flux_mvp/core/common_widgets/app_padding.dart';
import 'package:flux_mvp/core/common_widgets/error_view.dart';
import 'package:flux_mvp/core/constants/colors.dart';
import 'package:flux_mvp/core/utils/ui_helper.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/common_widgets/analytics_item.dart';
import '../../../global_providers.dart';
import '../../common/providers/filtered_tips_provider.dart';

class AnalyticsFilter {
  final String filterName;
  final FilterType filterType;

  AnalyticsFilter({required this.filterName, required this.filterType});
}

class DriverAnalyticsPage extends HookConsumerWidget {
  const DriverAnalyticsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<AnalyticsFilter> filters = useMemoized(
      () => [
        AnalyticsFilter(filterName: "All", filterType: FilterType.all),
        AnalyticsFilter(filterName: "Paid", filterType: FilterType.paid),
        AnalyticsFilter(filterName: "Unpaid", filterType: FilterType.pending),
      ],
    );

    final filteredTripsAsync = ref
        .watch(filteredTripsProvider(ref.read(currentUserProvider)!.driverId!));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics'),
      ),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
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
