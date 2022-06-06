import 'package:geodart/features.dart';

/// a [MultiPoint] is a collection of [Coordinate]s that share properties.
class MultiPoint extends Feature {
  List<Coordinate> coordinates;
  static final String type = 'MultiPoint';

  MultiPoint(this.coordinates, {properties = const {}})
      : super(properties: properties);

  @override
  String toString() {
    return coordinates.map((c) => c.toString()).toList().join(',');
  }

  /// Converts the [MultiPoint] to a WKT [String].
  @override
  String toWKT() {
    return 'MULTIPOINT(${coordinates.map((c) => c.toWKT()).join(',')})';
  }

  /// Converts the [MultiPoint] to a GeoJSON [Map].
  @override
  Map<String, dynamic> toJson() {
    return {
      'type': 'Feature',
      'geometry': {
        'type': 'MultiPoint',
        'coordinates': coordinates.map((c) => c.toJson()).toList()
      },
      'properties': properties,
    };
  }

  /// Creates a [MultiPoint] from a valid GeoJSON [Map].
  @override
  factory MultiPoint.fromJson(Map<String, dynamic> json) {
    if (json['geometry']['type'] != 'MultiPoint') {
      throw ArgumentError('json is not a MultiPoint');
    }

    return MultiPoint(
      json['geometry']['coordinates']
          .map((c) => Coordinate(c[1], c[0]))
          .toList(),
      properties: json['properties'],
    );
  }

  /// Creates a [MultiPoint] from a WKT [String].
  @override
  factory MultiPoint.fromWKT(String wkt) {
    final coordinates = wkt.split('(')[1].split(')')[0].split(',');
    return MultiPoint(
      coordinates.map((c) => Coordinate.fromWKT(c)).toList(),
    );
  }

  /// Explodes the [MultiPoint] into a [List] of [Point]s.
  @override
  List<Point> explode() {
    return coordinates.map((c) => Point(c)).toList();
  }

  /// Flattens the [MultiPoint] into a [FeatureCollection] of [Point]s.
  /// Properties of the [MultiPoint] are copied to the [Point]s.
  FeatureCollection flatten() {
    return FeatureCollection(
      coordinates.map((c) => Point(c, properties: properties)).toList(),
    );
  }

  /// Returns a [MultiPoint] that is the union of this [MultiPoint] and another [MultiPoint].
  /// The resulting [MultiPoint] will have the same [properties] as this [MultiPoint].
  MultiPoint union(MultiPoint other) {
    return MultiPoint([
      ...coordinates,
      ...other.coordinates,
    ], properties: properties);
  }
}
