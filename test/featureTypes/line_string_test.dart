import 'package:geodart/geometries.dart';
import 'package:test/test.dart';

void main() {
  group("line_string.dart", () {
    test("Line length test", () {
      LineString line = LineString.fromWKT('LINESTRING(1 2, 3 4)');
      expect(line.length, 314283.2550736839);
    });

    test("Line isClosed test", () {
      LineString line1 = LineString([
        Coordinate(1, 2),
        Coordinate(3, 4),
        Coordinate(1, 4),
        Coordinate(1, 2)
      ]); // true
      LineString line2 = LineString(
          [Coordinate(1, 2), Coordinate(3, 4), Coordinate(1, 4)]); // false

      expect(line1.isClosedRing, true);
      expect(line2.isClosedRing, false);
    });

    test("midpoint", () {
      LineString line = LineString([Coordinate(1, 2), Coordinate(3, 4)]);
      expect(line.midpoint().coordinate,
          Coordinate(2.0003044085023722, 2.999390393801055));
    });

    test("intersections", () {
      LineString line1 = LineString([Coordinate(1, 2), Coordinate(3, 4)]);
      LineString line2 = LineString([Coordinate(2, 2), Coordinate(4, 4)]);

      expect(line1.intersections(line2).features.length, 0);

      LineString line3 = LineString([Coordinate(1, 1), Coordinate(3, 3)]);
      LineString line4 = LineString([Coordinate(1, 3), Coordinate(3, 1)]);
      expect(line3.intersections(line4).features, [Point(Coordinate(2, 2))]);
    });
  });
}
