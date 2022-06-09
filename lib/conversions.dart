/// # Conversions
///
/// When you do things that need units, sometimes you need to switch between them.
///
/// ## Using
///
/// ```dart
/// import 'package:geodart/conversion.dart';
///
/// // Convert distances
/// convertDistance(20, SingleAxisUnits.nauticalMiles, SingleAxisUnits.feet); // returns 121522
/// ```
library conversions;

export 'src/conversion/distance.dart';
