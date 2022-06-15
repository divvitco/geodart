import 'package:geodart/geometries.dart';
import 'package:test/test.dart';

void main() {
  group("point.dart", () {
    test("point equality", () {
      Point point1 = Point(Coordinate(1, 2));
      Point point2 = Point(Coordinate(1, 2));
      expect(point1, point2);
    });

    test("point equality with different coordinates", () {
      Point point1 = Point(Coordinate(1, 2));
      Point point2 = Point(Coordinate(2, 1));
      expect(point1, isNot(point2));
    });

    test("point equality with different types", () {
      Point point = Point(Coordinate(1, 2));
      LineString line = LineString([Coordinate(1, 2), Coordinate(3, 4)]);
      expect(point, isNot(line));
    });

    test("point to and from wkt", () {
      String wkt = 'POINT(1.0 2.0)';
      Point point = Point.fromWKT(wkt);
      expect(point.toWKT(), wkt);
    });

    test('Create fromJson() test', () {
      Map<String, dynamic> geojson = {
        "type": "Feature",
        "properties": {},
        "geometry": {
          "type": "Point",
          "coordinates": [-122.676483, 45.516525]
        }
      };
      Point feature = Point.fromJson(geojson);
      expect(feature.coordinate.latitude, 45.516525);
      Map<String, dynamic> returned = feature.toJson();
      expect(returned['geometry']['coordinates'][0],
          geojson['geometry']['coordinates'][0]);
    });

    test("create from wkt", () {
      String wkt = "POINT(-122.676483 45.516525)";
      Point feature = Point.fromWKT(wkt);
      expect(feature.coordinate.latitude, 45.516525);
      expect(feature.toWKT(), wkt);
    });

    test("point empty geojson", () {
      try {
        Point.fromJson({});
      } catch (e) {
        expect(e.toString(),
            'Invalid argument(s): json does not contain geometry');
      }
    });

    test("point invalid geojson", () {
      try {
        Point.fromJson({
          "type": "Feature",
          "geometry": {"type": "Point", "coordinates": []},
          "properties": {}
        });
      } catch (e) {
        expect(e.toString(),
            'Invalid argument(s): json does not contain coordinates');
      }
    });

    test("point properties get picked up toJson and fromJson", () {
      Point point = Point.fromJson({
        "type": "Feature",
        "geometry": {
          "type": "Point",
          "coordinates": [-122.676483, 45.516525]
        },
        "properties": {"name": "point"}
      });
      expect(point.properties['name'], 'point');
      expect(point.toJson()['properties']['name'], 'point');
    });

    test("Point is within polygon", () {
      Polygon polygon = Polygon([
        LinearRing([
          Coordinate(0, 0),
          Coordinate(0, 1),
          Coordinate(1, 1),
          Coordinate(1, 0),
          Coordinate(0, 0)
        ])
      ]);
      Point point = Point(Coordinate(0.5, 0.5));
      expect(
          LinearRing([
            Coordinate(0, 0),
            Coordinate(0, 1),
            Coordinate(1, 1),
            Coordinate(1, 0),
            Coordinate(0, 0)
          ]).contains(point),
          isTrue);
      expect(polygon.contains(point), isTrue);
      expect(point.isContainedIn(polygon), true);
    });

    test("Point is not within polygon", () {
      Polygon polygon = Polygon([
        LinearRing([
          Coordinate(0, 0),
          Coordinate(0, 1),
          Coordinate(1, 1),
          Coordinate(1, 0),
          Coordinate(0, 0)
        ])
      ]);
      Point point = Point(Coordinate(2, 2));
      expect(
          LinearRing([
            Coordinate(0, 0),
            Coordinate(0, 1),
            Coordinate(1, 1),
            Coordinate(1, 0),
            Coordinate(0, 0)
          ]).contains(point),
          isFalse);
      expect(polygon.contains(point), isFalse);
      expect(point.isContainedIn(polygon), false);
    });
  });
}
