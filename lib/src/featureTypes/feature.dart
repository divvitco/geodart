import 'package:geodart/geometries.dart';

/// The base class for all feature types.
abstract class Feature {
  Map<String, dynamic> properties;

  Feature({this.properties = const <String, dynamic>{}});

  @override
  String toString();

  /// Converts the [Feature] to a WKT [String].
  String toWKT();

  /// Converts the [Feature] to a JSON object.
  Map<String, dynamic> toJson();

  /// Creates a [Feature] from a JSON object.
  factory Feature.fromJson(Map<String, dynamic> json) {
    throw UnimplementedError();
  }

  /// Creates a [Feature] from a WKT [String].
  factory Feature.fromWKT(String wkt) {
    throw UnimplementedError();
  }

  /// Explodes the [Feature] into a list of [Point]s.
  List<Point> explode();
}
