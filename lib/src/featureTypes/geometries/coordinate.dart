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
}
