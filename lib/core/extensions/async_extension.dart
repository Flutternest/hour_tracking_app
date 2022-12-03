import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

extension AsyncValueUI on AsyncValue {
  void _showSnackbarOnError(BuildContext context) {
    if (!isRefreshing && hasError) {
      String errorMessage = "Something went wrong";
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(error != null ? error.toString() : errorMessage)),
      );
    }
  }

  void handleErrors(BuildContext context, WidgetRef ref) {
    _showSnackbarOnError(context);
  }
}
