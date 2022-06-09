import 'package:geodart/geometries.dart';
import 'package:geodart/measurements.dart';
import 'package:test/test.dart';

void main() {
  group("area tests", () {
    test("area of a polygon", () {
      Polygon polygon = Polygon([
        LinearRing([
          Coordinate(1, 2),
          Coordinate(3, 4),
          Coordinate(5, 6),
          Coordinate(1, 2)
        ])
      ]);
      expect(area(polygon), 74318205388.36292);
    });

    test("area of a multipolygon", () {
      MultiPolygon multiPolygon = MultiPolygon([
        [
          LinearRing([
            Coordinate(1, 2),
            Coordinate(3, 4),
            Coordinate(5, 6),
            Coordinate(1, 2)
          ])
        ],
        [
          LinearRing([
            Coordinate(1, 2),
            Coordinate(3, 4),
            Coordinate(5, 6),
            Coordinate(1, 2)
          ])
        ]
      ]);
      expect(area(multiPolygon), 148636410776.72583);
    });

    test("area of a polygon with holes", () {
      Polygon polygon = Polygon([
        LinearRing([
          Coordinate(1, 2),
          Coordinate(3, 4),
          Coordinate(5, 6),
          Coordinate(1, 2)
        ]),
        LinearRing([
          Coordinate(1, 2),
          Coordinate(3, 4),
          Coordinate(5, 6),
          Coordinate(1, 2)
        ])
      ]);
      expect(area(polygon), 0);
    });

    test("area of a line should fail", () {
      try {
        LineString line = LineString([
          Coordinate(1, 2),
          Coordinate(3, 4),
          Coordinate(5, 6),
          Coordinate(1, 2)
        ]);
        area(line);
      } catch (err) {
        expect(err.toString(),
            "Invalid argument(s): Feature must be a Polygon or MultiPolygon");
      }
    });
  });
}
