part of "area.dart";

/// A radial area generator is like the Cartesian
/// [area generator](https://pub.dev/documentation/d4_shape/latest/topics/Areas-topic.html)
/// except the [Area.x] and [Area.y] accessors are replaced with [angle] and
/// [radius] accessors.
///
/// Radial areas are positioned relative to the origin; use a
/// [transform](http://www.w3.org/TR/SVG/coords.html#TransformAttribute) to
/// change the origin.
///
/// {@category Radial areas}
class AreaRadial<T> extends AreaBase<T> {
  late CurveFactory _curve0;

  /// Constructs a new area generator with the given [startAngle],
  /// [innerRadius], and [outerRadius] accessors.
  ///
  /// ```dart
  /// final area = AreaRadial(
  ///   (d, i, data) => x(d[…]),
  ///   (d, i, data) => y(0),
  ///   (d, i, data) => y(d[…]),
  /// );
  /// ```
  AreaRadial(
      {required num Function(T, int, List<T>) startAngle,
      num Function(T, int, List<T>)? innerRadius,
      required num Function(T, int, List<T>)? outerRadius})
      : super(x: startAngle, y0: innerRadius, y1: outerRadius) {
    curve = curveLinear;
  }

  /// Constructs a new area generator with the given [startAngle],
  /// [innerRadius], and [outerRadius] numbers.
  AreaRadial.withConstants(
      {required num startAngle, num? innerRadius, required num? outerRadius})
      : this(
            startAngle: constant(startAngle),
            innerRadius: constant(innerRadius ?? 0),
            outerRadius: outerRadius != null ? constant(outerRadius) : null);

  /// Equivalent to [Area.call].
  ///
  /// ```dart
  /// svg.append("path").attr("d", area(data));
  /// ```
  @override
  call(data);

  /// Equivalent to [Area.x], except the accessor returns the angle in radians,
  /// with 0 at -*y* (12 o’clock).
  ///
  /// ```dart
  /// final area = AreaRadial(…)..angle = (d, i, data) => a(d["Date"]);
  /// ```
  num Function(T, int, List<T>) get angle => _x0;
  set angle(num Function(T, int, List<T>) angle) {
    _x0 = angle;
    _x1 = null;
  }

  /// Equivalent to [Area.x0], except the accessor returns the angle in radians,
  /// with 0 at -*y* (12 o’clock). Note: typically [angle] is used instead of
  /// setting separate start and end angles.
  num Function(T, int, List<T>) get startAngle => _x0;
  set startAngle(num Function(T, int, List<T>) startAngle) => _x0 = startAngle;

  /// Equivalent to [Area.x1], except the accessor returns the angle in radians,
  /// with 0 at -*y* (12 o’clock). Note: typically [angle] is used instead of
  /// setting separate start and end angles.
  num Function(T, int, List<T>)? get endAngle => _x1;
  set endAngle(num Function(T, int, List<T>)? endAngle) => _x1 = endAngle;

  /// Equivalent to [Area.y], except the accessor returns the radius: the
  /// distance from the origin.
  ///
  /// ```dart
  /// final area = AreaRadial(…)..radius = (d, i, data) => r(d["temperature"]);
  /// ```
  num Function(T, int, List<T>) get radius => _y0;
  set radius(num Function(T, int, List<T>) radius) {
    _y0 = radius;
    _y1 = null;
  }

  /// Equivalent to [Area.y0], except the accessor returns the radius: the
  /// distance from the origin.
  ///
  /// ```dart
  /// final area = AreaRadial(…)..innerRadius = (d, i, data) => r(d["low"]);
  /// ```
  num Function(T, int, List<T>) get innerRadius => _y0;
  set innerRadius(num Function(T, int, List<T>) innerRadius) =>
      _y0 = innerRadius;

  /// Equivalent to [Area.y1], except the accessor returns the radius: the
  /// distance from the origin.
  ///
  /// ```dart
  /// final area = AreaRadial(…)..outerRadius = (d, i, data) => r(d["high"]);
  /// ```
  num Function(T, int, List<T>)? get outerRadius => _y1;
  set outerRadius(num Function(T, int, List<T>)? outerRadius) =>
      _y1 = outerRadius;

  /// Defines the [AreaRadial.angle]-accessor as a constant function that always
  /// returns the specified value.
  void constAngle(num angle) {
    this.angle = constant(angle);
  }

  /// Defines the [AreaRadial.startAngle]-accessor as a constant function that
  /// always returns the specified value.
  void constStartAngle(num startAngle) {
    _x0 = constant(startAngle);
  }

  /// Defines the [AreaRadial.endAngle]-accessor as a constant function that
  /// always returns the specified value.
  void constEndAngle(num endAngle) {
    _x1 = constant(endAngle);
  }

  /// Defines the [AreaRadial.radius]-accessor as a constant function that
  /// always returns the specified value.
  void constRadius(num radius) {
    this.radius = constant(radius);
  }

  /// Defines the [AreaRadial.innerRadius]-accessor as a constant function that
  /// always returns the specified value.
  void constInnerRadius(num innerRadius) {
    _y0 = constant(innerRadius);
  }

  /// Defines the [AreaRadial.outerRadius]-accessor as a constant function that
  /// always returns the specified value.
  void constOuterRadius(num outerRadius) {
    _y1 = constant(outerRadius);
  }

  /// Returns a new
  /// [radial line generator](https://pub.dev/documentation/d4_shape/latest/topics/Radial%20lines-topic.html)
  /// that has this radial area generator’s current [defined] accessor, [curve]
  /// and [context]. The line’s angle accessor ([LineRadial.angle]) is this
  /// area’s [startAngle] accessor, and the line’s radius accessor
  /// ([LineRadial.radius]) is this area’s [innerRadius] accessor.
  LineRadial<T> lineStartAngle() => lineRadial(_lineX0(this));

  /// Returns a new
  /// [radial line generator](https://pub.dev/documentation/d4_shape/latest/topics/Radial%20lines-topic.html)
  /// that has this radial area generator’s current [defined] accessor, [curve]
  /// and [context]. The line’s angle accessor ([LineRadial.angle]) is this
  /// area’s [endAngle] accessor, and the line’s radius accessor
  /// ([LineRadial.radius]) is this area’s [innerRadius] accessor.
  LineRadial<T> lineEndAngle() => lineRadial(_lineX1(this));

  /// An alias for [AreaRadial.lineStartAngle].
  LineRadial<T> lineInnerRadius() => lineRadial(_lineY0(this));

  /// Returns a new
  /// [radial line generator](https://pub.dev/documentation/d4_shape/latest/topics/Radial%20lines-topic.html)
  /// that has this radial area generator’s current [defined] accessor, [curve]
  /// and [context]. The line’s angle accessor ([LineRadial.angle]) is this
  /// area’s [startAngle] accessor, and the line’s radius accessor
  /// ([LineRadial.radius]) is this area’s [outerRadius] accessor.
  LineRadial<T> lineOuterRadius() => lineRadial(_lineY1(this));

  /// Equivalent to [AreaRadial.defined].
  ///
  /// ```dart
  /// final area = AreaRadial(…)..defined = (d, i, data) => !d["temperature"].isNaN;
  /// ```
  @override
  get defined;

  /// Defines the [AreaRadial.defined]-accessor as a constant function that
  /// always returns the specified value.
  @override
  void constDefined(bool defined);

  /// Equivalent to [Area.curve].
  ///
  /// Note that [curveMonotoneX] or [curveMonotoneY] are not recommended for
  /// radial areas because they assume that the data is monotonic in *x* or *y*,
  /// which is typically untrue of radial areas.
  ///
  /// ```dart
  /// final area = AreaRadial(…)..curve = curveBasisClosed;
  /// ```
  @override
  get curve => _curve0;
  @override
  set curve(curve) => super._curve = curveRadial(_curve0 = curve);

  /// Equivalent to [Area.context].
  ///
  /// ```dart
  /// final context = …;
  /// final area = AreaRadial(…)..context = context;
  ///
  /// area.context; // context
  /// ```
  @override
  get context;

  /// Equivalent to [Area.digits].
  ///
  /// ```dart
  /// final area = AreaRadial(…)..digits = 3;
  ///
  /// area.digits; // 3
  /// ```
  @override
  get digits;

  /// Equivalent to [AreaRadial.new], except that if [startAngle], [innerRadius]
  /// or [outerRadius] are not specified, the respective defaults will be used.
  static AreaRadial<List<num>> withDefaults(
      {num Function(List<num>, int, List<List<num>>) startAngle = pointX,
      num Function(List<num>, int, List<List<num>>)? innerRadius,
      num Function(List<num>, int, List<List<num>>) outerRadius = pointY}) {
    return AreaRadial<List<num>>(
        startAngle: startAngle,
        innerRadius: innerRadius,
        outerRadius: outerRadius);
  }
}

AreaRadial<T> areaRadial<T>(Area<T> a) {
  return AreaRadial(startAngle: a.x0, innerRadius: a.y0, outerRadius: a.y1)
    ..defined = a.defined
    .._curve = a._curve
    ..context = a.context
    ..endAngle = a.x1;
}
