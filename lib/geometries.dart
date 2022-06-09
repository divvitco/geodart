/// # Features
///
/// Doing geospatial calculations requires feature types.
/// This library provides a set of feature types for use in geospatial
/// calculations, as well as a set of functions for working with them.
///
/// ## Geometry Types
///
/// The [Feature] class is the base class for all feature types.
///
/// ### Single Features
///
/// * The [Point] class is a feature type for points.
/// * The [LineString] class is a feature type for line strings.
/// * The [Polygon] class is a feature type for polygons.
///
/// ### Multi Features
///
/// * The [MultiPoint] class is a feature type for multi points.
/// * The [MultiLineString] class is a feature type for multi line strings.
/// * The [MultiPolygon] class is a feature type for multi polygons.
///
/// ### Geometry Collections
///
/// * The [FeatureCollection ] class is a feature type for feature collections.
///
/// ### Coordinates
///
/// * The [Coordinate] class is a coordinate type for to denote one location with lat/long data.
/// * The [LinearRing] class is a coordinate type for linear rings, which is a geometry type for polygons.
///
/// ## About Features
///
/// Each of the above feature classes has a [toJson] method that returns a GeoJSON [Map] of the feature,
/// as well as a [fromJson] method that creates a feature from a GeoJSON [Map].
///
/// Each of the above feature classes also has a [toWKT] method that returns a WKT [String] of the feature,
/// and a [fromWKT] method that creates a feature from a WKT [String].
///
/// Every feature has an [explode] method that returns a [List] of [Point]s used to create the feature.
///
/// Every `Multi` feature type has an [flatten] method that returns a [List] of the individual
/// features, as well as a [union] method that returns a [Feature] of the union of the individual features.
///
/// Examples of how to use the above feature classes are shown below.
///
/// ```dart
/// import 'package:geodart/features.dart';
///
/// // Create a point feature
/// Point point = Point(
///   Coordinate(1.0, 2.0)
///   properties: {
///     'name': 'Point',
///     'description': 'A point feature',
/// });
///
/// // Create a line string feature
/// LineString line = LineString([
///     Coordinate(1.0, 2.0),
///     Coordinate(3.0, 4.0),
///     Coordinate(5.0, 6.0),
///     Coordinate(7.0, 8.0),
///     Coordinate(9.0, 10.0),
///   ],
///   properties: {
///     'name': 'LineString',
///     'description': 'A line string feature',
///   }
/// );
///
/// // Create a polygon feature
/// Polygon poly = Polygon([
///   LinearRing([
///     Coordinate(1.0, 2.0),
///     Coordinate(3.0, 4.0),
///     Coordinate(5.0, 6.0),
///     Coordinate(7.0, 8.0),
///     Coordinate(9.0, 11.0),
///     Coordinate(1.0, 2.0)
///   ])],
///   properties: {
///     'name': 'Polygon',
///     'description': 'A polygon feature',
///   }
/// );
///
/// // Create a multi point feature
/// MultiPoint multiPoint = MultiPoint([
///     Coordinate(1.0, 2.0),
///     Coordinate(3.0, 4.0),
///     Coordinate(5.0, 6.0),
///   ]),
///   properties: {
///     'name': 'MultiPoint',
///     'description': 'A multi point feature',
///   }
/// );
library geometries;

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
