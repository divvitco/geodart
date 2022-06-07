import 'package:geodart/features.dart';
import 'package:test/test.dart';

void main() {
  group('A group of tests', () {
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
      expect(feature.area, 8237532809.30);
    });
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
}
