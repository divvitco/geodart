import 'package:geodart/features.dart';
import 'package:geodart/measure.dart';
import 'package:test/test.dart';

void main() {
  group("Bearing test", () {
    test("bearing between two points", () {
      expect(bearing(Point(Coordinate(0, 0)), Point(Coordinate(0, 1))), 90);
      expect(bearing(Point(Coordinate(0, 0)), Point(Coordinate(1, 1))),
          44.99563645534488); // returns ~45 (stupid earth curvature)
      expect(bearing(Point(Coordinate(0, 0)), Point(Coordinate(1, 0))), 0);
    });
  });
}
