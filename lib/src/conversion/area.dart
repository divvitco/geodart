/// Convert [original] area [from] some unit [to] another.
///
/// Example:
/// ```dart
/// convertArea(100, AreaUnits.hectares, AreaUnits.squareMeters) // returns: 10000
/// ```
double convertArea(
  double original,
  AreaUnit from,
  AreaUnit to,
) {
  return original * to.squareMeterRatio / from.squareMeterRatio;
}

/// A class to define units of area
class AreaUnit {
  /// The title of the unit
  final String title;

  /// The identifier of the unit
  final String identifier;

  /// The ratio of the unit to square meters
  final double squareMeterRatio;

  const AreaUnit(
      {required this.title,
      required this.identifier,
      required this.squareMeterRatio});
}

/// A helper class to make units of area more accessible
class AreaUnits {
  /// Area Unit: Square Meters: 1 Square Meter = 1 Square Meter
  static final AreaUnit squareMeters =
      AreaUnit(title: "Square Meters", identifier: "m2", squareMeterRatio: 1);

  /// Area Unit: Square Kilometers: 1 Square Kilometer = 1e-6 Square Meters
  static final AreaUnit squareKilometers = AreaUnit(
      title: "Square Kilometers", identifier: "km2", squareMeterRatio: 1e-6);

  /// Area Unit: Square Miles: 1 Square Mile = 3.861e-7 Square Meters
  static final AreaUnit squareMiles = AreaUnit(
      title: "Square Miles", identifier: "mi2", squareMeterRatio: 3.861e-7);

  /// Area Unit: Acres: 1 Acre = 0.000247105 Square Meters
  static final AreaUnit acres =
      AreaUnit(title: "Acres", identifier: "ac", squareMeterRatio: 0.000247105);

  /// Area Unit: Hectares: 1 Hectare = 1e-4 Square Meters
  static final AreaUnit hectares =
      AreaUnit(title: "Hectares", identifier: "ha", squareMeterRatio: 1e-4);

  /// Area Unit: Square Feet: 1 Square Foot = 10.7639 Square Meters
  static final AreaUnit squareFeet = AreaUnit(
      title: "Square Feet", identifier: "ft2", squareMeterRatio: 10.7639);

  /// Area Unit: Square Yards: 1 Square Yard = 1.19599 Square Meters
  static final AreaUnit squareYards = AreaUnit(
      title: "Square Yards", identifier: "yd2", squareMeterRatio: 1.19599);

  /// Area Unit: Square Inches: 1 Square Inch = 1550 Square Meters
  static final AreaUnit squareInches = AreaUnit(
      title: "Square Inches", identifier: "in2", squareMeterRatio: 1550);
}
