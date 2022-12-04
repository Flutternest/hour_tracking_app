extension XDouble on double {
  double toPrecision(int precision) {
    return double.parse(toStringAsFixed(precision));
  }
}
