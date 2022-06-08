import 'package:geodart/features.dart';

/// The base class for all feature types.
class Feature {
  Map<String, dynamic> properties;

  Feature({this.properties = const <String, dynamic>{}});

  @override
  String toString() {
    return 'Feature{properties: $properties}';
  }

  /// Converts the [Feature] to a WKT [String].
  /// (Not actually possible, as a base feature has no geometry)
  String toWKT() {
    return 'Feature{properties: $properties}';
  }

  /// Converts the [Feature] to a JSON object.
  /// (Not actually possible, as a base feature has no geometry)
  Map<String, dynamic> toJson() {
    return {
      'type': 'Feature',
      'properties': properties,
    };
  }

  /// Creates a [Feature] from a JSON object.
  /// (Not actually possible, as a base feature has no geometry)
  factory Feature.fromJson(Map<String, dynamic> json) {
    return Feature(
      properties: Map<String, dynamic>.from(json['properties']),
    );
  }

  /// Creates a [Feature] from a WKT [String].
  /// (Not actually possible, as a base feature has no geometry)
  factory Feature.fromWKT(String wkt) {
    return Feature();
  }

  /// Explodes the [Feature] into a list of [Point]s.
  /// (Not actually possible, as a base feature has no geometry)
  List<Point> explode() {
    return [];
  }
}
