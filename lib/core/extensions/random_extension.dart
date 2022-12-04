import 'dart:math';

import 'package:flux_mvp/core/extensions/double_extension.dart';

extension XRandom on Random {
  double nextDoubleInRange(double start, double end, [int precision = 2]) {
    return ((nextDouble() * (end - start) + start).toPrecision(2));
  }
}
