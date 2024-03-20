import 'package:geodart/geometries.dart';

/// A [LineString] is a [Feature] made up of connected [Coordinate]s to form a line.
class LineString extends Feature {
  final List<Coordinate> coordinates;
  static final String type = 'LineString';

  LineString(this.coordinates, {super.properties = const <String, dynamic>{}});

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

  /// Creates a [LineString] with random [Coordinate]s with the number of vertices specified [length].
  /// The [length] must be greater than 2, or an [ArgumentError] will be thrown.
  ///
  /// Example:
  /// ```dart
  /// LineString.random(); // LineString([Coordinate(?, ?), Coordinate(?, ?)])
  /// ```
  factory LineString.random({int length = 2}) {
    if (length <= 2) {
      throw ArgumentError('length must be greater than 2');
    }
    List<Coordinate> coordinates = [];
    for (int i = 0; i < length; i++) {
      coordinates.add(Coordinate.random());
    }
    return LineString(coordinates);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LineString &&
          runtimeType == other.runtimeType &&
          coordinates == other.coordinates &&
          properties == other.properties;

  @override
  int get hashCode => coordinates.hashCode ^ properties.hashCode;

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

  /// Returns the center [Point] of the [LineString]
  ///
  /// Example:
  /// ```dart
  /// LineString([Coordinate(1, 2), Coordinate(3, 4)]).center(); // Coordinate(2, 3)
  /// ```
  @override
  Point get center {
    final lat = coordinates.map((c) => c.latitude).reduce((a, b) => a + b) /
        coordinates.length;
    final long = coordinates.map((c) => c.longitude).reduce((a, b) => a + b) /
        coordinates.length;
    return Point.fromLatLong(lat, long);
  }

  /// Returns the [BoundingBox] of the [LineString]
  ///
  /// Example:
  /// ```dart
  /// LineString([Coordinate(1, 2), Coordinate(3, 4)]).bbox; // BoundingBox(1, 2, 3, 4)
  /// ```
  @override
  BoundingBox get bbox {
    List<Point> points = explode();
    return BoundingBox.fromPoints(points);
  }

  /// Returns each segment (a 2-coordinate [LineString]) of the [LineString] in a [FeatureCollection]
  ///
  /// Example:
  /// ```dart
  /// LineString([Coordinate(1, 2), Coordinate(3, 4), Coordinate(5, 6)]).segments; // [LineString([Coordinate(1, 2), Coordinate(3, 4)]), LineString([Coordinate(3, 4), Coordinate(5, 6)])]
  /// ```
  List<LineString> get segments {
    List<LineString> segments = [];
    for (int i = 0; i < coordinates.length - 1; i++) {
      final start = coordinates[i];
      final end = coordinates[i + 1];
      final segment = LineString([start, end]);
      segments.add(segment);
    }
    return segments;
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

  /// Returns the mid[Point] of the [LineString].
  ///
  /// Example:
  /// ```dart
  /// LineString([Coordinate(1, 2), Coordinate(3, 4)]).midpoint(); // Point(Coordinate(2, 3))
  /// ```
  Point midpoint() {
    return along(length / 2);
  }

  /// Returns the [Point] at the [percentage] along the [LineString].
  /// If the [percentage] is greater than 1, the last [Point] in the [LineString] will be returned.
  /// If the [percentage] is less than 0, the first [Point] in the [LineString] will be returned.
  /// If the [percentage] is 0, the first [Point] in the [LineString] will be returned.
  /// If the [percentage] is 1, the last [Point] in the [LineString] will be returned.
  ///
  /// Example:
  /// ```dart
  /// LineString([Coordinate(1, 2), Coordinate(3, 4)]).pointAt(0.5); // Point(Coordinate(2, 3))
  /// ```
  Point pointAt(double percentage) {
    if (percentage <= 0) {
      return Point(coordinates.first);
    } else if (percentage >= 1) {
      return Point(coordinates.last);
    } else if (coordinates.length < 2) {
      return Point(coordinates.first);
    }

    return along(length * percentage);
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

  /// Returns the bearing of the [LineString] in degrees.
  /// The bearing is the angle measured in degrees clockwise from true north
  /// between the first and last coordinate of the [LineString].
  /// If the [LineString] has less than 2 coordinates, 0 will be returned.
  /// The bearing will always be between 0 and 360.
  /// The bearing will be 0 if the [LineString] is a closed ring.
  ///
  /// Example:
  /// ```dart
  /// LineString([Coordinate(1, 2), Coordinate(3, 4)]).bearing; // 45.0
  /// LineString([Coordinate(1, 2), Coordinate(3, 4), Coordinate(1, 4), Coordinate(1, 2)]).bearing; // 0.0
  /// LineString([Coordinate(1, 2), Coordinate(3, 4), Coordinate(1, 4)]).bearing; // 90.0
  /// ```
  double get bearing {
    return coordinates.length == 2
        ? coordinates.first.bearingTo(coordinates.last)
        : 0.0;
  }

  /// Returns a [LineString] that is a copy of the [LineString] with the coordinates reversed.
  /// The first coordinate will become the last, and the last coordinate will become the first.
  /// If the [LineString] is a closed ring, the first and last coordinate will be the same.
  ///
  /// Example:
  /// ```dart
  /// LineString([Coordinate(1, 2), Coordinate(3, 4), Coordinate(1, 4), Coordinate(1, 2)]).reverse(); // LineString([Coordinate(1, 2), Coordinate(1, 4), Coordinate(3, 4), Coordinate(1, 2)])
  /// LineString([Coordinate(1, 2), Coordinate(3, 4), Coordinate(1, 4)]).reverse(); // LineString([Coordinate(1, 4), Coordinate(3, 4), Coordinate(1, 2)])
  /// ```
  LineString reverse() {
    return LineString(coordinates.reversed.toList(), properties: properties);
  }

  /// Returns whether or not the [LineString] is parallel to the [LineString] [other].
  /// If the [LineString]s have different lengths, they are not considered parallel.
  ///
  /// Example:
  /// ```dart
  /// LineString([Coordinate(1, 2), Coordinate(3, 4)]).isParallelTo(LineString([Coordinate(2, 3), Coordinate(4, 5)])); // true
  /// LineString([Coordinate(1, 2), Coordinate(3, 4)]).isParallelTo(LineString([Coordinate(4, 5), Coordinate(2, 3)])); // true
  /// LineString([Coordinate(1, 2), Coordinate(3, 4)]).isParallelTo(LineString([Coordinate(4, 5), Coordinate(2, 6)])); // false
  /// ```
  bool isParallelTo(LineString other) {
    if (coordinates.length != other.coordinates.length) {
      return false;
    } else if (coordinates.length == 2) {
      return bearing == other.bearing;
    } else {
      return segments.every((LineString element) {
        int index = segments.indexOf(element);

        return element.bearing == other.segments[index].bearing ||
            element.bearing == other.reverse().segments[index].bearing;
      });
    }
  }

  /// Returns the slope of the line, using only the first and last coordinate.
  /// If the line is vertical, null is returned
  /// If the line is horizontal, 0 is returned
  ///
  /// Example:
  /// ```dart
  /// LineString([Coordinate(1, 2), Coordinate(3, 4)]).slope; // 1
  /// LineString([Coordinate(1, 2), Coordinate(3, 2)]).slope; // 0
  /// LineString([Coordinate(1, 2), Coordinate(1, 4)]).slope; // null
  /// ```
  double? get slope {
    if (coordinates.first.x == coordinates.last.x) {
      return null;
    }
    return (coordinates.last.y - coordinates.first.y) /
        (coordinates.last.x - coordinates.first.x);
  }

  /// Returns true if the [Point] is on the line
  ///
  /// Example:
  /// ```dart
  /// LineString([Coordinate(1, 2), Coordinate(3, 4)]).contains(Point(Coordinate(2, 3))); // true
  /// LineString([Coordinate(1, 2), Coordinate(3, 4)]).contains(Point(Coordinate(2, 4))); // false
  /// ```
  bool contains(Point point) {
    if (slope == null) {
      // If the line is vertical, check if the x-coordinate of the point is equal to the x-coordinate
      return point.coordinate.x == coordinates.first.x &&
          point.coordinate.y >= coordinates.first.y &&
          point.coordinate.y <= coordinates.last.y;
    } else {
      // Calculate the y-intercept of the line
      final double yIntercept =
          coordinates.first.y - (slope! * coordinates.first.x);

      // Check if the point is on the line by plugging the x-coordinate of the point
      // into the equation of the line and checking if the result is equal to the y-coordinate
      // of the point
      final bool isOnLine =
          (slope! * point.coordinate.x + yIntercept) == point.coordinate.y;
      return isOnLine;
    }
  }

  /// Returns a [FeatureCollection] of [Point]s where the [LineString] intersects with the [LineString] [other].
  /// If the [LineString]s do not intersect, an empty [FeatureCollection] is returned.
  ///
  /// Example:
  /// ```dart
  /// LineString([Coordinate(1, 2), Coordinate(3, 4)]).intersections(LineString([Coordinate(2, 3), Coordinate(4, 5)])); // FeatureCollection([]) - does not intersect
  /// LineString([Coordinate(1, 2), Coordinate(3, 4)]).intersections(LineString([Coordinate(3, 4), Coordinate(1, 2)])); // FeatureCollection([Point()]) - intersects at (2, 3)
  /// ```
  FeatureCollection intersections(LineString other) {
    Point? getIntersection(LineString segment1, LineString segment2) {
      final a1 = segment1.coordinates.first;
      final a2 = segment1.coordinates.last;
      final b1 = segment2.coordinates.first;
      final b2 = segment2.coordinates.last;

      final denominator =
          (a1.y - a2.y) * (b1.x - b2.x) - (a1.x - a2.x) * (b1.y - b2.y);
      if (denominator == 0) {
        return null;
      }

      final x = -1 *
          ((a1.x * a2.y - a1.y * a2.x) * (b1.x - b2.x) -
              (a1.x - a2.x) * (b1.x * b2.y - b1.y * b2.x)) /
          denominator;
      final y = -1 *
          ((a1.x * a2.y - a1.y * a2.x) * (b1.y - b2.y) -
              (a1.y - a2.y) * (b1.x * b2.y - b1.y * b2.x)) /
          denominator;

      final intersection = Point(Coordinate(x, y));
      if (segment1.contains(intersection) && segment2.contains(intersection)) {
        return intersection;
      } else {
        return null;
      }
    }

    FeatureCollection intersections = FeatureCollection([]);

    for (var segment in segments) {
      final FeatureCollection segmentIntersections = FeatureCollection(other
          .segments
          .where(
              (otherSegment) => getIntersection(segment, otherSegment) != null)
          .map((LineString otherSegment) =>
              getIntersection(segment, otherSegment)!)
          .toList());
      intersections.features.addAll(segmentIntersections.features);
    }

    return intersections;
  }
}
