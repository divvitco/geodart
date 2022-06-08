import 'package:geodart/features.dart';

/// A [LineString] is a [Feature] made up of connected [Coordinate]s to form a line.
class LineString extends Feature {
  final List<Coordinate> coordinates;
  static final String type = 'LineString';

  LineString(this.coordinates, {properties = const <String, dynamic>{}})
      : super(properties: properties);

  @override
  String toString() {
    return coordinates.map((c) => c.toString()).toList().join(',');
  }

  /// Converts the [LineString] to a [String] in WKT format.
  ///
  /// Example:
  /// ```dart
  /// LineString([Coordinate(1, 2), Coordinate(3, 4)]).toWKT(); // LINESTRING(1 2, 3 4)
  /// ```
  @override
  String toWKT() {
    return 'LINESTRING(${coordinates.map((c) => c.toWKT()).join(',')})';
  }

  /// Returns a GeoJSON representation of the [LineString]
  ///
  /// Example:
  /// ```dart
  /// LineString([Coordinate(1, 2), Coordinate(3, 4)]).toJson(); // {'type': 'Feature', 'geometry': {'type': 'LineString', 'coordinates': [[1, 2], [3, 4]]}, 'properties': {}}
  /// ```
  @override
  Map<String, dynamic> toJson() {
    return {
      'type': 'Feature',
      'geometry': {
        'type': 'LineString',
        'coordinates': coordinates.map((c) => c.toJson()).toList()
      },
      'properties': properties,
    };
  }

  /// Creates a [LineString] from a valid GeoJSON object
  ///
  /// Example:
  /// ```dart
  /// LineString.fromJson({'type': 'Feature', 'geometry': {'type': 'LineString', 'coordinates': [[1, 2], [3, 4]]}, 'properties': {}}); // LineString([Coordinate(1, 2), Coordinate(3, 4)])
  /// ```
  @override
  factory LineString.fromJson(Map<String, dynamic> json) {
    if (json['geometry']['type'] != 'LineString') {
      throw ArgumentError('json is not a LineString');
    }

    return LineString(
      (json['coordinates'] as List<dynamic>)
          .map((dynamic c) => Coordinate.fromJson(c))
          .toList(),
      properties: Map<String, dynamic>.from(json['properties']),
    );
  }

  /// Creates a [LineString] from a WKT string
  ///
  /// Example:
  /// ```dart
  /// LineString.fromWKT('LINESTRING(0 0, 1 2)'); // LineString([Coordinate(0, 0), Coordinate(1, 2)])
  /// ```
  @override
  factory LineString.fromWKT(String wkt) {
    if (!wkt.startsWith('LINESTRING')) {
      throw ArgumentError('wkt is not a LineString');
    }

    final coordinates = wkt.split('(')[1].split(')')[0].split(RegExp(r",\s*"));
    return LineString(
      coordinates.map((c) => Coordinate.fromWKT(c)).toList(),
    );
  }

  /// Explodes the [LineString] into a [List] of [Point]s
  ///
  /// Example:
  /// ```dart
  /// LineString([Coordinate(1, 2), Coordinate(3, 4)]).explode(); // [Coordinate(1, 2), Coordinate(3, 4)]
  /// ```
  @override
  List<Point> explode() {
    return coordinates.map((e) => Point(e)).toList();
  }

  /// If the [LineString] is a closed ring, it will be converted to a [Polygon].
  /// Any [properties] will be applied to the [Polygon].
  ///
  /// Example:
  /// ```dart
  /// LineString([Coordinate(1, 2), Coordinate(3, 4), Coordinate(1, 4), Coordinate(1, 2)]).toPolygon(); // Polygon([Coordinate(1, 2), Coordinate(3, 4), Coordinate(1, 4), Coordinate(1, 2)])
  /// ```
  Polygon toPolygon() {
    if (!isClosedRing) {
      throw ArgumentError('LineString is not a closed ring');
    }

    return Polygon([LinearRing(coordinates)], properties: properties);
  }

  /// Returns the [Point] at the [distance] (in meters) along the [LineString].
  /// If the [distance] is greater than the length of the [LineString],
  /// the last [Point] in the [LineString] will be returned.
  /// If the [distance] is less than 0, the first [Point] in the [LineString] will be returned.
  ///
  /// Example:
  /// ```dart
  /// LineString([Coordinate(1, 2), Coordinate(3, 4)]).along(100); // Point(Coordinate(2, 3))
  /// ```
  Point along(double distance) {
    if (distance <= 0) {
      return Point(coordinates.first);
    } else if (distance >= length) {
      return Point(coordinates.last);
    } else if (coordinates.length < 2) {
      return Point(coordinates.first);
    }

    if (coordinates.length > 2) {
      double distanceLeft = distance;
      for (int i = 0; i < coordinates.length - 1; i++) {
        final c1 = coordinates[i];
        final c2 = coordinates[i + 1];
        final segmentLength = c1.distanceTo(c2);
        if (distanceLeft <= segmentLength) {
          final ratio = distanceLeft / segmentLength;
          return Point(c1.interpolate(c2, ratio));
        } else {
          distanceLeft -= segmentLength;
        }
      }
    }

    final ratio = distance / length;
    return Point(coordinates.first.interpolate(coordinates.last, ratio));
  }

  /// Returns the [LineString]'s length in meters.
  /// The length is calculated using the [Haversine formula](https://en.wikipedia.org/wiki/Haversine_formula).
  ///
  /// Example:
  /// ```dart
  /// LineString([Coordinate(1, 2), Coordinate(3, 4)]).length; // 314283.2550736839
  /// ```
  double get length {
    double getLength(List<Coordinate> coordinates) {
      if (coordinates.length < 2) {
        return 0.0;
      }

      double length = 0.0;
      for (int i = 0; i < coordinates.length - 1; i++) {
        length += coordinates[i].distanceTo(coordinates[i + 1]);
      }
      return length;
    }

    return coordinates.length > 1 ? getLength(coordinates) : 0.0;
  }

  /// Returns true if the [LineString] is a closed ring, meaning that the first and last coordinate are the same.
  ///
  /// Example:
  /// ```dart
  /// LineString([Coordinate(1, 2), Coordinate(3, 4), Coordinate(1, 4), Coordinate(1, 2)]).isClosedRing; // true
  /// LineString([Coordinate(1, 2), Coordinate(3, 4), Coordinate(1, 4)]).isClosedRing; // false
  /// ```
  bool get isClosedRing {
    return coordinates.length >= 4 &&
        coordinates[0] == coordinates[coordinates.length - 1];
  }
}
