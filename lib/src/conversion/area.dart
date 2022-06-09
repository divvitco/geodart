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
  final String title;
  final String identifier;
  final double squareMeterRatio;

  const AreaUnit(
      {required this.title,
      required this.identifier,
      required this.squareMeterRatio});
}

/// A helper class to make units of area more accessible
class AreaUnits {
  static final AreaUnit squareMeters =
      AreaUnit(title: "Square Meters", identifier: "m2", squareMeterRatio: 1);
  static final AreaUnit squareKilometers = AreaUnit(
      title: "Square Kilometers", identifier: "km2", squareMeterRatio: 1e-6);
  static final AreaUnit squareMiles = AreaUnit(
      title: "Square Miles", identifier: "mi2", squareMeterRatio: 3.861e-7);
  static final AreaUnit acres =
      AreaUnit(title: "Acres", identifier: "ac", squareMeterRatio: 0.000247105);
  static final AreaUnit hectares =
      AreaUnit(title: "Hectares", identifier: "ha", squareMeterRatio: 1e-4);
  static final AreaUnit squareFeet = AreaUnit(
      title: "Square Feet", identifier: "ft2", squareMeterRatio: 10.7639);
  static final AreaUnit squareYards = AreaUnit(
      title: "Square Yards", identifier: "yd2", squareMeterRatio: 1.19599);
  static final AreaUnit squareInches = AreaUnit(
      title: "Square Inches", identifier: "in2", squareMeterRatio: 1550);
}
