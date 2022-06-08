<!-- 
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages). 

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages). 
-->

# Geodart

A geospatial library for Dart. Designed primarily around vector features,
this library provides a simple interface for working with geographic data.

It's based heavily on the geojson specification, but has been extended to
add functionality directly to the feature types.

## Getting started

#### Add it to your dependencies:

```yaml
dependencies:
  geodart: '^0.0.1'
```
OR run this command to install it:

```terminal
flutter pub add geodart
```

#### Then import it:

```dart
import 'package:geodart/features.dart';
import 'package:geodart/measure.dart';
```

## Features

The following features are included in this library:

* [`FeatureCollection`](#Feature-Collection)
* [`LineString`](#Line-String)
* [`MultiLineString`](#Multi-Line-String)
* [`MultiPoint`](#Multi-Point)
* [`MultiPolygon`](#Multi-Polygon)
* [`Point`](#Point)
* [`Polygon`](#Polygon)

The package also provides a [`Feature`](#Feature) class, which is a
abstract class that can be extended to create new feature types.

Positions are stored using [`Coordinate`](#Coordinate) objects, which has a variety of
convenience methods for working with coordinates.

### Feature Collection


A [`FeatureCollection`](#Feature-Collection) is a collection of
[`Feature`](#Feature) objects. 

It functions very similarly to a [`List`](https://api.dartlang.org/stable/dart-core/List-class.html) of [`Feature`](#Feature) objects,
but might extended to include additional properties in the future.

**Constructors**

* `FeatureCollection.fromJson(Map<String, dynamic> json)` - Creates a [`FeatureCollection`](#Feature-Collection) from a JSON object. Automatically converts features from GeoJSON to their respective types.

**Methods**

* `toJson()` - Returns a JSON object representing the [`FeatureCollection`](#Feature-Collection). Automatically converts features to GeoJSON.

**Properties**

* `features` - A [`List`](https://api.dartlang.org/stable/dart-core/List-class.html) of [`Feature`](#Feature) objects.

### Point

A [`Point`](#Point) is a single position. It is represented by a [`Coordinate`](#Coordinate) object.

**Constructors**

* `Point.fromJson(Map<String, dynamic> json)` - Creates a [`Point`](#Point) from a [`Map`](https://api.dartlang.org/stable/dart-core/Map-class.html) of GeoJSON data.
* `Point.fromLngLat(num lng, num lat)` - Creates a [`Point`](#Point) from a [`num`](https://api.dartlang.org/stable/dart-core/num-class.html) longitude and latitude.
* `Point.fromWKT(String wkt)` - Creates a [`Point`](#Point) from a Well-Known Text string.

**Methods**

* `explode()` - Returns a [`List`](https://api.dartlang.org/stable/dart-core/List-class.html) of itself.
* `toJson()` - Returns a [`Map`](https://api.dartlang.org/stable/dart-core/Map-class.html) of GeoJSON data.
* `toWKT()` - Returns a Well-Known Text string representing the [`Point`](#Point).

**Properties**

* `coordinates` - The [`Coordinate`](#Coordinate) of the [`Point`](#Point).
* `type` - The type of the [`Point`](#Point). Always `"Point"`.
* `properties` - A [`Map`](https://api.dartlang.org/stable/dart-core/Map-class.html) of properties.

### Multi Point

A [`MultiPoint`](#Multi-Point) is a collection of [`Coordinate`](#Coordinate) objects, represented by individual and non-connected points.

**Constructors**

* `MultiPoint.fromJson(Map<String, dynamic> json)` - Creates a [`MultiPoint`](#Multi-Point) from a [`Map`](https://api.dartlang.org/stable/dart-core/Map-class.html) of GeoJSON data.
* `MultiPoint.fromWKT(String wkt)` - Creates a [`MultiPoint`](#Multi-Point) from a Well-Known Text string.

**Methods**

* `explode()` - Returns a [`List`](https://api.dartlang.org/stable/dart-core/List-class.html) of [`Point`](#Point) objects.
* `toJson()` - Returns a [`Map`](https://api.dartlang.org/stable/dart-core/Map-class.html) of GeoJSON data.
* `toWKT()` - Returns a Well-Known Text string representing the [`MultiPoint`](#Multi-Point).
* `union(MultiPoint other)` - Merges the [`MultiPoint`](#Multi-Point) with another [`MultiPoint`](#Multi-Point).
* `flatten()` - Returns a [`List`](https://api.dartlang.org/stable/dart-core/List-class.html) of [`Point`](#Point) objects.

**Properties**

* `coordinates` - A [`List`](https://api.dartlang.org/stable/dart-core/List-class.html) of [`Coordinate`](#Coordinate) objects.
* `type` - The type of the [`MultiPoint`](#Multi-Point). Always `"MultiPoint"`.
* `properties` - A [`Map`](https://api.dartlang.org/stable/dart-core/Map-class.html) of properties.

### Line String

A [`LineString`](#Line-String) is a collection of [`Coordinate`](#Coordinate) objects that form a line.

**Constructors**

* `LineString.fromJson(Map<String, dynamic> json)` - Creates a [`LineString`](#Line-String) from a [`Map`](https://api.dartlang.org/stable/dart-core/Map-class.html) of GeoJSON data.
* `LineString.fromWkt(String wkt)` - Creates a [`LineString`](#Line-String) from a Well-Known Text string.

**Methods**

* `along(distance)` - Returns a [`Point`](#Point) at the specified distance along the line.
* `explode()` - Returns a [`List`](https://api.dartlang.org/stable/dart-core/List-class.html) of [`Point`](#Point) objects that make up the LineString.
* `midpoint()` - Returns a [`Point`](#Point) at the midpoint of the LineString.
* `toJson()` - Returns a GeoJSON [`Map`](https://api.dartlang.org/stable/dart-core/Map-class.html) of the LineString.
* `toPolygon()` - Returns a [`Polygon`](#Polygon) that is the same as the LineString. LineString must be closed, or an exception will be thrown.
* `toWKT()` - Returns a [`String`](https://api.dartlang.org/stable/dart-core/String-class.html) of the LineString in WKT format.

**Properties**

* `coordinates` - A [`List`](https://api.dartlang.org/stable/dart-core/List-class.html) of [`Coordinate`](#Coordinate) objects that make up the LineString.
* `type` - The type of the LineString. Always `"LineString"`.
* `isClosedRing` - A boolean indicating whether the LineString is a closed ring.
* `length` - The length (in meters) of the LineString.
* `properties` - A [`Map`](https://api.dartlang.org/stable/dart-core/Map-class.html) of properties.

### Multi Line String

A [`MultiLineString`](#Multi-Line-String) is a collection of [`Coordinate`](#Coordinate) objects that form multiple separate LineStrings with one set of shared properties.

**Constructor**

* `MultiLineString.fromJson(Map<String, dynamic> json)` - Creates a [`MultiLineString`](#Multi-Line-String) from a [`Map`](https://api.dartlang.org/stable/dart-core/Map-class.html) of GeoJSON data.
* `MultiLineString.fromWkt(String wkt)` - Creates a [`MultiLineString`](#Multi-Line-String) from a Well-Known Text string.

**Methods**

* `explode()` - Returns a [`List`](https://api.dartlang.org/stable/dart-core/List-class.html) of [`LineString`](#Line-String) objects.
* `toJson()` - Returns a [`Map`](https://api.dartlang.org/stable/dart-core/Map-class.html) of GeoJSON data.
* `toWKT()` - Returns a Well-Known Text string representing the [`MultiLineString`](#Multi-Line-String).
* `union(MultiLineString other)` - Merges the [`MultiLineString`](#Multi-Line-String) with another [`MultiLineString`](#Multi-Line-String).
* `flatten()` - Returns a [`List`](https://api.dartlang.org/stable/dart-core/List-class.html) of [`LineString`](#Line-String) objects.

**Properties**

* `coordinates` - A nested [`List`](https://api.dartlang.org/stable/dart-core/List-class.html) of [`Coordinate`](#Coordinate) objects.
* `type` - The type of the [`MultiLineString`](#Multi-Line-String). Always `"MultiLineString"`.
* `properties` - A [`Map`](https://api.dartlang.org/stable/dart-core/Map-class.html) of properties.

### Polygon

A [`Polygon`](#Polygon) is a collection of [`LinearRing`](#Linear Ring) objects that form a closed ring. The first LinearRing in the list is the outer ring, and any subsequent LinearRings are holes. Holes should be contained within the outer ring - if they are not, some algorithms may not work correctly. A Polygon should also not intersect itself - again, some algorithms may not work correctly if this is not the case.

**Constructors**

* `Polygon.fromJson(Map<String, dynamic> json)` - Creates a [`Polygon`](#Polygon) from a [`Map`](https://api.dartlang.org/stable/dart-core/Map-class.html) of GeoJSON data.
* `Polygon.fromWkt(String wkt)` - Creates a [`Polygon`](#Polygon) from a Well-Known Text string.

**Methods**

* `explode()` - Returns a [`List`](https://api.dartlang.org/stable/dart-core/List-class.html) of [`Point`](#Point) objects.
* `toJson()` - Returns a [`Map`](https://api.dartlang.org/stable/dart-core/Map-class.html) of GeoJSON data.
* `toWKT()` - Returns a Well-Known Text string representing the [`Polygon`](#Polygon).
* `toLineString()` - Returns a [`LineString`](#Line-String) that is the same geometry as the [`Polygon`](#Polygon).

**Properties**

* `coordinates` - A [`List`](https://api.dartlang.org/stable/dart-core/List-class.html) of [`LinearRing`](#Linear Ring) objects.
* `type` - The type of the [`Polygon`](#Polygon). Always `"Polygon"`.
* `area` - The are (in square meters) of the Polygon.
* `properties` - A [`Map`](https://api.dartlang.org/stable/dart-core/Map-class.html) of properties.

### Multi Polygon

A [`MultiPolygon`](#Multi-Polygon) is a collection of [`Polygon`](#Polygon) geometries forming one MultiPolygon with shared properties.

**Constructors**

* `MultiPolygon.fromJson(Map<String, dynamic> json)` - Creates a [`MultiPolygon`](#Multi-Polygon) from a [`Map`](https://api.dartlang.org/stable/dart-core/Map-class.html) of GeoJSON data.
* `MultiPolygon.fromWkt(String wkt)` - Creates a [`MultiPolygon`](#Multi-Polygon) from a Well-Known Text string.

**Methods**

* `explode()` - Returns a [`List`](https://api.dartlang.org/stable/dart-core/List-class.html) of [`Point`](#Point) objects.
* `toJson()` - Returns a [`Map`](https://api.dartlang.org/stable/dart-core/Map-class.html) of GeoJSON data.
* `toWKT()` - Returns a Well-Known Text string representing the [`MultiPolygon`](#Multi-Polygon).
* `union(MultiPolygon other)` - Merges the [`MultiPolygon`](#Multi-Polygon) with another [`MultiPolygon`](#Multi-Polygon).
* `flatten()` - Returns a [`List`](https://api.dartlang.org/stable/dart-core/List-class.html) of [`Polygon`](#Polygon) objects.
* `toMultiLineString()` - Returns a [`MultiLineString`](#Multi-Line-String) that is the same geometry as the [`MultiPolygon`](#Multi-Polygon).

**Properties**

* `coordinates` - A [`List`](https://api.dartlang.org/stable/dart-core/List-class.html) of [`Polygon`](#Polygon) objects.
* `type` - The type of the [`MultiPolygon`](#Multi-Polygon). Always `"MultiPolygon"`.
* `properties` - A [`Map`](https://api.dartlang.org/stable/dart-core/Map-class.html) of properties.
* `area` - The are (in square meters) of the MultiPolygon.

### Coordinate

A [`Coordinate`](#Coordinate) is a point in a two-dimensional Cartesian coordinate system.

**Constructors**

* `Coordinate.fromJson(Map<String, dynamic> json)` - Creates a [`Coordinate`](#Coordinate) from a [`Map`](https://api.dartlang.org/stable/dart-core/Map-class.html) of GeoJSON data.
* `Coordinate.fromWkt(String wkt)` - Creates a [`Coordinate`](#Coordinate) from a Well-Known Text string.

**Methods**

* `toJson()` - Returns a [`Map`](https://api.dartlang.org/stable/dart-core/Map-class.html) of GeoJSON data.
* `toWKT()` - Returns a Well-Known Text string representing the [`Coordinate`](#Coordinate).
* `distanceTo(Coordinate other)` - Returns the distance (in meters) between the [`Coordinate`](#Coordinate) and another [`Coordinate`](#Coordinate).
* `bearingTo(Coordinate other)` - Returns the bearing (in degrees) between the [`Coordinate`](#Coordinate) and another [`Coordinate`](#Coordinate).
* `destination(num distance, num bearing)` - Returns a [`Coordinate`](#Coordinate) that is the same geometry as the [`Coordinate`](#Coordinate) but moved a given distance and bearing.
* `interpolate(Coordinate other, num fraction)` - Returns a [`Coordinate`](#Coordinate) that is the same geometry as the [`Coordinate`](#Coordinate) but moved a given fraction of the distance and bearing to another [`Coordinate`](#Coordinate).

**Properties**

* `latitude` - The latitude of the [`Coordinate`](#Coordinate).
* `longitude` - The longitude of the [`Coordinate`](#Coordinate).
* `type` - The type of the [`Coordinate`](#Coordinate). Always `"Coordinate"`.

## Usage

**Measure the distance between two points.**

```dart
import 'package:geodart/measure.dart';
import 'package:geodart/features.dart';

double distanceBetween = distance(
    Point.fromLngLat(1.0, 1.0),
    Point.fromLngLat(2.0, 2.0),
);
```

Under the hood, this uses the coordinate `distanceTo()` function, and could be very easily replaced with a different algorithm.
I prefer the `distanceTo()` function because it is more explicit and easier to read.

```dart
import 'package:geodart/features.dart';

double distanceBetween = Coordinate(1.0, 1.0).distanceTo(Coordinate(2.0, 2.0));
```

**Measure the area of a polygon.**

```dart
import 'package:geodart/features.dart';

Polygon polygon = Polygon.fromJson(
    {
      'type': 'Polygon',
      'coordinates': [
        [
          [1.0, 1.0],
          [2.0, 1.0],
          [2.0, 2.0],
          [1.0, 1.0],
        ],
      ],
    }
);
print(polygon.area);
```

**Measure the length of a LineString.**

[`LineString`](#Line-String) length is calculated on the fly.

```dart
import 'package:geodart/features.dart';

LineString lineString = LineString.fromJson(
    {
      'type': 'LineString',
      'coordinates': [
        [1.0, 1.0],
        [2.0, 2.0],
      ],
    }
);
print(lineString.length);
```

## Additional information

### License

This library is free software under the terms of the MIT license.
See the [LICENSE](/LICENSE) file for more details.

### Contributing

If you have any questions or comments, please open an issue on the [Github repository](https://github.com/divvitco/geodart/issues).

If you want to make a pull request, please open a pull request on the [Github repository](https://github.com/divvitco/geodart). Please make sure to include a test suite. I make no promises that I will accept pull requests, but I will try my best to keep the code up to date.
