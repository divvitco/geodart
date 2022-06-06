import 'package:geodart/features.dart';

/// A [MultiPolygon] is a collection of [Polygon] Geometries with shared properties.
class MultiPolygon extends Feature {
  List<List<LinearRing>> coordinates;
  static final String type = 'MultiPolygon';

  MultiPolygon(this.coordinates, {properties = const {}})
      : super(properties: properties);

  @override
  String toString() {
    return coordinates.map((poly) => poly.toString()).toList().join(',');
  }

  /// Converts the [MultiPolygon] to a WKT [String].
  @override
  String toWKT() {
    return 'MULTIPOLYGON(${coordinates.map((poly) => "(${poly.map((ring) => "(${ring.coordinates.map((c) => c.toWKT()).toList()})").toList()})").join(',')})';
  }

  /// Returns a GeoJSON representation of the [MultiPolygon]
  @override
  Map<String, dynamic> toJson() {
    return {
      'type': 'Feature',
      'geometry': {
        'type': 'MultiPolygon',
        'coordinates': coordinates
            .map((poly) =>
                poly.map((ring) => ring.coordinates.map((c) => c.toJson())))
            .toList()
      },
      'properties': properties,
    };
  }

  /// Creates a [MultiPolygon] from a GeoJSON [Map].
  @override
  factory MultiPolygon.fromJson(Map<String, dynamic> json) {
    if (json['geometry']['type'] != 'MultiPolygon') {
      throw ArgumentError('json is not a MultiPolygon');
    }

    return MultiPolygon(
      (json['geometry']['coordinates'] as List<List<List<double>>>)
          .map((dynamic poly) => (poly as List<List<double>>)
              .map((dynamic shape) => LinearRing((shape as List<double>)
                  .map((dynamic coord) => Coordinate.fromJson(coord))
                  .toList()))
              .toList())
          .toList(),
    );
  }

  /// explode the [MultiPolygon] into a [List] of [Point]s.
  @override
  List<Point> explode() {
    final explodedFeatures = <Point>[];
    for (final poly in coordinates) {
      explodedFeatures.addAll(poly
          .map((ring) => ring.coordinates.map((cord) => Point(cord)).toList())
          .toList()
          .expand((i) => i)
          .toList());
    }
    return explodedFeatures;
  }

  /// Converts the [MultiPolygon] to a WKT a [MultiLineString].
  /// Uses the outer ring of each polygon, all holes are ignored.
  MultiLineString toMultiLineString() {
    return MultiLineString(
        coordinates.map((poly) => poly.first.coordinates).toList());
  }

  /// Breaks the [MultiPolygon] into a [FeatureCollection] containing each [Polygon]s.
  /// Also, copies the [properties] of the [MultiPolygon] to each [Polygon].
  FeatureCollection flatten() {
    return FeatureCollection(coordinates
        .map((poly) => Polygon(poly, properties: properties))
        .toList());
  }
}
