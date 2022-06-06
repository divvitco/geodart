/// Doing geospatial calculations requires feature types.
/// This library provides a set of feature types for use in geospatial
/// calculations.
///
/// The [Feature] class is the base class for all feature types.
library features;

/// Feature Types
export 'src/featureTypes/geometries/coordinate.dart';
export 'src/featureTypes/geometries/linear_ring.dart';
export 'src/featureTypes/feature.dart';
export 'src/featureTypes/point.dart';
export 'src/featureTypes/multi_point.dart';
export 'src/featureTypes/line_string.dart';
export 'src/featureTypes/multi_line_string.dart';
export 'src/featureTypes/polygon.dart';
export 'src/featureTypes/multi_polygon.dart';
export 'src/featureTypes/feature_collection.dart';
