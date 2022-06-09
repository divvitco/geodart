import 'package:geodart/conversions.dart';
import 'package:test/test.dart';

void main() {
  group("distance.dart", () {
    test("To and from meters", () {
      expect(convertDistance(1, SingleAxisUnits.meters, SingleAxisUnits.meters),
          1);
    });

    test("There and back again", () {
      double original = 2;
      double middle = convertDistance(
          original, SingleAxisUnits.nauticalMiles, SingleAxisUnits.feet);
      expect(
          convertDistance(
              middle, SingleAxisUnits.feet, SingleAxisUnits.nauticalMiles),
          original);
    });

    test("Meters to centimeters", () {
      expect(
          convertDistance(
              1, SingleAxisUnits.meters, SingleAxisUnits.centimeters),
          100);
    });
  });
}
