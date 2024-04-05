import 'dart:async';
import 'dart:convert';
import 'package:geodart/conversions.dart';
import 'package:geodart/geometries.dart';
import 'package:http/http.dart' as http;

/// Calculate the speed in MPH between two points.
///
/// The speed is calculated by dividing the distance between the two points by the time it took to travel that distance.
/// The time is 5 seconds.
double calculateSpeedInMPH(Point latestPoint, Point newPoint) {
  double distance = latestPoint.coordinate
      .distanceTo(newPoint.coordinate, unit: DistanceUnits.miles);

  double speedInMph = distance * (3600 / 5); // 5 seconds
  return speedInMph;
}

void main() async {
  final countriesUrl =
      'https://raw.githubusercontent.com/johan/world.geo.json/master/countries.geo.json';

  LineString path = LineString([]);
  Point latestPoint = Point(Coordinate(0, 0));
  final url = 'http://api.open-notify.org/iss-now.json';

  try {
    final countriesResponse = await http.get(Uri.parse(countriesUrl));

    if (countriesResponse.statusCode == 200) {
      final countriesJsonData = json.decode(countriesResponse.body);

      FeatureCollection featureCollection =
          FeatureCollection.fromJson(countriesJsonData as Map<String, dynamic>);

      print(
          'The ISS does not travel over the ground at ground level, so the speed is not accurate. The speed is calculated at the surface based on changes in latitude and longitude.');

      Timer.periodic(Duration(seconds: 5), (timer) async {
        try {
          final response = await http.get(Uri.parse(url));

          if (response.statusCode == 200) {
            final jsonData = json.decode(response.body);

            Point newPoint = Point(Coordinate(
                double.parse(jsonData['iss_position']['latitude']),
                double.parse(jsonData['iss_position']['longitude'])));

            Feature containing = (featureCollection.features).firstWhere(
                (element) {
              if (element is Polygon) {
                return element.contains(newPoint);
              } else if (element is MultiPolygon) {
                return element.contains(newPoint);
              }
              return false;
            },
                orElse: () => Polygon([LinearRing([])],
                    properties: {"name": "the Ocean"}));

            double speed = calculateSpeedInMPH(latestPoint, newPoint);
            if (latestPoint.coordinate != Coordinate(0, 0)) {
              print(
                  'The ISS is going ${speed.round()} MPH (at the surface) over ${containing.properties['name']}');
            }

            path.coordinates.add(newPoint.coordinate);
            latestPoint = newPoint;
          } else {
            print('Request failed with status: ${response.statusCode}');
          }
        } catch (e) {
          print('Error: $e');
        }
      });
    } else {
      print('Request failed with status: ${countriesResponse.statusCode}');
    }
  } catch (e) {
    print('Error: $e');
  }
}
