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
  String toWKT() {
    return 'GEOMETRYCOLLECTION(${features.map((f) => f.toWKT()).join(',')})';
  }

  /// Converts the FeatureCollection to a GEOJSON FeatureCollection object.
  Map<String, dynamic> toJson() {
    return {
      'type': 'FeatureCollection',
      'features': features.map((f) => f.toJson()).toList(),
    };
  }

  /// Creates a FeatureCollection from a JSON object.
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
  ///   Point([Coordinate(1, 2), Coordinate(3, 4)]),
  ///   Point([Coordinate(5, 6), Coordinate(7, 8)])
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
}
