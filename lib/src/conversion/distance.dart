/// Convert [original] distance [from] some unit [to] another.
///
/// Example:
/// ```dart
/// convertDistance(100, DistanceUnits.centimeters, DistanceUnits.meters) // returns: 1
/// ```
double convertDistance(double original, DistanceUnit from, DistanceUnit to) {
  return original * to.meterRatio / from.meterRatio;
}

/// A class to define units
class DistanceUnit {
  final String title;
  final String identifier;
  final double meterRatio;

  const DistanceUnit(
      {required this.title,
      required this.identifier,
      required this.meterRatio});
}

/// A helper class to make units more accessible
class DistanceUnits {
  static final DistanceUnit feet =
      DistanceUnit(title: "Feet", identifier: "ft", meterRatio: 3.28084);
  static final DistanceUnit yards =
      DistanceUnit(title: "Yards", identifier: "yds", meterRatio: 1.09361);
  static final DistanceUnit inches =
      DistanceUnit(title: "Inches", identifier: "in", meterRatio: 39.3701);
  static final DistanceUnit nauticalMiles = DistanceUnit(
      title: "Nautical Miles", identifier: "nm", meterRatio: 0.000539957);
  static final DistanceUnit kilometers =
      DistanceUnit(title: "Kilometers", identifier: "Km", meterRatio: 0.001);
  static final DistanceUnit meters =
      DistanceUnit(title: "Meters", identifier: "m", meterRatio: 1);
  static final DistanceUnit centimeters =
      DistanceUnit(title: "Centimeters", identifier: "cm", meterRatio: 100);
  static final DistanceUnit millimeters =
      DistanceUnit(title: "Millimeters", identifier: "mm", meterRatio: 1000);
}
