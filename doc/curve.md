Curves turn a discrete (pointwise) representation of a [line](https://pub.dev/documentation/d4_shape/latest/topics/Lines-topic.html) or [area](https://pub.dev/documentation/d4_shape/latest/topics/Areas-topic.html) into a continuous shape: curves specify how to interpolate between two-dimensional \[*x*, *y*\] points.

Curves are typically not constructed or used directly. Instead, one of the built-in curves is being passed to [*line*.curve](https://pub.dev/documentation/d4_shape/latest/d4_shape/Line/curve.html) or [*area*.curve](https://pub.dev/documentation/d4_shape/latest/d4_shape/Area/curve.html).

```dart
final line = Line(
  (d, i, data) => x(d["date"]),
  (d, i, data) => y(d["value"]),
)..curve = curveCatmullRomAlpha(0.5);
```

If desired, you can implement a [custom curve](https://pub.dev/documentation/d4_shape/latest/d4_shape/Curve-class.html). For an example of using a curve directly, see [Context to Curve](https://observablehq.com/@d3/context-to-curve).