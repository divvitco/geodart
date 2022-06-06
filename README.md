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

TODO: Put a short description of the package here that helps potential users
know whether this package might be useful for them.

## Features

TODO: List what your package can do. Maybe include images, gifs, or videos.

## Getting started

TODO: List prerequisites and provide or point to information on how to
start using the package.

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

## Additional information

TODO: Tell users more about the package: where to find more information, how to 
contribute to the package, how to file issues, what response they can expect 
from the package authors, and more.
