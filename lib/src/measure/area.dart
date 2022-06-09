import 'package:geodart/geometries.dart';

/// Calculates the [area] of a [Polygon] or [MultiPolygon], in square meters.
/// Also accessible from [Polygon.area] and [MultiPolygon.area].
/// The area is calculated using the [Shoelace formula]().
///
/// Example:
/// ```dart
/// area(Polygon([
///  LinearRing([Coordinate(1, 2), Coordinate(3, 4), Coordinate(5, 6), Coordinate(1, 2)])
/// ])); // 12.5
double area(Feature poly) {
  if (poly is Polygon) {
    return poly.area;
  } else if (poly is MultiPolygon) {
    return poly.area;
  } else {
    throw ArgumentError('Feature must be a Polygon or MultiPolygon');
  }
}
