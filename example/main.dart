import 'package:geodart/geometries.dart';
import 'package:geodart/measurements.dart';
import 'package:geodart/conversions.dart';

void main() {
  // EXAMPLE ONE
  // How long is this line in Nautical Miles?
  LineString line = LineString([
    Coordinate(-33.867, 151.206),
    Coordinate(-33.867, 151.206),
  ]);

  // Two ways to get the distance in meters
  double distance1 = line.length;
  double distance2 = length(line);

  // And the distance in Nautical Miles
  double distanceNM1 = convertDistance(
      distance1, DistanceUnits.meters, DistanceUnits.nauticalMiles);
  double distanceNM2 = convertDistance(
      distance2, DistanceUnits.meters, DistanceUnits.nauticalMiles);

  // They should be the same
  assert(distanceNM1 == distanceNM2);
  print("$distanceNM1");

  // EXAMPLE TWO
  // What is the area of this multipolygon in hectares?
  MultiPolygon multipolygon = MultiPolygon([
    [
      LinearRing([
        Coordinate(0, 0),
        Coordinate(0, 1),
        Coordinate(1, 1),
        Coordinate(1, 0),
        Coordinate(0, 0),
      ])
    ],
    [
      LinearRing([
        Coordinate(1, 1),
        Coordinate(1, 2),
        Coordinate(2, 2),
        Coordinate(2, 1),
        Coordinate(1, 1),
      ])
    ],
  ]);

  // Two ways to get the area in square meters
  double area1 = multipolygon.area;
  double area2 = area(multipolygon);

  // And the area in hectares
  double areaHectares1 =
      convertArea(area1, AreaUnits.squareMeters, AreaUnits.hectares);
  double areaHectares2 =
      convertArea(area2, AreaUnits.squareMeters, AreaUnits.hectares);

  // They should be the same
  assert(areaHectares1 == areaHectares2);
  print("$areaHectares1");

  // EXAMPLE THREE
  // What is the distance in yards from the first point of a line to the last point?
  LineString threeLineExample = LineString([
    Coordinate(0, 0),
    Coordinate(1, 1),
    Coordinate(1, 0),
  ]);

  // Get the distance in meters
  double threeDistanceMeters = threeLineExample.coordinates.first
      .distanceTo(threeLineExample.coordinates.last);

  // And the distance in yards
  double threeDistanceYards = convertDistance(
      threeDistanceMeters, DistanceUnits.meters, DistanceUnits.yards);
  print("$threeDistanceYards");
}
