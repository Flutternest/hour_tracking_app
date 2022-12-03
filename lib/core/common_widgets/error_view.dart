import 'package:flutter/material.dart';
import 'package:flux_mvp/core/utils/ui_helper.dart';

class ErrorView extends StatelessWidget {
  const ErrorView({Key? key, this.onRefreshTap}) : super(key: key);

  final VoidCallback? onRefreshTap;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error, size: 40),
          verticalSpaceSmall,
          const Text("Oops! Something feels wrong"),
          verticalSpaceSmall,
          if (onRefreshTap != null)
            TextButton(onPressed: onRefreshTap, child: const Text('Refresh')),
        ],
      ),
    );
  }
}
