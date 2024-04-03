import 'package:geodart/geometries.dart';
import 'package:test/test.dart';

import 'test_data/feature_collection/hydroelectric_lines_canada.dart';

void main() {
  group('feature_collection.dart', () {
    test('canadian hydroelectric lines - there and back again', () {
      FeatureCollection featureCollection =
          FeatureCollection.fromJson(hydroelectricLinesCanada);
      Map<String, dynamic> featureCollectionJson = featureCollection.toJson();

      expect(hydroelectricLinesCanada, featureCollectionJson);
    });

    test('from wkt', () {
      FeatureCollection featureCollection = FeatureCollection.fromWKT(
          'GEOMETRYCOLLECTION(POINT(1 2), LINESTRING(1 2, 3 4))');
      expect(featureCollection.features.length, 2);
      expect(featureCollection.features[0] is Point, true);
      expect(featureCollection.features[1] is LineString, true);
      expect(featureCollection.features[0], Point.fromWKT('POINT(1 2)'));
    });
  });
}
