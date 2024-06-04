import 'package:geodart/geometries.dart';
import 'package:test/test.dart';

void main() {
  group("polygon.dart", () {
    test("Polygon from wkt (no holes)", () {
      final String originalWkt =
          'POLYGON ((30.0 10.0, 40.0 40.0, 20.0 40.0, 10.0 20.0, 30.0 10.0))';

      final Polygon polygon = Polygon.fromWKT(originalWkt);
      expect(polygon.coordinates.length, 1); // No holes

      expect(polygon.toWKT(), originalWkt);
    });

    test("Polygon from wkt (with holes)", () {
      final String originalWkt =
          'POLYGON ((30.0 10.0, 40.0 40.0, 20.0 40.0, 10.0 20.0, 30.0 10.0), (20.0 30.0, 35.0 35.0, 30.0 20.0, 20.0 30.0))';

      final Polygon polygon = Polygon.fromWKT(originalWkt);
      expect(polygon.coordinates.length, 2); // 1 hole

      expect(polygon.toWKT(), originalWkt);
    });
  });
}
