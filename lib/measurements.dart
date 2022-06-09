/// A collection of measurement functions.
///
/// All measurements are in meters or square meters.
/// All measurements are in the [EPSG:4326] coordinate system.
///
/// Example:
/// ```dart
/// import 'package:geodart/src/measure.dart';
///
/// // Calculate the distance between two points.
/// double distance = measure.distance(Point(0, 0), Point(1, 1));
///
/// // Calculate the bearing between two points.
/// double bearing = measure.bearing(Point(0, 0), Point(1, 1));
///
/// // Calculate the length of a LineString
/// LineString([Coordinate(1, 2), Coordinate(3, 4)]).length; // 314283.2550736839
///
/// // Calculate the area of a Polygon
/// Polygon([
///   LinearRing([Coordinate(1, 2), Coordinate(3, 4), Coordinate(5, 6), Coordinate(1, 2)])
/// ]).area; // 12.5
/// ```
library measurements;

export 'src/measure/bearing.dart';
export 'src/measure/distance.dart';
export 'src/measure/length.dart';
export 'src/measure/area.dart';
