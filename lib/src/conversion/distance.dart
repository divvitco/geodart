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
  /// The title of the unit
  final String title;

  /// The identifier of the unit
  final String identifier;

  /// The ratio of the unit to meters
  final double meterRatio;

  const DistanceUnit(
      {required this.title,
      required this.identifier,
      required this.meterRatio});
}

/// A helper class to make units more accessible
class DistanceUnits {
  /// Distance Unit: Feet: 1 Foot = 0.3048 Meters
  static const DistanceUnit feet =
      DistanceUnit(title: "Feet", identifier: "ft", meterRatio: 3.28084);

  /// Distance Unit: Yards: 1 Yard = 1.09361 Meters
  static const DistanceUnit yards =
      DistanceUnit(title: "Yards", identifier: "yds", meterRatio: 1.09361);

  /// Distance Unit: Miles: 1 Mile = 0.000621371 Meters
  static const DistanceUnit inches =
      DistanceUnit(title: "Inches", identifier: "in", meterRatio: 39.3701);

  /// Distance Unit: Miles: 1 Mile = 1609.34 Meters
  static const DistanceUnit nauticalMiles = DistanceUnit(
      title: "Nautical Miles", identifier: "nm", meterRatio: 0.000539957);

  /// Distance Unit: Kilometers: 1 Kilometer = 1000 Meters
  static const DistanceUnit kilometers =
      DistanceUnit(title: "Kilometers", identifier: "Km", meterRatio: 0.001);

  /// Distance Unit: Meters: 1 Meter = 1 Meter
  static const DistanceUnit meters =
      DistanceUnit(title: "Meters", identifier: "m", meterRatio: 1);

  /// Distance Unit: Centimeters: 1 Centimeter = 100 Meters
  static const DistanceUnit centimeters =
      DistanceUnit(title: "Centimeters", identifier: "cm", meterRatio: 100);

  /// Distance Unit: Millimeters: 1 Millimeter = 1000 Meters
  static const DistanceUnit millimeters =
      DistanceUnit(title: "Millimeters", identifier: "mm", meterRatio: 1000);

  /// Distance Unit: Miles: 1 Mile = 1609.34 Meters
  static const DistanceUnit miles =
      DistanceUnit(title: "Miles", identifier: "mi", meterRatio: 0.000621371);
}
