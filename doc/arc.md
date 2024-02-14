The arc generator produces a [circular](https://en.wikipedia.org/wiki/Circular_sector) or [annular](https://en.wikipedia.org/wiki/Annulus_(mathematics)) sector, as in a [pie](https://observablehq.com/@d3/pie-chart/2?intent=fork) or [donut](https://observablehq.com/@d3/donut-chart/2?intent=fork) chart. Arcs are centered at the origin; use a [transform](http://www.w3.org/TR/SVG/coords.html#TransformAttribute) to move the arc to a different position.

```dart
svg.append("path")
    .attr("transform", "translate(100,100)")
    .attr("d", Arc.withDefaults()([{
      "innerRadius": 100,
      "outerRadius": 200,
      "startAngle": -pi / 2,
      "endAngle": pi / 2
    }]));
```

If the absolute difference between the [start](https://pub.dev/documentation/d4_shape/latest/d4_shape/Arc/startAngle.html) and [end](https://pub.dev/documentation/d4_shape/latest/d4_shape/Arc/endAngle.html) angles (the *angular span*) is greater than 2π, the arc generator will produce a complete circle or annulus. If it is less than 2π, the arc’s angular length will be equal to the absolute difference between the two angles (going clockwise if the signed difference is positive and anticlockwise if it is negative). If the absolute difference is less than 2π, the arc may have [rounded corners](https://pub.dev/documentation/d4_shape/latest/d4_shape/Arc/cornerRadius.html) and [angular padding](https://pub.dev/documentation/d4_shape/latest/d4_shape/Arc/padAngle.html).

See also the [pie generator](https://pub.dev/documentation/d4_shape/latest/topics/Pies-topic.html), which computes the necessary angles to represent an list of data as a pie or donut chart; these angles can then be passed to an arc generator.