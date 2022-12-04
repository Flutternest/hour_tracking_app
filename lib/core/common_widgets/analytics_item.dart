import 'package:flutter/material.dart';
import 'package:flux_mvp/core/utils/ui_helper.dart';
import 'package:intl/intl.dart';

import '../../features/common/providers/trip.dart';
import '../constants/colors.dart';

class AnalyticsItem extends StatelessWidget {
  const AnalyticsItem({
    required this.trip,
    this.isPaid = false,
    this.onMarkAsPaidTap,
    Key? key,
  }) : super(key: key);

  final bool isPaid;
  final Trip trip;
  final VoidCallback? onMarkAsPaidTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      color: kOverlayDarkBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Row(
              children: [
                const Icon(Icons.directions_car),
                horizontalSpaceSmall,
                Text.rich(
                  TextSpan(
                    text: 'Trip ',
                    style: const TextStyle(color: Colors.grey),
                    children: [
                      TextSpan(
                        text: '#${trip.tripId}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      )
                    ],
                  ),
                ),
                const Spacer(),
                CircleAvatar(
                  radius: 3,
                  backgroundColor: isPaid ? Colors.green : Colors.red,
                ),
                horizontalSpaceSmall,
                Text.rich(
                  TextSpan(
                    text: '\$${trip.amount}',
                    style: TextStyle(
                      color: isPaid ? Colors.green : Colors.red,
                    ),
                    children: const [
                      TextSpan(
                        text: '',
                      )
                    ],
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Divider(),
                Text.rich(
                  TextSpan(
                    text: 'Start: ',
                    style: const TextStyle(color: Colors.grey),
                    children: [
                      TextSpan(
                        // text: 'Thur, 2 Nov at 05:30 PM',
                        text: DateFormat("EEEE dd MMM, hh:mm aaa")
                            .format(trip.start!),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      )
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(2, (index) => const Text(".")),
                ),
                Text.rich(
                  TextSpan(
                    text: 'End: ',
                    style: const TextStyle(color: Colors.grey),
                    children: [
                      TextSpan(
                        text: DateFormat("EEEE dd MMM, hh:mm aaa")
                            .format(trip.end!),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      )
                    ],
                  ),
                ),
                const Divider(),
                verticalSpaceSmall,
                Text.rich(
                  TextSpan(
                    text: 'ELD# ',
                    style: const TextStyle(color: Colors.grey),
                    children: [
                      TextSpan(
                        text: trip.eldSerialId,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      )
                    ],
                  ),
                ),
                verticalSpaceSmall,
                Text.rich(
                  TextSpan(
                    text: 'Miles Covered: ',
                    style: const TextStyle(color: Colors.grey),
                    children: [
                      TextSpan(
                        text: trip.miles.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      )
                    ],
                  ),
                ),
                const Divider(
                  height: 30,
                ),
                Text.rich(
                  TextSpan(
                    text: 'Payment Status: ',
                    style: const TextStyle(color: Colors.grey),
                    children: [
                      TextSpan(
                        text: isPaid ? 'Paid' : 'Pending',
                        style: TextStyle(
                          color: isPaid ? Colors.green : Colors.red,
                          fontWeight: FontWeight.w700,
                        ),
                      )
                    ],
                  ),
                ),
                const Divider(
                  height: 30,
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: kDarkBackground,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 14,
                        backgroundColor: Colors.grey,
                        child: Text(trip.driverName![0].toUpperCase()),
                      ),
                      horizontalSpaceSmall,
                      Text(trip.driverName!),
                      const Spacer(),
                      Text(trip.driverEmail!),
                    ],
                  ),
                ),
                if (!isPaid && onMarkAsPaidTap != null) ...[
                  verticalSpaceRegular,
                  ElevatedButton.icon(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 10),
                    ),
                    icon: const Icon(Icons.check_circle),
                    label: const Text("Mark as Paid"),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
