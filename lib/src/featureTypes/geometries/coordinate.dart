import 'dart:math';

/// The base coordinate class, used by all feature types.
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
  String toWKT() {
    return '$latitude $longitude';
  }

  /// Converts the [Coordinate] to a JSON coordinate [List].
  List<double> toJson() {
    return [longitude, latitude];
  }

  /// Creates a [Coordinate] from a JSON [List].
  factory Coordinate.fromJson(List<double> json) {
    return Coordinate(json[1], json[0]);
  }

  /// Creates a [Coordinate] from a WKT [String].
  factory Coordinate.fromWKT(String wkt) {
    final coordinates = wkt.split(' ');
    return Coordinate(
        double.parse(coordinates[1]), double.parse(coordinates[0]));
  }

  /// Returns the distance to a different [Coordinate] in meters.
  double distanceTo(Coordinate other) {
    final lat1 = latitude * (pi / 180);
    final lon1 = longitude * (pi / 180);
    final lat2 = other.latitude * (pi / 180);
    final lon2 = other.longitude * (pi / 180);

    final dLat = lat2 - lat1;
    final dLon = lon2 - lon1;

    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(lat1) * cos(lat2) * sin(dLon / 2) * sin(dLon / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return 6371 * c;
  }
}
