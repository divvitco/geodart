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
/// ```
library conversions;

export 'src/conversion/distance.dart';
export 'src/conversion/area.dart';
