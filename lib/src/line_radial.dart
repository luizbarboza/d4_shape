part of "line.dart";

/// A radial line generator is like the Cartesian
/// [line generator](https://pub.dev/documentation/d4_shape/latest/topics/Lines-topic.html)
/// except the [Line.x] and [Line.y] accessors are replaced with [angle] and
/// [radius] accessors.
///
/// Radial lines are positioned relative to the origin; use a
/// [transform](http://www.w3.org/TR/SVG/coords.html#TransformAttribute) to
/// change the origin.
///
/// {@category Radial lines}
class LineRadial<T> extends LineBase<T> {
  late CurveFactory _curve0;

  /// Constructs a new radial line generator with the given [angle] and [radius]
  /// accessor.
  ///
  /// ```dart
  /// final line = LineRadial(
  ///   (d, i, data) => x(d[…]),
  ///   (d, i, data) => y(d[…]),
  /// );
  /// ```
  LineRadial(super.angle, super.radius) {
    curve = curveLinear;
  }

  /// Constructs a new line generator with the given [angle] and [radius]
  /// numbers.
  LineRadial.withConstants(num angle, num radius)
      : this(constant(angle), constant(radius));

  /// Equivalent to [Line.call].
  ///
  /// ```dart
  /// svg.append("path").attr("d", line(data)).attr("stroke", "currentColor");
  /// ```
  @override
  call(data);

  /// Equivalent to [Line.x], except the accessor returns the angle in radians,
  /// with 0 at -*y* (12 o’clock).
  ///
  /// ```dart
  /// final line = LineRadial(…)..angle = (d, i, data) => x(d["Date"]);
  /// ```
  num Function(T, int, List<T>) get angle => _x;
  set angle(num Function(T, int, List<T>) angle) => _x = angle;

  /// Equivalent to [Line.y], except the accessor returns the radius: the
  /// distance from the origin.
  ///
  /// ```dart
  /// final line = LineRadial(…)..radius = (d, i, data) => x(d["temperature"]);
  /// ```
  num Function(T, int, List<T>) get radius => _y;
  set radius(num Function(T, int, List<T>) radius) => _y = radius;

  /// Defines the [LineRadial.angle]-accessor as a constant function that always
  /// returns the specified value.
  void constAngle(num angle) {
    _x = constant(angle);
  }

  /// Defines the [LineRadial.radius]-accessor as a constant function that
  /// always returns the specified value.
  void constRadius(num radius) {
    _y = constant(radius);
  }

  /// Equivalent to [Line.defined].
  ///
  /// ```dart
  /// final line = LineRadial(…)..defined = (d, i, data) => !d["temperature"].isNaN;
  /// ```
  @override
  get defined;

  /// Defines the [LineRadial.defined]-accessor as a constant function that
  /// always returns the specified value.
  @override
  constDefined(defined);

  /// Equivalent to [Line.curve].
  ///
  /// Note that [curveMonotoneX] or [curveMonotoneY] are not recommended for
  /// radial lines because they assume that the data is monotonic in *x* or *y*,
  /// which is typically untrue of radial lines.
  ///
  /// ```dart
  /// final line = LineRadial(…)..curve = curveBasis;
  /// ```
  @override
  get curve => _curve0;
  @override
  set curve(curve) => super.curve = curveRadial(_curve0 = curve);

  /// Equivalent to [Line.context].
  ///
  /// ```dart
  /// final context = …;
  /// final line = LineRadial(…)..context = context;
  ///
  /// line.context; // context
  /// ```
  @override
  get context;

  /// Equivalent to [Line.digits].
  ///
  /// ```dart
  /// final line = LineRadial(…)..digits = 3;
  ///
  /// line.digits; // 3
  /// ```
  @override
  get digits;

  /// Equivalent to [LineRadial.new], except that if [angle] or [radius] are not
  /// specified, the respective defaults will be used.
  static LineRadial<List<num>> withDefaults(
      {num Function(List<num>, int, List<List<num>>) angle = pointX,
      num Function(List<num>, int, List<List<num>>) radius = pointY}) {
    return LineRadial<List<num>>(angle, radius);
  }
}

LineRadial<T> lineRadial<T>(Line<T> l) {
  return LineRadial(l.x, l.y)
    ..defined = l.defined
    ..curve = l.curve
    ..context = l.context;
}
