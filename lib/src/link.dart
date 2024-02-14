import 'package:d4_path/d4_path.dart';

import 'constant.dart';
import 'curve/bump.dart';
import 'curve/curve.dart';
import 'digits.dart';
import 'point.dart';

List<num> linkSource(_, [List<Object?>? args]) {
  return (args![0] as Map)["source"];
}

List<num> linkTarget(_, [List<Object?>? args]) {
  return (args![0] as Map)["target"];
}

sealed class _LinkBase<T, L extends _LinkBase<T, L>> with Digits {
  /// The source accessor.
  ///
  /// ```dart
  /// final link = Link.horizontal(…)..source = (thisArg, [args]) => args[0][0];
  ///
  /// link.source; // (thisArg, [args]) => args[0][0]
  /// ```
  ///
  /// The source accessor defaults to:
  ///
  /// ```dart
  /// source(thisArg, [args]) {
  ///   args[0]["source"];
  /// }
  /// ```
  T Function(L, [List<Object?>?]) source;

  /// The target accessor.
  ///
  /// ```dart
  /// final link = Link.horizontal(…)..target = (thisArg, [args]) => args[0][1];
  ///
  /// link.target; // (thisArg, [args]) => args[0][1]
  /// ```
  ///
  /// The target accessor defaults to:
  ///
  /// ```dart
  /// target(thisArg, [args]) {
  ///   args[0]["target"];
  /// }
  /// ```
  T Function(L, [List<Object?>?]) target;
  num Function(T, [List<Object?>?]) _x, _y;
  Path? _context;
  Curve? _output;

  CurveFactory _curve;

  _LinkBase(CurveFactory curve, this.source, this.target, this._x, this._y)
      : _curve = curve;

  String? call([List<Object?>? args]) {
    Path? buffer;
    args = List.of(args ?? []);
    final s = source(this as L, args);
    final t = target(this as L, args);
    if (_context == null) _output = _curve(buffer = path());
    _output!.lineStart();
    _output!.point(_x(s, args), _y(s, args));
    _output!.point(_x(t, args), _y(t, args));
    _output!.lineEnd();
    if (buffer != null) {
      _output = null;
      final s = buffer.toString();
      return s.isEmpty ? null : s;
    }
    return null;
  }

  Path? get context => _context;
  set context(Path? context) {
    context == null
        ? _context = _output = null
        : _output = _curve(_context = context);
  }
}

/// The link shape generates a smooth cubic Bézier curve from a source point to
/// a target point.
///
/// The tangents of the curve at the start and end are either vertical (see
/// [Link.vertical]) or horizontal (see [Link.horizontal]). See also radial
/// links.
///
/// {@category Links}
class Link<T> extends _LinkBase<T, Link<T>> {
  /// Constructs a new link generator using the specified [curve] and the given
  /// [source], [target], [x] and [y] accessors.
  ///
  /// For example, to visualize links in a tree diagram rooted on the top edge
  /// of the display, you might say:
  ///
  /// ```dart
  /// final link = Link(
  ///   curveBumpY,
  ///   (thisArg, [args]) => args[0]["source"],
  ///   (thisArg, [args]) => args[0]["target"],
  ///   (d, [args]) => d["x"],
  ///   (d, [args]) => d["y"],
  /// );
  Link(
      CurveFactory curve,
      T Function(Link<T>, [List<Object?>?]) source,
      T Function(Link<T>, [List<Object?>?]) target,
      num Function(T, [List<Object?>?]) x,
      num Function(T, [List<Object?>?]) y)
      : super(curve, source, target, x, y);

  /// Shorthand for [Link.new] with [curveBumpX]; suitable for visualizing links
  /// in a tree diagram rooted on the top edge of the display.
  ///
  /// Equivalent to:
  ///
  /// ```dart
  /// final link = Link(curveBumpX, …);
  /// ```
  Link.horizontal(
      T Function(Link<T>, [List<Object?>?]) source,
      T Function(Link<T>, [List<Object?>?]) target,
      num Function(T, [List<Object?>?]) x,
      num Function(T, [List<Object?>?]) y)
      : super(curveBumpX, source, target, x, y);

  /// Shorthand for [Link.new] with [curveBumpY]; suitable for visualizing links
  /// in a tree diagram rooted on the top edge of the display.
  ///
  /// Equivalent to:
  ///
  /// ```dart
  /// final link = Link(curveBumpY, …);
  /// ```
  Link.vertical(
      T Function(Link<T>, [List<Object?>?]) source,
      T Function(Link<T>, [List<Object?>?]) target,
      num Function(T, [List<Object?>?]) x,
      num Function(T, [List<Object?>?]) y)
      : super(curveBumpY, source, target, x, y);

  /// Generates a link for the given [args].
  ///
  /// ```dart
  /// link([{"source": [100, 100], "target": [300, 300]}]) // "M100,100C200,100,200,300,300,300"
  /// ```
  ///
  /// The [args] are arbitrary; they are propagated to the link generator’s
  /// accessor functions along with the `this` object. With the default
  /// settings, an object with *source* and *target* properties is expected
  /// in the first position.
  @override
  call([List<Object?>? args]);

  /// The *x*-accessor.
  ///
  /// ```dart
  /// final link = Link.horizontal(…)..x = (d, [args]) => x(d["x"]);
  ///
  /// link.x; // (d, [args]) => x(d["x"])
  /// ```
  ///
  /// The x accessor defaults to:
  ///
  /// ```dart
  /// x(d, [args]) {
  ///   return d[0];
  /// }
  /// ```
  set x(num Function(T, [List<Object?>?]) x) => _x = x;
  num Function(T, [List<Object?>?]) get x => _x;

  /// The *y*-accessor.
  ///
  /// ```dart
  /// final link = Link.horizontal(…)..y = (d, [args]) => y(d["y"]);
  ///
  /// link.y; // (d, [args]) => y(d["y"])
  /// ```
  ///
  /// The x accessor defaults to:
  ///
  /// ```dart
  /// y(d, [args]) {
  ///   return d[1];
  /// }
  /// ```
  set y(num Function(T, [List<Object?>?]) y) => _y = y;
  num Function(T, [List<Object?>?]) get y => _y;

  /// Defines the [Link.x]-accessor as a constant function that always returns
  /// the specified value.
  void constX(num x) {
    _x = constant(x);
  }

  /// Defines the [Link.y]-accessor as a constant function that always returns
  /// the specified value.
  void constY(num y) {
    _y = constant(y);
  }

  /// Optional context for rendering the generated link (see [Link.call]) as a
  /// sequence of
  /// [path method](http://www.w3.org/TR/2dcontext/#canvaspathmethods) calls.
  ///
  /// ```dart
  /// final context = …;
  /// final link = Link(…)..context = context;
  ///
  /// link.context; // context
  /// ```
  ///
  /// Defaults to null, which means the generated link is returned as a
  /// [path data](http://www.w3.org/TR/SVG/paths.html#PathData)
  /// string.
  @override
  get context;

  /// The maximum number of digits after the decimal separator.
  ///
  /// ```dart
  /// final link = Link(…)..digits = 3;
  ///
  /// link.digits; // 3
  /// ```
  ///
  /// This option only applies when the associated [context] is null, as when
  /// this link generator is used to produce
  /// [path data](http://www.w3.org/TR/SVG/paths.html#PathData).
  @override
  get digits;

  /// Equivalent to [Link.new], except that if [source], [target], [x], [y] are
  /// not specified, the respective defaults will be used.
  static Link<List<num>> withDefaults(
      {required CurveFactory curve,
      List<num> Function(Link<List<num>>, [List<Object?>?]) source = linkSource,
      List<num> Function(Link<List<num>>, [List<Object?>?]) target = linkTarget,
      num Function(List<num>, [List<Object?>?]) x = pointX,
      num Function(List<num>, [List<Object?>?]) y = pointY}) {
    return Link(curve, source, target, x, y);
  }

  /// Equivalent to [Link.horizontal], except that if [source], [target], [x],
  /// [y] are not specified, the respective defaults will be used.
  static Link<List<num>> horizontalWithDefaults(
      {List<num> Function(Link<List<num>>, [List<Object?>?]) source =
          linkSource,
      List<num> Function(Link<List<num>>, [List<Object?>?]) target = linkTarget,
      num Function(List<num>, [List<Object?>?]) x = pointX,
      num Function(List<num>, [List<Object?>?]) y = pointY}) {
    return Link.horizontal(source, target, x, y);
  }

  /// Equivalent to [Link.vertical], except that if [source], [target], [x],
  /// [y] are not specified, the respective defaults will be used.
  static Link<List<num>> verticalWithDefaults(
      {List<num> Function(Link<List<num>>, [List<Object?>?]) source =
          linkSource,
      List<num> Function(Link<List<num>>, [List<Object?>?]) target = linkTarget,
      num Function(List<num>, [List<Object?>?]) x = pointX,
      num Function(List<num>, [List<Object?>?]) y = pointY}) {
    return Link.vertical(source, target, x, y);
  }
}

/// A radial link generator is like the Cartesian
/// [link generator](https://pub.dev/documentation/d4_shape/latest/topics/Links-topic.html)
/// except the [Link.x] and [Link.y] accessors are replaced with [angle] and
/// [radius] accessors.
///
/// Radial links are positioned relative to the origin; use a
/// [transform](http://www.w3.org/TR/SVG/coords.html#TransformAttribute) to
/// change the origin.
///
/// {@category Radial links}
class LinkRadial<T> extends _LinkBase<T, LinkRadial<T>> {
  /// Constructs a new link generator with radial tangents using the given
  /// [source], [target], [angle] and [radius] accessors.
  ///
  /// For example, to visualize links in a tree diagram rooted on the top edge
  /// of the display, you might say:
  ///
  /// ```dart
  /// final link = LinkRadial(
  ///   (thisArg, [args]) => args[0]["source"],
  ///   (thisArg, [args]) => args[0]["target"],
  ///   (d, [args]) => d["x"],
  ///   (d, [args]) => d["y"],
  /// );
  /// ```
  LinkRadial(
      T Function(LinkRadial<T>, [List<Object?>?]) source,
      T Function(LinkRadial<T>, [List<Object?>?]) target,
      num Function(T, [List<Object?>?]) angle,
      num Function(T, [List<Object?>?]) radius)
      : super(curveBumpRadial, source, target, angle, radius);

  /// Returns a new link generator (see [Link.call]) with radial tangents.
  ///
  /// For example, to visualize links in a tree diagram rooted in the center of
  /// the display, you might say:
  ///
  /// ```dart
  /// final link = LinkRadial(
  ///   (thisArg, [args]) => args[0]["source"],
  ///   (thisArg, [args]) => args[0]["target"],
  ///   (d, [args]) => d["x"],
  ///   (d, [args]) => d["y"],
  /// );
  /// ```
  @override
  call([List<Object?>? args]);

  /// Equivalent to [Link.x], except the accessor returns the angle in radians,
  /// with 0 at -*y* (12 o’clock).
  set angle(num Function(T, [List<Object?>?]) angle) => _x = angle;
  num Function(T, [List<Object?>?]) get angle => _x;

  /// Equivalent to [Link.y], except the accessor returns the radius: the
  /// distance from the origin.
  set radius(num Function(T, [List<Object?>?]) radius) => _y = radius;
  num Function(T, [List<Object?>?]) get radius => _y;

  /// Defines the [LinkRadial.angle]-accessor as a constant function that always
  /// returns the specified value.
  void constAngle(num angle) {
    _x = constant(angle);
  }

  /// Defines the [LinkRadial.radius]-accessor as a constant function that
  /// always returns the specified value.
  void constRadius(num radius) {
    _y = constant(radius);
  }

  /// Equivalent to [Link.context].
  ///
  /// ```dart
  /// final context = …;
  /// final link = LinkRadial(…)..context = context;
  ///
  /// link.context; // context
  /// ```
  @override
  get context;

  /// Equivalent to [Link.digits].
  ///
  /// ```dart
  /// final link = LinkRadial(…)..digits = 3;
  ///
  /// link.digits; // 3
  /// ```
  @override
  get digits;

  /// Equivalent to [LinkRadial.new], except that if [source], [target],
  /// [angle], [radius] are not specified, the respective defaults will be used.
  static LinkRadial<List<num>> withDefaults(
      {List<num> Function(LinkRadial<List<num>>, [List<Object?>?]) source =
          linkSource,
      List<num> Function(LinkRadial<List<num>>, [List<Object?>?]) target =
          linkTarget,
      num Function(List<num>, [List<Object?>?]) angle = pointX,
      num Function(List<num>, [List<Object?>?]) radius = pointY}) {
    return LinkRadial(source, target, angle, radius);
  }
}
