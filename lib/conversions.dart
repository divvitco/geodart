/// # Conversions
///
/// When you do things that need units, sometimes you need to switch between them.
///
/// ## Using
///
/// ```dart
/// import 'package:geodart/conversions.dart';
///
/// // Convert distances
/// convertDistance(20, DistanceUnits.nauticalMiles, DistanceUnits.feet); // returns 121522
///
/// // Convert areas
/// convertArea(20, AreaUnits.hectares, AreaUnits.squareMeters); // returns 200000
///
/// // Convert angles
/// convertAngle(20, AngleUnits.degrees, AngleUnits.radians); // returns 0.349079173398
/// ```
library conversions;

export 'src/conversion/distance.dart';
export 'src/conversion/area.dart';
export 'src/conversion/angle.dart';
