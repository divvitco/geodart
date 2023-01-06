import 'package:geodart/geometries.dart';

/// The base class for all feature types.
abstract class Feature {
  Map<String, dynamic> properties;
  static final String type = 'Feature';

  Feature({this.properties = const <String, dynamic>{}});

  @override
  String toString();

  /// Converts the [Feature] to a WKT [String].
  String toWKT();

  /// Converts the [Feature] to a JSON object.
  Map<String, dynamic> toJson();

  /// Creates a [Feature] from a JSON object.
  factory Feature.fromJson(Map<String, dynamic> json) {
    throw UnimplementedError();
  }

  /// Creates a [Feature] from a WKT [String].
  factory Feature.fromWKT(String wkt) {
    throw UnimplementedError();
  }

  /// Explodes the [Feature] into a list of [Point]s.
  List<Point> explode();

  /// Returns the center [Point] of the [Feature].
  /// This is the average of all [Coordinate]s in the [Feature].
  Point get center;

  /// Returns the [BoundingBox] of the [Feature].
  /// This is the bounding box of all [Coordinate]s in the [Feature].
  BoundingBox get bbox;

  /// Adds two [Feature]s together to form a [FeatureCollection].
  /// Each [Feature] in the [FeatureCollection] will retain their [properties] and [coordinates].
  ///
  /// Example:
  /// ```dart
  /// Point(Coordinate(1, 2)) + Point(Coordinate(3, 4)); // FeatureCollection([Point(Coordinate(1, 2)), Point(Coordinate(3, 4))])
  /// Polygon([LinearRing([Coordinate(0, 0), Coordinate(1, 0), Coordinate(1, 1), Coordinate(0, 1), Coordinate(0, 0)])]) + MultiPoint([Coordinate(1, 1), Coordinate(2, 2)]); // FeatureCollection([Polygon([LinearRing([Coordinate(0, 0), Coordinate(1, 0), Coordinate(1, 1), Coordinate(0, 1), Coordinate(0, 0)])]), MultiPoint([Coordinate(1, 1), Coordinate(2, 2)])])
  /// ```
  FeatureCollection operator +(Feature other) {
    return FeatureCollection([this, other]);
  }

  // /// Adds a buffer distance to the [Feature].
  // /// [distance] is in meters. [steps] is the number of points used to approximate the buffer.
  // ///
  // /// Example:
  // /// ```dart
  // /// Point(Coordinate(1, 2)).buffer(0.5); // Polygon([LinearRing([Coordinate(0, 0), Coordinate(1, 0), Coordinate(1, 1), Coordinate(0, 1), Coordinate(0, 0)])])
  // /// ```
  // Feature buffer(double distance, {int steps = 8});
}
