import 'package:geodart/feature_types.dart';
import 'package:geodart/src/featureTypes/point.dart';

void main() {
  var awesome = Point.fromWKT('POINT(10 20)');
  print('awesome: ${awesome..coordinate.latitude}');
}
