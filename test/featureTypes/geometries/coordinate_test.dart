import 'package:geodart/geometries.dart';
import 'package:test/test.dart';

void main() {
  group("coordinate.dart", () {
    test("coordinate equality", () {
      expect(Coordinate(1, 2), Coordinate(1, 2));
      expect(Coordinate(1, 2), isNot(Coordinate(2, 1)));
    });

    test("coordinate toString", () {
      expect(Coordinate(1, 2).toString(),
          'Coordinate{latitude: 1.0, longitude: 2.0}');
    });

    test("coordinate distance", () {
      expect(Coordinate(1, 2).distanceTo(Coordinate(3, 4)), 314402.95102362486);
    });

    test("coordinate bearing", () {
      expect(Coordinate(1, 2).bearingTo(Coordinate(3, 4)), 44.951998353879446);
    });

    test("coordinate bearing to self", () {
      expect(Coordinate(1, 2).bearingTo(Coordinate(1, 2)), 0);
    });

    test("coordinate to and from wkt", () {
      expect(Coordinate.fromWKT('1 2'), Coordinate(2, 1));
      expect(Coordinate(1, 2).toWKT(), '2.0 1.0');
    });

    test("coordinate to and from json", () {
      expect(Coordinate.fromJson([2, 1]), Coordinate(1, 2));
      expect(Coordinate(1, 2).toJson(), [2.0, 1.0]);
    });
  });
}
