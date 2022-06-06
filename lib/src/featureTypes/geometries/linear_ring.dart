import 'package:geodart/src/featureTypes/geometries/coordinate.dart';

/// A [LinearRing] is a closed series of [Coordinate]s. It is used in Polygons and MultiPolygons.
/// Closed means the first and last [Coordinate]s are the same.
class LinearRing {
  List<Coordinate> coordinates;
  LinearRing(this.coordinates);
}
