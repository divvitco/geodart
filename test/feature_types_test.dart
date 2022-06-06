import 'package:geodart/features.dart';
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
