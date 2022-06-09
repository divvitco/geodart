/// Convert [original] distance [from] some unit [to] another.
///
/// Example:
/// ```dart
/// convertDistance(100, SingleAxisUnits.centimeters, SingleAxisUnits.meters) // returns: 1
/// ```
double convertDistance(
    double original, SingleAxisUnit from, SingleAxisUnit to) {
  return original * to.meterRatio / from.meterRatio;
}

/// A class to define units
class SingleAxisUnit {
  final String title;
  final String identifier;
  final double meterRatio;

  const SingleAxisUnit(
      {required this.title,
      required this.identifier,
      required this.meterRatio});
}

/// A helper class to
class SingleAxisUnits {
  static final SingleAxisUnit feet =
      SingleAxisUnit(title: "Feet", identifier: "ft", meterRatio: 3.28084);
  static final SingleAxisUnit yards =
      SingleAxisUnit(title: "Yards", identifier: "yds", meterRatio: 1.09361);
  static final SingleAxisUnit inches =
      SingleAxisUnit(title: "Inches", identifier: "in", meterRatio: 39.3701);
  static final SingleAxisUnit nauticalMiles = SingleAxisUnit(
      title: "Nautical Miles", identifier: "nm", meterRatio: 0.000539957);
  static final SingleAxisUnit kilometers =
      SingleAxisUnit(title: "Kilometers", identifier: "Km", meterRatio: 0.001);
  static final SingleAxisUnit meters =
      SingleAxisUnit(title: "Meters", identifier: "m", meterRatio: 1);
  static final SingleAxisUnit centimeters =
      SingleAxisUnit(title: "Centimeters", identifier: "cm", meterRatio: 100);
  static final SingleAxisUnit millimeters =
      SingleAxisUnit(title: "Millimeters", identifier: "mm", meterRatio: 1000);
}
