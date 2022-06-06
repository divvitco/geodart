import 'package:geodart/src/featureTypes/geometries/coordinate.dart';
import 'package:geodart/src/featureTypes/feature.dart';
import 'package:geodart/src/featureTypes/geometries/linear_ring.dart';

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
}
