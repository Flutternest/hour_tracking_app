import 'package:flutter/material.dart';
import 'package:flux_mvp/core/common_widgets/app_loader.dart';
import 'package:flux_mvp/core/common_widgets/error_view.dart';
import 'package:flux_mvp/core/constants/colors.dart';
import 'package:flux_mvp/core/utils/ui_helper.dart';
import 'package:flux_mvp/routing/router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../common/providers/all_drivers_provider.dart';

class AdminDriversPage extends HookConsumerWidget {
  const AdminDriversPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allDriversAsync = ref.watch(allDriversProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Drivers'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          AppRouter.navigateToPage(AppRoutes.adminAddDriversPage);
        },
        backgroundColor: kPrimaryColor,
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: allDriversAsync.when(
          data: (drivers) {
            if (drivers.isEmpty) {
              return const Center(
                child: Text('No drivers found'),
              );
            }
            return ListView.separated(
              itemCount: drivers.length,
              padding: const EdgeInsets.only(top: 16, bottom: 16),
              itemBuilder: (context, index) {
                final driver = drivers[index];
                return ListTile(
                  leading: CircleAvatar(
                    radius: 25,
                    backgroundColor: kOverlayDarkBackground,
                    child: Text(driver.name![0].toUpperCase()),
                  ),
                  trailing: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    decoration: BoxDecoration(
                      color: kOverlayDarkBackground,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      "#${driver.driverId}",
                      style: textTheme(context).titleMedium,
                    ),
                  ),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        driver.name!,
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      verticalSpaceTiny,
                      Text(
                        driver.email!,
                        style: const TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                      verticalSpaceTiny,
                    ],
                  ),
                  subtitle: Text(
                    "ELD# ${driver.eldSerialId}",
                    style: const TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return const Divider();
              },
            );
          },
          error: (e, st) => const ErrorView(),
          loading: () => const AppLoader(),
        ),
      ),
    );
  }
}
