import 'package:geodart/src/featureTypes/feature.dart';
import 'package:geodart/src/featureTypes/line_string.dart';
import 'package:geodart/src/featureTypes/multi_line_string.dart';
import 'package:geodart/src/featureTypes/multi_point.dart';
import 'package:geodart/src/featureTypes/multi_polygon.dart';
import 'package:geodart/src/featureTypes/point.dart';
import 'package:geodart/src/featureTypes/polygon.dart';

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
}
