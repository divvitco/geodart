import 'package:geodart/features.dart';

/// Calculates the [area] of a [Polygon] or [MultiPolygon], in square meters.
/// Also accessible from [Polygon.area] and [MultiPolygon.area].
double area(Feature poly) {
  if (poly is Polygon) {
    return poly.area;
  } else if (poly is MultiPolygon) {
    return poly.area;
  } else {
    throw ArgumentError('Feature must be a Polygon or Multipolygon');
  }
}
