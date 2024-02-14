/// Visualizations can be represented by discrete graphical marks such as
/// [symbols](https://pub.dev/documentation/d4_shape/latest/topics/Symbols-topic.html),
/// [arcs](https://pub.dev/documentation/d4_shape/latest/topics/Arcs-topic.html),
/// [lines](https://pub.dev/documentation/d4_shape/latest/topics/Lines-topic.html),
/// and
/// [areas](https://pub.dev/documentation/d4_shape/latest/topics/Areas-topic.html).
/// While the rectangles of a bar chart may sometimes be simple, other shapes
/// are complex, such as rounded annular sectors and Catmull–Rom splines. The
/// d4_shape package provides a variety of shape generators for your
/// convenience.
///
/// As with other aspects of D4, these shapes are driven by data: each shape
/// generator exposes accessors that control how the input data are mapped to a
/// visual representation. For example, you might define a line generator for a
/// time series by
/// [scaling](https://pub.dev/documentation/d4_scale/latest/d4_scale/d4_scale-library.html)
/// fields of your data to fit the chart:
///
/// ```dart
/// final line = Line(
///   (d, i, data) => x(d["date"]),
///   (d, i, data) => y(d["value"]),
/// );
/// ```
///
/// This line generator can then be used to compute the `d` attribute of an SVG
/// path element:
///
/// ```dart
/// path.datum(data).attr("d", line);
/// ```
///
/// Or you can use it to render to a Canvas 2D context:
///
/// ```dart
/// line.context(context)(data);
/// ```
export 'src/d4_shape.dart';
