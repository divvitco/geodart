/// Convert [original] angle [from] some unit [to] another.
///
/// Example:
/// ```dart
/// convertAngle(100, AngleUnits.degrees, AngleUnits.radians) // returns: 0.017453292519943295
/// ```
double convertAngle(double original, AngleUnit from, AngleUnit to) {
  return original * to.radianRatio / from.radianRatio;
}

/// A class to define units of angle
class AngleUnit {
  final String title;
  final String identifier;
  final double radianRatio;

  const AngleUnit(
      {required this.title,
      required this.identifier,
      required this.radianRatio});
}

/// A helper class to make units of angle more accessible
class AngleUnits {
  static final AngleUnit radians =
      AngleUnit(title: "Radians", identifier: "rad", radianRatio: 1);
  static final AngleUnit degrees =
      AngleUnit(title: "Degrees", identifier: "deg", radianRatio: 57.2958);
  static final AngleUnit gradians =
      AngleUnit(title: "Gradians", identifier: "grad", radianRatio: 63.662);
  static final AngleUnit turns =
      AngleUnit(title: "Turns", identifier: "turn", radianRatio: 0.159155);
  static final AngleUnit arcSeconds =
      AngleUnit(title: "Arc Seconds", identifier: "asec", radianRatio: 206265);
  static final AngleUnit arcMinutes = AngleUnit(
      title: "Arc Minutes", identifier: "amin", radianRatio: 3437.750002264);
  static final AngleUnit milliradians =
      AngleUnit(title: "Milliradians", identifier: "mrad", radianRatio: 0.001);
}
