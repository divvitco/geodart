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

    test("intersections - simple", () {
      LineString line1 = LineString([Coordinate(1, 2), Coordinate(3, 4)]);
      LineString line2 = LineString([Coordinate(2, 2), Coordinate(4, 4)]);

      expect(line1.intersections(line2).features.length, 0);

      LineString line3 = LineString([Coordinate(1, 1), Coordinate(3, 3)]);
      LineString line4 = LineString([Coordinate(1, 3), Coordinate(3, 1)]);
      expect(line3.intersections(line4).features, [Point(Coordinate(2, 2))]);
    });

    test("intersections - decimals", () {
      LineString line1 = LineString.fromJson({
        "type": "Feature",
        "geometry": {
          "type": "LineString",
          "coordinates": [
            [6.416596657291507, 51.679727882292354],
            [6.435167699648048, 51.6707707876628]
          ]
        },
        "properties": {}
      });
      LineString line2 = LineString.fromJson({
        "type": "Feature",
        "geometry": {
          "type": "LineString",
          "coordinates": [
            [6.416617349164341, 51.67972214627187],
            [6.4071551961115745, 51.664153797567536]
          ]
        },
        "properties": {}
      });

      expect(line1.intersections(line2).features.length, 1);
    });

    test("intersections - complex", () {
      LineString line1 = LineString.fromJson({
        "type": "Feature",
        "properties": {},
        "geometry": {
          "coordinates": [
            [6.296572596843504, 51.7325811130674],
            [6.331468651390992, 51.712025343003575],
            [6.339382748143407, 51.7102129542283],
            [6.362602756171839, 51.70573600531736],
            [6.376359910921593, 51.698489083139606],
            [6.3797989059639235, 51.697743051348],
            [6.384957425902371, 51.6941191969093],
            [6.388224666178672, 51.69166785643759],
            [6.416596657291507, 51.679727882292354],
            [6.435167699648048, 51.6707707876628]
          ],
          "type": "LineString"
        }
      });
      LineString line2 = LineString.fromJson({
        "type": "Feature",
        "properties": {},
        "geometry": {
          "coordinates": [
            [6.319292233742146, 51.68612595532974],
            [6.336336178541103, 51.67900529039221],
            [6.37603045269816, 51.69859284173461],
            [6.4087075284441255, 51.70541424912682],
            [6.426250901758067, 51.684199715280386],
            [6.416617349164341, 51.67972214627187],
            [6.4071551961115745, 51.664153797567536]
          ],
          "type": "LineString"
        }
      });

      expect(line1.intersections(line2).features.length, 2);
    });

    test("intersections - lat/lng ordering", () {
      // Create two lines that intersect at a known point
      // First line goes from (lat=1, lng=0) to (lat=3, lng=2)
      // Second line goes from (lat=1, lng=2) to (lat=3, lng=0)
      // They should intersect at (lat=2, lng=1)
      LineString line1 = LineString([
        Coordinate(1, 0),
        Coordinate(3, 2),
      ]);
      LineString line2 = LineString([
        Coordinate(1, 2),
        Coordinate(3, 0),
      ]);

      var intersections = line1.intersections(line2);
      expect(intersections.features.length, 1);

      var intersection = intersections.features.first as Point;
      expect(intersection.coordinate.latitude,
          closeTo(2, 0.0001)); // Should be lat=2
      expect(intersection.coordinate.longitude,
          closeTo(1, 0.0001)); // Should be lng=1
    });
  });
}
