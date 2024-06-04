import 'package:geodart/geometries.dart';
import 'package:test/test.dart';

void main() {
  group("multi_polygon.dart", () {
    test("MultiPolygon from wkt (no holes, one polygon)", () {
      final String originalWkt =
          'MULTIPOLYGON (((30.0 10.0, 40.0 40.0, 20.0 40.0, 10.0 20.0, 30.0 10.0)))';

      final MultiPolygon polygon = MultiPolygon.fromWKT(originalWkt);
      expect(polygon.coordinates.length, 1); // Only 1 polygon

      expect(polygon.toWKT(), originalWkt);
    });

    test("Polygon from wkt (with holes, one polygon)", () {
      final String originalWkt =
          'MULTIPOLYGON (((30.0 10.0, 40.0 40.0, 20.0 40.0, 10.0 20.0, 30.0 10.0), (20.0 30.0, 35.0 35.0, 30.0 20.0, 20.0 30.0)))';

      final MultiPolygon polygon = MultiPolygon.fromWKT(originalWkt);
      expect(polygon.coordinates.length, 1); // Only 1 polygon

      expect(polygon.toWKT(), originalWkt);
    });
  });
}

// MULTIPOLYGON (((30 20, 45 40, 10 40, 30 20)), ((15 5, 40 10, 10 20, 5 10, 15 5)))
// MULTIPOLYGON (((40 40, 20 45, 45 30, 40 40)), ((20 35, 10 30, 10 10, 30 5, 45 20, 20 35), (30 20, 20 15, 20 25, 30 20)))
