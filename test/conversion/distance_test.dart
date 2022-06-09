import 'package:geodart/conversions.dart';
import 'package:test/test.dart';

void main() {
  group("distance.dart", () {
    test("To and from meters", () {
      expect(convertDistance(1, DistanceUnits.meters, DistanceUnits.meters), 1);
    });

    test("There and back again", () {
      double original = 2;
      double middle = convertDistance(
          original, DistanceUnits.nauticalMiles, DistanceUnits.feet);
      expect(
          convertDistance(
              middle, DistanceUnits.feet, DistanceUnits.nauticalMiles),
          original);
    });

    test("Meters to centimeters", () {
      expect(
          convertDistance(1, DistanceUnits.meters, DistanceUnits.centimeters),
          100);
    });
  });
}
