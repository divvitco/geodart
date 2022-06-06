import 'package:geodart/src/featureTypes/geometries/coordinate.dart';
import 'package:geodart/src/featureTypes/feature.dart';
import 'package:geodart/src/featureTypes/geometries/linear_ring.dart';

/// A [Polygon] is a single closed path with shared properties.
/// The first [LinearRing] defines the outer boundary of the [Polygon], while the following [LinearRing]s define holes within the [Polygon].
class Polygon extends Feature {
  List<LinearRing> coordinates;
  static final String type = 'Polygon';

  Polygon(this.coordinates, {properties = const {}})
      : super(properties: properties);

  @override
  String toString() {
    return coordinates
        .map((ring) => ring.coordinates.map((c) => c.toString()).toList())
        .toList()
        .join(',');
  }

  /// Converts the [Polygon] to a WKT [String].
  @override
  String toWKT() {
    return 'POLYGON(${coordinates.map((ring) => "(${ring.coordinates.map((c) => c.toWKT()).toList()})").toList().join(',')})';
  }

  /// Returns a GeoJSON [Map] of the [Polygon].
  @override
  Map<String, dynamic> toJson() {
    return {
      'type': 'Feature',
      'geometry': {
        'type': 'Polygon',
        'coordinates': coordinates
            .map((ring) => ring.coordinates.map((c) => c.toJson()).toList())
            .toList()
      },
      'properties': properties,
    };
  }

  /// Creates a [Polygon] from a GeoJSON [Map].
  @override
  factory Polygon.fromJson(Map<String, dynamic> json) {
    if (json['geometry']['type'] != 'Polygon') {
      throw ArgumentError('json is not a Polygon');
    }

    return Polygon(
      (json['geometry']['coordinates'] as List<List<dynamic>>)
          .map((List<dynamic> shape) => LinearRing(
              shape.map((dynamic c) => Coordinate.fromJson(c)).toList()))
          .toList(),
    );
  }

  /// Creates a [Polygon] from a WKT [String].
  /// **Right now, cannot handle polygons with holes**.
  @override
  factory Polygon.fromWKT(String wkt) {
    final coordinates = wkt.split('(')[1].split(')')[0].split(',');
    return Polygon(
        [LinearRing(coordinates.map((c) => Coordinate.fromWKT(c)).toList())]);
  }
}
