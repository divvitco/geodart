import 'package:geodart/geometries.dart';
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
      expect(feature.area, 8237532809.30144);
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
      expect(feature.area, 16475065618.60288);
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
}
