import 'package:geodart/geometries.dart';

/// A FeatureCollection is a collection of [Feature]s.
class FeatureCollection {
  List<Feature> features;
  static final String type = 'FeatureCollection';

  FeatureCollection(this.features);

  @override
  String toString() {
    return features.map((f) => f.toString()).toList().join(',');
  }

  /// Converts the FeatureCollection to a WKT string.
  ///
  /// Example:
  /// ```dart
  /// FeatureCollection([
  ///   Point(Coordinate(1, 2)),
  ///   Point(Coordinate(3, 4))
  /// ]).toWKT(); // GEOMETRYCOLLECTION(POINT(1 2), POINT(3 4))
  /// ```
  String toWKT() {
    return 'GEOMETRYCOLLECTION(${features.map((f) => f.toWKT()).join(',')})';
  }

  /// Converts the FeatureCollection to a GEOJSON FeatureCollection object.
  ///
  /// Example:
  /// ```dart
  /// FeatureCollection([
  ///   Point(Coordinate(1, 2)),
  ///   Point(Coordinate(3, 4))
  /// ]).toJson(); // {'type': 'FeatureCollection', 'features': [{'type': 'Feature', 'geometry': {'type': 'Point', 'coordinates': [1, 2]}, 'properties': {}}, {'type': 'Feature', 'geometry': {'type': 'Point', 'coordinates': [3, 4]}, 'properties': {}}]}
  /// ```
  Map<String, dynamic> toJson() {
    return {
      'type': 'FeatureCollection',
      'features': features.map((f) => f.toJson()).toList(),
    };
  }

  /// Creates a FeatureCollection from a JSON object.
  ///
  /// Example:
  /// ```dart
  /// FeatureCollection.fromJson({'type': 'FeatureCollection', 'features': [{'type': 'Feature', 'geometry': {'type': 'Point', 'coordinates': [1, 2]}, 'properties': {}}, {'type': 'Feature', 'geometry': {'type': 'Point', 'coordinates': [3, 4]}, 'properties': {}}]}); // FeatureCollection([Point(Coordinate(1, 2)), Point(Coordinate(3, 4))])
  /// ```
  factory FeatureCollection.fromJson(Map<String, dynamic> json) {
    if (json['type'] != 'FeatureCollection') {
      throw ArgumentError('json is not a FeatureCollection');
    }

    return FeatureCollection(
      (json['features'] as List<Map<String, dynamic>>)
          .map((Map<String, dynamic> f) {
        if (f['geometry']['type'] == 'Point') {
          return Point.fromJson(f);
        } else if (f['geometry']['type'] == 'MultiPoint') {
          return MultiPoint.fromJson(f);
        } else if (f['geometry']['type'] == 'LineString') {
          return LineString.fromJson(f);
        } else if (f['geometry']['type'] == 'MultiLineString') {
          return MultiLineString.fromJson(f);
        } else if (f['geometry']['type'] == 'Polygon') {
          return Polygon.fromJson(f);
        } else if (f['geometry']['type'] == 'MultiPolygon') {
          return MultiPolygon.fromJson(f);
        } else {
          throw ArgumentError('json is not a feature');
        }
      }).toList(),
    );
  }

  /// Creates a [FeatureCollection] of [Point]s from the geometries of the [Feature]s contained within.
  ///
  /// Example:
  /// ```dart
  /// FeatureCollection([
  ///   LineString([Coordinate(1, 2), Coordinate(3, 4)]),
  ///   LineString([Coordinate(3, 4), Coordinate(5, 6)])
  /// ]).explode(); // FeatureCollection([Point(Coordinate(1, 2)), Point(Coordinate(3, 4)), Point(Coordinate(3, 4)), Point(Coordinate(5, 6))])
  /// ```
  FeatureCollection explode() {
    final explodedFeatures = <Point>[];
    for (final feature in features) {
      explodedFeatures.addAll(feature.explode());
    }
    return FeatureCollection(explodedFeatures);
  }

  /// Gets the center [Point] of the [FeatureCollection].
  /// This is an average of all the [Point]s that create the [Feature]s in the [FeatureCollection].
  ///
  /// Example:
  /// ```dart
  /// FeatureCollection([
  ///   Point(Coordinate(1, 2)),
  ///   Point(Coordinate(5, 6))
  /// ]).center; // Point(4, 5)
  /// ```
  Point get center {
    List<Point> points = (explode().features as List<Point>);

    double lat = 0;
    double long = 0;

    for (final point in points) {
      lat += point.coordinate.latitude;
      long += point.coordinate.longitude;
    }

    return Point.fromLatLong(lat / points.length, long / points.length);
  }

  /// Returns the [BoundingBox] of the [FeatureCollection]
  /// If the [FeatureCollection] is empty, returns a [BoundingBox.empty]
  ///
  /// Example:
  /// ```dart
  /// FeatureCollection([
  ///   LineString([Coordinate(1, 2), Coordinate(3, 4)]),
  ///   LineString([Coordinate(5, 6), Coordinate(7, 8)])
  /// ]).bbox; // BoundingBox(1, 2, 7, 8)
  /// ```
  BoundingBox get bbox {
    if (features.isEmpty) {
      return BoundingBox.empty();
    }

    List<Point> points = (explode().features as List<Point>);
    return BoundingBox.fromPoints(points);
  }

  /// Returns the [BoundingBox]'s [Polygon] of the [FeatureCollection].
  /// If the [FeatureCollection] is empty, returns a `Polygon([])`.
  ///
  /// Example:
  /// ```dart
  /// FeatureCollection([
  ///   LineString([Coordinate(1, 2), Coordinate(3, 4)]),
  ///   LineString([Coordinate(5, 6), Coordinate(7, 8)])
  /// ]).envelope;
  /// ```
  Polygon get envelope {
    if (features.isEmpty) {
      return Polygon([]);
    }

    List<Point> points = (explode().features as List<Point>);
    return BoundingBox.fromPoints(points).toPolygon();
  }

  /// Returns if the [FeatureCollection] is empty.
  ///
  /// Example:
  /// ```dart
  /// FeatureCollection([
  ///   LineString([Coordinate(1, 2), Coordinate(3, 4)])
  /// ]).isEmpty; // false
  /// FeatureCollection([]).isEmpty; // true
  /// ```
  bool get isEmpty => features.isEmpty;

  /// Returns whether all the [Feature]s in the [FeatureCollection] are of the specified [type].
  /// If the [FeatureCollection] is empty, returns false.
  /// If the [type] is not a valid geometry type, returns false.
  ///
  /// Example:
  /// ```dart
  /// FeatureCollection([
  bool isCollectionOf(String type) {
    if (![
      Point.type,
      MultiPoint.type,
      LineString.type,
      MultiLineString.type,
      Polygon.type,
      MultiPolygon.type
    ].contains(type)) {
      return false;
    } else if (isEmpty) {
      return false;
    }

    switch (type) {
      case 'Point':
        return features.every((f) => f is Point);
      case 'MultiPoint':
        return features.every((f) => f is MultiPoint);
      case 'LineString':
        return features.every((f) => f is LineString);
      case 'MultiLineString':
        return features.every((f) => f is MultiLineString);
      case 'Polygon':
        return features.every((f) => f is Polygon);
      case 'MultiPolygon':
        return features.every((f) => f is MultiPolygon);
      default:
        return false;
    }
  }

  /// Returns the [Point] with minimum distance between the [FeatureCollection] and the [point].
  /// If the [FeatureCollection] is empty, returns an empty [FeatureCollection].
  ///
  /// Example:
  /// ```dart
  /// FeatureCollection([
  ///   Point([Coordinate(1, 2)]),
  ///   Point([Coordinate(5, 6)])
  /// ]).nearest(Point([Coordinate(0, 0)])); // Point(1, 2)
  /// FeatureCollection([]).nearest(Point([Coordinate(0, 0)])); // null
  /// FeatureCollection([
  ///  LineString([Coordinate(1, 2), Coordinate(3, 4)]),
  /// ```
  Point? nearestPointTo(Point point) {
    if (isEmpty) {
      return null;
    } else if (!isCollectionOf(Point.type)) {
      return null;
    }

    double minDistance = double.infinity;
    Point nearestPoint = features[0] as Point;

    for (final feature in (features as List<Point>)) {
      final distance = feature.coordinate.distanceTo(point.coordinate);
      if (distance < minDistance) {
        minDistance = distance;
        nearestPoint = feature;
      }
    }

    return nearestPoint;
  }

  /// Returns the addition of the current [FeatureCollection] and the [other], which is a [Feature], a [List] of [Feature]s, or [FeatureCollection].
  /// If the [other] is a [Feature], it is added to the [FeatureCollection].
  /// If the [other] is a [FeatureCollection], it is added to the [FeatureCollection].
  /// If the [other] is not a [Feature] or [FeatureCollection], it throws an [ArgumentError].
  ///
  /// Example:
  /// ```dart
  /// FeatureCollection([
  ///   Point(Coordinate(1, 2)),
  ///   Point(Coordinate(5, 6))
  /// ]) + Point(Coordinate(7, 8)); // FeatureCollection([Point(1, 2), Point(5, 6), Point(7, 8)])
  ///
  /// FeatureCollection([
  ///   Point(Coordinate(1, 2)),
  ///   Point(Coordinate(5, 6))
  /// ]) + FeatureCollection([Point(7, 8)]); // FeatureCollection([Point(1, 2), Point(5, 6), Point(7, 8)])
  ///
  /// FeatureCollection([
  ///   Point(Coordinate(1, 2)),
  ///   Point(Coordinate(5, 6))
  /// ]) + LineString([Coordinate(7, 8), Coordinate(9, 10)]); // FeatureCollection([Point(1, 2), Point(5, 6), LineString([Coordinate(7, 8), Coordinate(9, 10)])])
  ///
  /// FeatureCollection([
  ///  Point(Coordinate(1, 2)),
  /// Point(Coordinate(5, 6))
  /// ]) + MultiPoint([Coordinate(7, 8)]); // FeatureCollection([Point(1, 2), Point(5, 6), MultiPoint([Coordinate(7, 8)])])
  ///
  /// FeatureCollection([
  ///   Point(Coordinate(1, 2)),
  ///   Point(Coordinate(5, 6))
  /// ]) + 5; // throws ArgumentError
  /// ```
  FeatureCollection operator +(dynamic other) {
    if (other is FeatureCollection) {
      return FeatureCollection(features + other.features);
    } else if (other is Feature) {
      return FeatureCollection(features + [other]);
    } else if (other is List<Feature>) {
      return FeatureCollection(features + other);
    } else {
      throw ArgumentError('Unsupported type: ${other.runtimeType}');
    }
  }
}
