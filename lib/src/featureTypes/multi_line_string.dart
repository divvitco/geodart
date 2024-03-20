import 'package:geodart/geometries.dart';

/// A [MultiLineString] is a [Feature] made up of a [List] of [LineString] [Coordinate]s.
class MultiLineString extends Feature {
  List<List<Coordinate>> coordinates;
  static final String type = 'MultiLineString';

  MultiLineString(this.coordinates,
      {super.properties = const <String, dynamic>{}});

  @override
  String toString() {
    return coordinates.map((c) => c.toString()).toList().join(',');
  }

  /// Converts the [MultiLineString] to a [String] in WKT format.
  ///
  /// Example:
  /// ```dart
  /// MultiLineString([[Coordinate(1, 2), Coordinate(3, 4)]]).toWKT(); // MULTILINESTRING((1 2, 3 4))
  /// ```
  @override
  String toWKT() {
    return 'MULTILINESTRING(${coordinates.map((line) => "(${line.map((point) => point.toWKT()).toList().join(',')})").join(',')})';
  }

  /// Returns a GeoJSON representation of the [MultiLineString].
  ///
  /// Example:
  /// ```dart
  /// MultiLineString([[Coordinate(1, 2), Coordinate(3, 4)]]).toJson(); // {'type': 'Feature', 'geometry': {'type': 'MultiLineString', 'coordinates': [[[1, 2], [3, 4]]]}, 'properties': {}}
  /// ```
  @override
  Map<String, dynamic> toJson() {
    return {
      'type': 'Feature',
      'geometry': {
        'type': 'MultiLineString',
        'coordinates': coordinates
            .map((line) => line.map((point) => point.toJson()).toList())
            .toList()
      },
      'properties': properties,
    };
  }

  /// Creates a [MultiLineString] from a valid GeoJSON object.
  ///
  /// Example:
  /// ```dart
  /// MultiLineString.fromJson({'type': 'Feature', 'geometry': {'type': 'MultiLineString', 'coordinates': [[[1, 2], [3, 4]]]}, 'properties': {}}); // MultiLineString([[Coordinate(1, 2), Coordinate(3, 4)]])
  /// ```
  @override
  factory MultiLineString.fromJson(Map<String, dynamic> json) {
    if (json['geometry']['type'] != 'MultiLineString') {
      throw ArgumentError('json is not a MultiLineString');
    }

    dynamic coordinatesData = json['geometry']['coordinates'];
    if (coordinatesData is List<List<dynamic>>) {
      List<List<Coordinate>> coordinatesList = coordinatesData
          .map((line) =>
              line.map((point) => Coordinate.fromJson(point)).toList())
          .toList();
      return MultiLineString(coordinatesList,
          properties: Map<String, dynamic>.from(json['properties']));
    } else {
      throw ArgumentError('json is not a MultiLineString');
    }
  }

  /// Creates a [MultiLineString] from a WKT [String].
  ///
  /// Example:
  /// ```dart
  /// MultiLineString.fromWKT('MULTILINESTRING((1 2, 3 4))'); // MultiLineString([[Coordinate(1, 2), Coordinate(3, 4)]])
  /// ```
  @override
  factory MultiLineString.fromWKT(String wkt) {
    if (!wkt.startsWith('MULTILINESTRING')) {
      throw ArgumentError('wkt is not a MultiLineString');
    }
    final wktLines = wkt.split('((')[1].split('))')[0].split('),(');
    return MultiLineString(
      wktLines
          .map((line) => line.split(','))
          .map(
              (line) => line.map((point) => Coordinate.fromWKT(point)).toList())
          .toList(),
    );
  }

  /// Creates a random [MultiLineString] with a given number of lines ([count]) and length of each line ([length]).
  /// The [length] is the number of points in each line (must be 2 or more).
  /// The [count] is the number of lines in the [MultiLineString] (must be one or more).
  ///
  /// Example:
  /// ```dart
  /// MultiLineString.random(); // MultiLineString([[Coordinate(1, 2), Coordinate(3, 4)]])
  /// MultiLineString.random(count: 2, length: 3); // MultiLineString([[Coordinate(1, 2), Coordinate(3, 4), Coordinate(5, 6), Coordinate(7, 8)], [Coordinate(9, 10), Coordinate(11, 12), Coordinate(13, 14), Coordinate(15, 16)]])
  /// ```
  factory MultiLineString.random({int count = 1, int length = 2}) {
    if (count < 1) {
      throw ArgumentError('count must be 1 or more');
    }
    List<List<Coordinate>> coordinates = [];
    for (var i = 0; i < count; i++) {
      coordinates.add(LineString.random(length: length).coordinates);
    }
    return MultiLineString(coordinates);
  }

  /// Explodes the [MultiLineString] into a [List] of [Point]s.
  ///
  /// Example:
  /// ```dart
  /// MultiLineString([[Coordinate(1, 2), Coordinate(3, 4)]]).explode(); // [Coordinate(1, 2), Coordinate(3, 4)]
  /// ```
  @override
  List<Point> explode() {
    final explodedFeatures = <Point>[];
    for (final line in coordinates) {
      explodedFeatures.addAll(line.map((coord) => Point(coord)).toList());
    }
    return explodedFeatures;
  }

  /// Returns the center [Point] of the [MultiLineString].
  ///
  /// Example:
  /// ```dart
  /// MultiLineString([[Coordinate(1, 2), Coordinate(3, 4)]]).centroid(); // Coordinate(2, 3)
  /// ```
  @override
  Point get center {
    List<Point> points = explode();
    double lat = 0;
    double long = 0;

    for (final point in points) {
      lat += point.coordinate.latitude;
      long += point.coordinate.longitude;
    }

    return Point.fromLatLong(lat / points.length, long / points.length);
  }

  /// Returns the [BoundingBox] of the [MultiLineString]
  ///
  /// Example:
  /// ```dart
  /// MultiLineString([[Coordinate(1, 2), Coordinate(3, 4)]]).bbox; // BoundingBox(1, 2, 3, 4)
  /// ```
  @override
  BoundingBox get bbox {
    List<Point> points = explode();
    return BoundingBox.fromPoints(points);
  }

  /// Flattens the [MultiLineString] into a [FeatureCollection] of [LineString]s.
  /// Properties are inherited from the [MultiLineString].
  ///
  /// Example:
  /// ```dart
  /// MultiLineString([[Coordinate(1, 2), Coordinate(3, 4)]]).flatten(); // FeatureCollection([LineString([Coordinate(1, 2), Coordinate(3, 4)])])
  /// ```
  FeatureCollection flatten() {
    return FeatureCollection(coordinates
        .map((line) => LineString(line, properties: properties))
        .toList());
  }

  /// Returns a [MultiLineString] that is the union of this [MultiLineString] and another [MultiLineString].
  /// The resulting [MultiLineString] will have the same [properties] as this [MultiLineString].
  ///
  /// Example:
  /// ```dart
  /// MultiLineString([[Coordinate(1, 2), Coordinate(3, 4)]]).union(MultiLineString([[Coordinate(4, 5), Coordinate(6, 7)]])); // MultiLineString([[Coordinate(1, 2), Coordinate(3, 4), Coordinate(4, 5), Coordinate(6, 7)]])
  /// ```
  MultiLineString union(MultiLineString other) {
    return MultiLineString([
      ...coordinates,
      ...other.coordinates,
    ], properties: properties);
  }

  /// Returns the total distance of the [MultiLineString] in meters.
  /// This is the sum of the distances of each [LineString] in the [MultiLineString].
  /// The distance is calculated using the [Haversine formula](https://en.wikipedia.org/wiki/Haversine_formula).
  ///
  /// Example:
  /// ```dart
  /// MultiLineString([[Coordinate(1, 2), Coordinate(3, 4)]]).distance(); // 314283.2550736839
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

    return coordinates.fold(0.0, (a, b) => a + getLength(b));
  }
}
