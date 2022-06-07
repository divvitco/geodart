import 'package:geodart/features.dart';

/// A [MultiLineString] is a [Feature] made up of a [List] of [LineString] [Coordinate]s.
class MultiLineString extends Feature {
  List<List<Coordinate>> coordinates;
  static final String type = 'MultiLineString';

  MultiLineString(this.coordinates, {properties = const <String, dynamic>{}})
      : super(properties: properties);

  @override
  String toString() {
    return coordinates.map((c) => c.toString()).toList().join(',');
  }

  /// Converts the [MultiLineString] to a [String] in WKT format.
  @override
  String toWKT() {
    return 'MULTILINESTRING(${coordinates.map((line) => "(${line.map((point) => point.toWKT()).toList().join(',')})").join(',')})';
  }

  /// Returns a GeoJSON representation of the [MultiLineString].
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
  @override
  factory MultiLineString.fromJson(Map<String, dynamic> json) {
    if (json['geometry']['type'] != 'MultiLineString') {
      throw ArgumentError('json is not a MultiLineString');
    }

    return MultiLineString(
      json['geometry']['coordinates']
          .map((line) =>
              line.map((point) => Coordinate.fromJson(point)).toList())
          .toList(),
      properties: json['properties'],
    );
  }

  /// Creates a [MultiLineString] from a WKT [String].
  @override
  factory MultiLineString.fromWKT(String wkt) {
    final wktLines = wkt.split('(')[1].split(')')[0].split(',');
    return MultiLineString(
      wktLines
          .map((c) => c.split('('))
          .map((c) => c.map((point) => Coordinate.fromWKT(point)).toList())
          .toList(),
    );
  }

  /// Explodes the [MultiLineString] into a [List] of [Point]s.
  @override
  List<Point> explode() {
    final explodedFeatures = <Point>[];
    for (final line in coordinates) {
      explodedFeatures.addAll(line.map((coord) => Point(coord)).toList());
    }
    return explodedFeatures;
  }

  /// Flattens the [MultiLineString] into a [FeatureCollection] of [LineString]s.
  /// Properties are inherited from the [MultiLineString].
  FeatureCollection flatten() {
    return FeatureCollection(coordinates
        .map((line) => LineString(line, properties: properties))
        .toList());
  }

  /// Returns a [MultiLineString] that is the union of this [MultiLineString] and another [MultiLineString].
  /// The resulting [MultiLineString] will have the same [properties] as this [MultiLineString].
  MultiLineString union(MultiLineString other) {
    return MultiLineString([
      ...coordinates,
      ...other.coordinates,
    ], properties: properties);
  }

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
