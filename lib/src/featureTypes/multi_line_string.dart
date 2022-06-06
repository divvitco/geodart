import 'package:geodart/src/featureTypes/geometries/coordinate.dart';
import 'package:geodart/src/featureTypes/feature.dart';

/// A [MultiLineString] is a [Feature] made up of a [List] of [LineString] [Coordinate]s.
class MultiLineString extends Feature {
  List<List<Coordinate>> coordinates;
  static final String type = 'MultiLineString';

  MultiLineString(this.coordinates, {properties = const {}})
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

  /// Returns a GeoJSON representation of the [MultiLineString]
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

  /// Creates a [MultiLineString] from a valid GeoJSON object
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

  /// Creates a [MultiLineString] from a WKT [String]
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
}
