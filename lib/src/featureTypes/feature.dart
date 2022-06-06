/// The base class for all feature types.
class Feature {
  Map<String, dynamic> properties;

  Feature({this.properties = const {}});

  @override
  String toString() {
    return 'Feature{properties: $properties}';
  }

  /// Converts the feature to a WKT string.
  /// (Not actually possible, as a base feature has no geometry)
  String toWKT() {
    return 'Feature{properties: $properties}';
  }

  /// Converts the feature to a JSON object.
  /// (Not actually possible, as a base feature has no geometry)
  Map<String, dynamic> toJson() {
    return {
      'type': 'Feature',
      'properties': properties,
    };
  }

  /// Creates a feature from a JSON object.
  /// (Not actually possible, as a base feature has no geometry)
  factory Feature.fromJson(Map<String, dynamic> json) {
    return Feature(
      properties: json['properties'],
    );
  }

  /// Creates a feature from a WKT string.
  /// (Not actually possible, as a base feature has no geometry)
  factory Feature.fromWKT(String wkt) {
    return Feature();
  }
}
