import 'dart:math';

import 'package:geodart/conversions.dart';

/// The base coordinate class, used by all feature types.
/// It's used to represent a point in geographic coordinates.
///
/// Example:
/// ```dart
/// Coordinate(1, 2); // Coordinate(1, 2)
/// Coordinate(1, 2).toWKT(); // 1 2
/// Coordinate(1, 2).toJson(); // [1, 2]
/// ```
class Coordinate {
  final double latitude;
  final double longitude;
  static final String type = 'Coordinate';

  Coordinate(this.latitude, this.longitude);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Coordinate &&
          runtimeType == other.runtimeType &&
          latitude == other.latitude &&
          longitude == other.longitude;

  @override
  int get hashCode => latitude.hashCode ^ longitude.hashCode;

  @override
  String toString() {
    return 'Coordinate{latitude: $latitude, longitude: $longitude}';
  }

  /// Converts the [Coordinate] to a WKT [String].
  /// Useless on its own, but useful for other classes.
  ///
  /// Example:
  /// ```dart
  /// Coordinate(1, 2).toWKT(); // 1 2
  /// ```
  String toWKT() {
    return '$longitude $latitude';
  }

  /// Converts the [Coordinate] to a JSON coordinate [List].
  ///
  /// Example:
  /// ```dart
  /// Coordinate(1, 2).toJson(); // [1, 2]
  /// ```
  List<double> toJson() {
    return [longitude, latitude];
  }

  /// Creates a [Coordinate] from a JSON [List].
  ///
  /// Example:
  /// ```dart
  /// Coordinate.fromJson([1, 2]); // Coordinate(1, 2)
  /// ```
  factory Coordinate.fromJson(List<double> json) {
    return Coordinate(json[1], json[0]);
  }

  /// Creates a [Coordinate] from a WKT [String].
  ///
  /// Example:
  /// ```dart
  /// Coordinate.fromWKT('1 2'); // Coordinate(1, 2)
  /// ```
  factory Coordinate.fromWKT(String wkt) {
    final coordinates = wkt.split(' ');
    return Coordinate(
        double.parse(coordinates[1]), double.parse(coordinates[0]));
  }

  /// Returns a random [Coordinate].
  /// This is useful for testing.
  ///
  /// Example:
  /// ```dart
  /// Coordinate.random();
  /// ```
  factory Coordinate.random() {
    return Coordinate(
        Random().nextDouble() * 180 - 90, Random().nextDouble() * 360 - 180);
  }

  /// Returns the distance to a different [Coordinate] in meters or specified [unit].
  /// Uses the [Haversine formula](https://en.wikipedia.org/wiki/Haversine_formula) to calculate the distance between two points.
  ///
  /// Example:
  /// ```dart
  /// Coordinate(1, 2).distanceTo(Coordinate(3, 4)); // 314635.33
  /// ```
  double distanceTo(Coordinate other, {DistanceUnit? unit}) {
    final lat1 = latitude * (pi / 180);
    final lon1 = longitude * (pi / 180);
    final lat2 = other.latitude * (pi / 180);
    final lon2 = other.longitude * (pi / 180);

    final dLat = lat2 - lat1;
    final dLon = lon2 - lon1;

    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(lat1) * cos(lat2) * sin(dLon / 2) * sin(dLon / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return convertDistance(
      6371000 * c,
      DistanceUnits.meters,
      unit ?? DistanceUnits.meters,
    );
  }

  /// Returns the bearing to a different [Coordinate] in degrees, or specified [unit].
  /// Uses the [Haversine formula](https://en.wikipedia.org/wiki/Haversine_formula) to calculate the bearing between two points.
  ///
  /// Example:
  /// ```dart
  /// Coordinate(1, 2).bearingTo(Coordinate(3, 4)); // 45.0
  /// ```
  double bearingTo(Coordinate other, {AngleUnit? unit}) {
    final lat1 = latitude * (pi / 180);
    final lon1 = longitude * (pi / 180);
    final lat2 = other.latitude * (pi / 180);
    final lon2 = other.longitude * (pi / 180);

    final dLon = lon2 - lon1;

    final y = sin(dLon) * cos(lat2);
    final x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon);
    final bearing = atan2(y, x);

    return convertAngle((bearing * (180 / pi) + 360) % 360, AngleUnits.degrees,
        unit ?? AngleUnits.degrees);
  }

  /// Returns the [Coordinate] at a certain distance and bearing from the [Coordinate].
  /// [distance] is in meters and [bearing] is in degrees.
  /// Uses the [Haversine formula](https://en.wikipedia.org/wiki/Haversine_formula) to calculate the new coordinate.
  ///
  /// Example:
  /// ```dart
  /// Coordinate(1, 2).destination(1000, 45); // Coordinate(3.0, 4.0)
  /// ```
  Coordinate destination(double distance, double bearing) {
    final lat1 = latitude * (pi / 180);
    final lon1 = longitude * (pi / 180);

    final bearingRad = bearing * (pi / 180);

    final d = distance / 6371000;

    final lat2 =
        asin(sin(lat1) * cos(d) + cos(lat1) * sin(d) * cos(bearingRad));
    final lon2 = lon1 +
        atan2(sin(bearingRad) * sin(d) * cos(lat1),
            cos(d) - sin(lat1) * sin(lat2));

    return Coordinate(lat2 * (180 / pi), lon2 * (180 / pi));
  }

  /// Returns the [Coordinate] at a certain fraction of the distance between the [Coordinate] and different [Coordinate], [to].
  /// Uses the [Haversine formula](https://en.wikipedia.org/wiki/Haversine_formula) to calculate the new coordinate.
  /// The [fraction] is a number between 0 and 1.
  /// If the [fraction] is 0, the [Coordinate] will be the same as the [Coordinate].
  /// If the [fraction] is 1, the [Coordinate] will be the same as the [to].
  ///
  /// Example:
  /// ```dart
  /// Coordinate(1, 2).interpolate(Coordinate(3, 4), 0.5); // Coordinate(2, 3)
  /// ```
  Coordinate interpolate(Coordinate to, double fraction) {
    final lat1 = latitude * (pi / 180);
    final lon1 = longitude * (pi / 180);
    final lat2 = to.latitude * (pi / 180);
    final lon2 = to.longitude * (pi / 180);

    final dLon = lon2 - lon1;

    final bx = cos(lat2) * cos(dLon);
    final by = cos(lat2) * sin(dLon);

    final lat3 = atan2(sin(lat1) + sin(lat2),
        sqrt((cos(lat1) + bx) * (cos(lat1) + bx) + by * by));
    final lon3 = lon1 + atan2(by, cos(lat1) + bx);

    return Coordinate(lat3 * (180 / pi), lon3 * (180 / pi));
  }
}
