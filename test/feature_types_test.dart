import 'package:geodart/feature_types.dart';
import 'package:geodart/src/featureTypes/feature.dart';
import 'package:test/test.dart';

void main() {
  group('A group of tests', () {
    final feature = Feature(properties: {'name': 'test'});

    setUp(() {
      // Additional setup goes here.
    });

    test('First Test', () {
      expect(feature.properties['name'], 'test');
    });
  });
}
