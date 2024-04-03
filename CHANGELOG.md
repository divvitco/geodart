## 0.3.4

- PR Validator to verify changes to main and PRs in 
- Feature collection from wkt
- Static analysis warnings

## 0.3.3

- Update linear_ring.dart (thanks [@sheldoncoup](https://github.com/sheldoncoup))
- dart analyze errors for use_super_parameters
- multipolygon from wkt
- BUG: No intersections using LineString

## 0.3.2

- polygon intersections
- add buffering to points to make circles
- add light error checking to multipolygon union
- convex hull calculation for feature collections

## 0.3.1

- `MultiLineString.fromJson` creation bug.
- Update lint version

## 0.3.0

- Add conversion from LLA Coordinate to ENU Coordinate (thanks [@keenranger](https://github.com/keenranger))

## 0.2.8

- `MultiLineString.fromWKT` creation bug.

## 0.2.7

- `LineString.hashCode` operator.

## 0.2.6

- `Feature` now has `+` capabilities.
- `FeatureCollection` now has `+` capabilities.
- `MultiPoint.random({int points})` created.
- `LineString.random({int length})` added `length` parameter.
- `MultiLineString.random({int count, int length})` added `length` and `count` parameter.
- `LineString.intersections` added.
- `LineString.slope` added.
- `LineString.contains` added.

## 0.2.5

- `LinearRing.contains` bug fix
- Tests for `LinearRing.contains` bug fix 

## 0.2.4

- `Polygon.random()` created.
- Add readme links to conversion headings.
- Additional `LineString` methods and properties.
- `LinearRing` `random()` `centroid` and `area` methods added.
- `Point` and `Polygon` `contained` and `isContainedIn` methods added in `LinearRing`, `MultiPolygon`, `Polygon`, and `Point`.

## 0.2.3

- Expose `convertAngle` function.
- Fix readme conversion bugs.
- Change `distanceTo` and `bearingTo` to accept units.
- Document available units in readme.

## 0.2.2

- Add BoundingBox `toPolygon` conversion
- Add linestring `segments` property
- Add `envelope` property to `BoundingBox`
- Add `square` property to `BoundingBox`
- Add `isCollectionOf` and `nearestPointTo` property to `FeatureCollection`

## 0.2.1

- Add BoundingBox as geometry tyoe
- add `.bbox` method to all geometry features

## 0.2.0

- Point lat lng exposed on point
- add `center` method to all geometries
- Add conversion example to README

## 0.1.3

- More readme badges
- Convert between angle units
- Add conversion example to README

## 0.1.2

- Add area conversions to the `conversions` library.
- Fix readme pub.dev badge.
- Fix examples path.

## 0.1.1

- Found an incorrect import in readme
- Added badges (hopefully) to the readme

## 0.1.0

- Remove installation information from the README.md
- Add conversion library, with 1d conversions, with tests

## 0.0.2

- Changed pubspec information
- Un-ignored docs and examples

## 0.0.1

- Initial version.

