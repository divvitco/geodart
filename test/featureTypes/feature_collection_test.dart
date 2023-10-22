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
  });
}
