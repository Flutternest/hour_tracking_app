import 'package:flutter/material.dart';

const Widget horizontalSpaceTiny = SizedBox(width: 4.0);
const Widget horizontalSpaceSmall = SizedBox(width: 8.0);
const Widget horizontalSpaceRegular = SizedBox(width: 16.0);
const Widget horizontalSpaceMedium = SizedBox(width: 24.0);
const Widget horizontalSpaceSemiLarge = SizedBox(width: 45.0);
const Widget horizontalSpaceLarge = SizedBox(width: 50.0);

const Widget verticalSpaceTiny = SizedBox(height: 4.0);
const Widget verticalSpaceSmall = SizedBox(height: 8.0);
const Widget verticalSpaceRegular = SizedBox(height: 16.0);
const Widget verticalSpaceMedium = SizedBox(height: 24.0);
const Widget verticalSpaceSemiLarge = SizedBox(height: 45.0);
const Widget verticalSpaceLarge = SizedBox(height: 50.0);

ThemeData theme(context) => Theme.of(context);
TextTheme textTheme(context) => theme(context).textTheme;

String validString(String? text, {String replacer = "N/A"}) => text != null
    ? text.isEmpty
        ? replacer
        : text
    : replacer;

String validImage(String? url) =>
    url ??
    'https://4.bp.blogspot.com/-OCutvC4wPps/XfNnRz5PvhI/AAAAAAAAEfo/qJ8P1sqLWesMdOSiEoUH85s3hs_vn97HACLcBGAsYHQ/s1600/no-image-found-360x260.png';

void showSnackBar(
  BuildContext? context, {
  String? message,
  Color color = Colors.black87,
  Icon? icon,
}) {
  if (context == null) return;
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Row(
      children: [
        icon ?? const SizedBox.shrink(),
        if (icon != null) horizontalSpaceRegular,
        Text(
          message ?? "Something went wrong",
          style: const TextStyle(color: Colors.white),
        ),
      ],
    ),
    duration: const Duration(seconds: 2),
    margin: const EdgeInsets.all(20),
    backgroundColor: color,
    behavior: SnackBarBehavior.floating,
  ));
}

void showErrorSnackBar(BuildContext? context, Object? error) {
  showSnackBar(context, message: error.toString());
}
