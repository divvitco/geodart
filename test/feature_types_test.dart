import 'package:geodart/features.dart';
import 'package:test/test.dart';

void main() {
  group('polygon.dart', () {
    setUp(() {
      // Additional setup goes here.
    });

    test('Area Test', () {
      Map<String, dynamic> geojson = {
        "type": "Feature",
        "properties": {},
        "geometry": {
          "type": "Polygon",
          "coordinates": [
            [
              [-88.92333984375, 36.09349937380574],
              [-87.86865234374999, 36.09349937380574],
              [-87.86865234374999, 36.87742358748459],
              [-88.92333984375, 36.87742358748459],
              [-88.92333984375, 36.09349937380574]
            ]
          ]
        }
      };
      Polygon feature = Polygon.fromJson(geojson);
      expect(feature.area, 220572482709.00787);
    });

    test("Invalid geojson", () {
      try {
        Map<String, dynamic> geojson = {
          "type": "Feature",
          "properties": {},
          "geometry": {
            "type": "MultiPolygon",
            "coordinates": [
              [
                [-88.92333984375, 36.09349937380574],
                [-87.86865234374999, 36.09349937380574],
                [-87.86865234374999, 36.87742358748459],
                [-88.92333984375, 36.87742358748459],
                [-88.92333984375, 36.09349937380574]
              ]
            ]
          }
        };
        Polygon.fromJson(geojson);
      } catch (err) {
        expect(err.toString(), "Invalid argument(s): json is not a Polygon");
      }
    });
  });

  group('multi_polygon.dart', () {
    test("Area Test", () {
      Map<String, dynamic> geojson = {
        "type": "Feature",
        "properties": {},
        "geometry": {
          "type": "MultiPolygon",
          "coordinates": [
            [
              [
                [-88.92333984375, 36.09349937380574],
                [-87.86865234374999, 36.09349937380574],
                [-87.86865234374999, 36.87742358748459],
                [-88.92333984375, 36.87742358748459],
                [-88.92333984375, 36.09349937380574]
              ]
            ],
            [
              [
                [-88.92333984375, 36.09349937380574],
                [-87.86865234374999, 36.09349937380574],
                [-87.86865234374999, 36.87742358748459],
                [-88.92333984375, 36.87742358748459],
                [-88.92333984375, 36.09349937380574]
              ]
            ]
          ]
        }
      };
      MultiPolygon feature = MultiPolygon.fromJson(geojson);
      expect(feature.area, 441144965418.01575);
    });

    test("invalid geojson", () {
      Map<String, dynamic> geojson = {
        "type": "Feature",
        "properties": {},
        "geometry": {
          "type": "Point",
          "coordinates": [0, 1]
        }
      };
      try {
        MultiPolygon.fromJson(geojson);
      } catch (err) {
        expect(
            err.toString(), "Invalid argument(s): json is not a MultiPolygon");
      }
    });
  });

  group('point.dart', () {
    setUp(() {
      // Additional setup goes here.
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
  });

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
  });
}
