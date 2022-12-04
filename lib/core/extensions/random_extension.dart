import 'dart:math';

extension XRandom on Random {
  double nextDoubleInRange(double start, double end, [int precision = 2]) {
    return double.parse(
        (nextDouble() * (end - start) + start).toStringAsFixed(precision));
  }
}
