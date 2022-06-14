import 'dart:math' as math;
import 'package:geodart/geometries.dart';

/// A [BoundingBox] is a rectangular region in a coordinate system, generally used to define the extent of a [Feature] or [FeatureCollection].
/// A [BoundingBox] can be created from a [Coordinate] or a WKT [String].
///
/// Example:
/// ```dart
/// BoundingBox(1, 2, 3, 4); // BoundingBox(1, 2, 3, 4)
/// BoundingBox(1, 2, 3, 4).toWKT(); // POLYGON((1 2, 3 2, 3 4, 1 4, 1 2))
/// ```
class BoundingBox {
  final double minLong;
  final double minLat;
  final double maxLong;
  final double maxLat;
  static final type = 'BoundingBox';

  BoundingBox(this.minLong, this.minLat, this.maxLong, this.maxLat);

  /// Creates a [BoundingBox] for a [List] of [Coordinate]s.
  /// The [List] must contain at least two [Coordinate]s.
  ///
  /// Example:
  /// ```dart
  /// BoundingBox.fromPoints([
  ///   Point(Coordinate(1, 2)),
  ///   Point(Coordinate(3, 4)),
  /// ]); // BoundingBox(1, 2, 3, 4)
  /// ```
  factory BoundingBox.fromPoints(List<Point> points) {
    double minX = double.infinity;
    double minY = double.infinity;

    double maxX = double.negativeInfinity;
    double maxY = double.negativeInfinity;

    for (var point in points) {
      minX = math.min(minX, point.coordinate.longitude);
      minY = math.min(minY, point.coordinate.latitude);

      maxX = math.max(maxX, point.coordinate.longitude);
      maxY = math.max(maxY, point.coordinate.latitude);
    }

    return BoundingBox(minX, minY, maxX, maxY);
  }

  /// Creates a [BoundingBox] from a [List] of [Coordinate]s.
  /// The [List] must contain at least two [Coordinate]s.
  /// It's very similar to `BoundingBox.fromPoints`, but it's designed for use with [Coordinate]s.
  ///
  /// Example:
  /// ```dart
  /// BoundingBox.fromCoordinates([
  ///   Coordinate(1, 2),
  ///   Coordinate(3, 4),
  /// ]); // BoundingBox(1, 2, 3, 4)
  factory BoundingBox.fromCoordinates(List<Coordinate> coordinates) {
    double minX = double.infinity;
    double minY = double.infinity;

    double maxX = double.negativeInfinity;
    double maxY = double.negativeInfinity;

    for (var coordinate in coordinates) {
      minX = math.min(minX, coordinate.longitude);
      minY = math.min(minY, coordinate.latitude);

      maxX = math.max(maxX, coordinate.longitude);
      maxY = math.max(maxY, coordinate.latitude);
    }

    return BoundingBox(minX, minY, maxX, maxY);
  }

  /// Creates an empty [BoundingBox].
  /// This is the default value for [BoundingBox]s.
  ///
  /// Example:
  /// ```dart
  /// BoundingBox.empty(); // BoundingBox(0, 0, 0, 0)
  /// ```
  factory BoundingBox.empty() => BoundingBox(0, 0, 0, 0);

  /// Returns a [List] of [double] values representing the [BoundingBox] in the format [minLong, minLat, maxLong, maxLat].
  ///
  /// Example:
  /// ```dart
  /// BoundingBox(1, 2, 3, 4).toList(); // [1, 2, 3, 4]
  /// ```
  List<double> toList() => [minLong, minLat, maxLong, maxLat];

  /// Get the center [Point] of the [BoundingBox].
  ///
  /// Example:
  /// ```dart
  /// BoundingBox(1, 2, 3, 4).center; // Coordinate(2, 3)
  /// ```
  Coordinate get center =>
      Coordinate((minLat + maxLat) / 2, (minLong + maxLong) / 2);
}
