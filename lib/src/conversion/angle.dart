import 'dart:math';

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
  /// The title of the unit
  final String title;

  /// The identifier of the unit
  final String identifier;

  /// The ratio of the unit to radians
  final double radianRatio;

  const AngleUnit(
      {required this.title,
      required this.identifier,
      required this.radianRatio});
}

/// A helper class to make units of angle more accessible
class AngleUnits {
  /// Angle Unit: Radians: 1 Radian = 57.2958 Degrees
  static final AngleUnit radians =
      AngleUnit(title: "Radians", identifier: "rad", radianRatio: 1);

  /// Angle Unit: Degrees: 1 Degree = 1 Degree
  static final AngleUnit degrees =
      AngleUnit(title: "Degrees", identifier: "deg", radianRatio: 180 / pi);

  /// Angle Unit: Gradians: 1 Gradian = 0.9 degrees
  static final AngleUnit gradians =
      AngleUnit(title: "Gradians", identifier: "grad", radianRatio: 63.662);

  /// Angle Unit: Turns: 1 Turn = 360 Degrees
  static final AngleUnit turns =
      AngleUnit(title: "Turns", identifier: "turn", radianRatio: 0.159155);

  /// Angle Unit: Arc Seconds: 1 Arc Second = 1/3600 Degrees
  static final AngleUnit arcSeconds =
      AngleUnit(title: "Arc Seconds", identifier: "asec", radianRatio: 206265);

  /// Angle Unit: Arc Minutes: 1 Arc Minute = 1/60 Degrees
  static final AngleUnit arcMinutes = AngleUnit(
      title: "Arc Minutes", identifier: "amin", radianRatio: 3437.750002264);

  /// Angle Unit: Milliradians: 1 Milliradian = 0.0572958 Degrees
  static final AngleUnit milliradians =
      AngleUnit(title: "Milliradians", identifier: "mrad", radianRatio: 0.001);
}
