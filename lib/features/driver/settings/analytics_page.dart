import 'package:flutter/material.dart';
import 'package:flux_mvp/core/common_widgets/app_padding.dart';
import 'package:flux_mvp/core/constants/colors.dart';
import 'package:flux_mvp/core/utils/ui_helper.dart';

class DriverAnalyticsPage extends StatelessWidget {
  const DriverAnalyticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> filters = [
      "All",
      "Today",
      "This Week",
      "This Month",
      "This Year",
    ];
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
                  return Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 40, vertical: 6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(1000),
                      color:
                          index == 0 ? kPrimaryColor : kOverlayDarkBackground,
                    ),
                    margin: EdgeInsets.only(
                      left: index == 0 ? 24.0 : 0,
                      right: index == filters.length - 1 ? 24.0 : 0,
                    ),
                    child: Center(child: Text(filters[index])),
                  );
                },
                separatorBuilder: (BuildContext context, int index) =>
                    horizontalSpaceSmall,
              ),
            ),
            verticalSpaceMedium,
            Expanded(
              child: DefaultAppPadding.horizontal(
                child: ListView.separated(
                  itemCount: 30,
                  itemBuilder: (context, index) {
                    return AnalyticsItem(isPaid: index % 2 == 0);
                  },
                  separatorBuilder: (context, index) => verticalSpaceRegular,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AnalyticsItem extends StatelessWidget {
  const AnalyticsItem({
    this.isPaid = false,
    Key? key,
  }) : super(key: key);

  final bool isPaid;

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
                const Text.rich(
                  TextSpan(
                    text: 'Trip ',
                    style: TextStyle(color: Colors.grey),
                    children: [
                      TextSpan(
                        text: '#123456',
                        style: TextStyle(
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
                    text: '\$2000',
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
                const Text.rich(
                  TextSpan(
                    text: 'Start: ',
                    style: TextStyle(color: Colors.grey),
                    children: [
                      TextSpan(
                        text: 'Thur, 2 Nov at 05:30 PM',
                        style: TextStyle(
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
                const Text.rich(
                  TextSpan(
                    text: 'End: ',
                    style: TextStyle(color: Colors.grey),
                    children: [
                      TextSpan(
                        text: 'Thur, 2 Nov at 05:30 PM',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      )
                    ],
                  ),
                ),
                const Divider(),
                verticalSpaceSmall,
                const Text.rich(
                  TextSpan(
                    text: 'ELD# ',
                    style: TextStyle(color: Colors.grey),
                    children: [
                      TextSpan(
                        text: '1234-5678',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      )
                    ],
                  ),
                ),
                verticalSpaceSmall,
                const Text.rich(
                  TextSpan(
                    text: 'Miles Covered: ',
                    style: TextStyle(color: Colors.grey),
                    children: [
                      TextSpan(
                        text: '200.3',
                        style: TextStyle(
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
                    children: const [
                      CircleAvatar(
                        radius: 14,
                        backgroundColor: Colors.grey,
                        child: Text("J"),
                      ),
                      horizontalSpaceSmall,
                      Text('John Doe'),
                      Spacer(),
                      Text('john@email.com'),
                    ],
                  ),
                ),
                if (!isPaid) ...[
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
