import 'package:d4_path/d4_path.dart';

import 'constant.dart';
import 'curve/cardinal.dart';
import 'curve/curve.dart';
import 'curve/linear.dart';
import 'curve/monotone.dart';
import 'curve/radial.dart';
import 'digits.dart';
import 'point.dart';

part 'line_radial.dart';

sealed class LineBase<T> with Digits {
  bool Function(T, int, List<T>) defined = constant(true);
  Path? _context;
  CurveFactory _curve = curveLinear;
  Curve? _output;

  num Function(T, int, List<T>) _x, _y;

  LineBase(num Function(T, int, List<T>) x, num Function(T, int, List<T>) y)
      : _x = x,
        _y = y;

  String? call(List<T> data) {
    var n = data.length, defined0 = false;
    late T d;
    Path? buffer;

    if (_context == null) _output = _curve(buffer = path());

    for (var i = 0; i <= n; ++i) {
      if (!(i < n && defined(d = data[i], i, data)) == defined0) {
        if (defined0 = !defined0) {
          _output!.lineStart();
        } else {
          _output!.lineEnd();
        }
      }
      if (defined0) _output!.point(_x(d, i, data), _y(d, i, data));
    }

    if (buffer != null) {
      _output = null;
      final s = buffer.toString();
      return s.isEmpty ? null : s;
    }
    return null;
  }

  void constDefined(bool defined) {
    this.defined = constant(defined);
  }

  CurveFactory get curve => _curve;
  set curve(CurveFactory curve) {
    _curve = curve;
    if (_context != null) _output = _curve(_context!);
  }

  Path? get context => _context;
  set context(Path? context) {
    context == null
        ? _context = _output = null
        : _output = curve(_context = context);
  }
}

/// The line generator produces a
/// [spline](https://en.wikipedia.org/wiki/Spline_(mathematics)) or
/// [polyline](https://en.wikipedia.org/wiki/Polygonal_chain) as in a line
/// chart.
///
/// Lines also appear in many other visualization types, such as the links in
/// [hierarchical edge bundling](https://observablehq.com/@d3/hierarchical-edge-bundling).
/// See also [radial lines](https://pub.dev/documentation/d4_shape/latest/topics/Radial%20lines-topic.html).
///
/// {@category Lines}
class Line<T> extends LineBase<T> {
  /// Constructs a new line generator with the given [x] and [y] accessor.
  ///
  /// ```dart
  /// final line = Line(
  ///   (d, i, data) => x(d["Date"]),
  ///   (d, i, data) => y(d["Close"]),
  /// );
  /// ```
  Line(super.x, super.y);

  /// Constructs a new line generator with the given [x] and [y] numbers.
  Line.withConstants(num x, num y) : super(constant(x), constant(y));

  /// Generates a line for the given list of [data].
  ///
  /// ```dart
  /// svg.append("path").attr("d", line(data)).attr("stroke", "currentColor");
  /// ```
  ///
  /// If the line generator has a [context], then the line is rendered to this
  /// context as a sequence of
  /// [path method](http://www.w3.org/TR/2dcontext/#canvaspathmethods) calls and
  /// this function returns void. Otherwise, a
  /// [path data](http://www.w3.org/TR/SVG/paths.html#PathData) string is
  /// returned.
  ///
  /// **CAUTION**: Depending on this line generator’s associated [curve], the
  /// given input data may need to be sorted by *x*-value before being passed to
  /// the line generator.
  @override
  call(data);

  /// When a line is generated (see [Line.call]), the x accessor will be
  /// invoked for each [defined] element in the input data list, being passed
  /// the element `d`, the index `i`, and the list `data` as three arguments.
  ///
  /// ```dart
  /// final line = Line(…)..x = (d, i, data) => x(d["Date"]);
  ///
  /// line.x; // (d, i, data) => x(d["Date"])
  /// ```
  ///
  /// The x accessor defaults to:
  ///
  /// ```dart
  /// x(d, i, data) {
  ///   return d[0];
  /// }
  /// ```
  ///
  /// The default x accessor assumes that the input data are two-element
  /// lists of numbers \[\[x0, y0\], \[x1, y1\], …\]. If your data are in a
  /// different format, or if you wish to transform the data before rendering,
  /// then you should specify a custom accessor as shown above.
  num Function(T, int, List<T>) get x => super._x;
  set x(num Function(T, int, List<T>) x) => super._x = x;

  /// When a line is generated (see [Line.call]), the y accessor will be
  /// invoked for each [defined] element in the input data list, being passed
  /// the element `d`, the index `i`, and the list `data` as three arguments.
  ///
  /// ```dart
  /// final line = Line(…)..y = (d, i, data) => y(d["Close"]);
  ///
  /// line.y; // (d, i, data) => y(d["Close"])
  /// ```
  ///
  /// The y accessor defaults to:
  ///
  /// ```dart
  /// y(d, i, data) {
  ///   return d[1];
  /// }
  /// ```
  ///
  /// The default y accessor assumes that the input data are two-element
  /// lists of numbers \[\[x0, y0\], \[x1, y1\], …\]. If your data are in a
  /// different format, or if you wish to transform the data before rendering,
  /// then you should specify a custom accessor as shown above.
  num Function(T, int, List<T>) get y => super._y;
  set y(num Function(T, int, List<T>) y) => super._y = y;

  /// Defines the [Line.x]-accessor as a constant function that always returns
  /// the specified value.
  void constX(num x) {
    _x = constant(x);
  }

  /// Defines the [Line.y]-accessor as a constant function that always returns
  /// the specified value.
  void constY(num y) {
    _y = constant(y);
  }

  /// When a line is generated (see [Line.call]), the defined accessor will be
  /// invoked for each element in the input data list, being passed the element
  /// `d`, the index `i`, and the list `data` as three arguments.
  ///
  /// ```dart
  /// final line = Line(…)..defined = (d, i, data) => !d["Close"].isNaN;
  ///
  /// line.defined; // (d, i, data) => !d["Close"].isNaN;
  /// ```
  ///
  /// If the given element is defined (*i.e.*, if the defined accessor returns a
  /// truthy value for this element), the [x] and [y] accessors will
  /// subsequently be evaluated and the point will be added to the current
  /// line segment. Otherwise, the element will be skipped, the current line
  /// segment will be ended, and a new line segment will be generated for the
  /// next defined point.
  ///
  /// The defined accessor defaults to the constant true, and assumes that the
  /// input data is always defined:
  ///
  /// ```dart
  /// defined(d, i, data) {
  ///   return true;
  /// }
  /// ```
  ///
  /// Note that if a line segment consists of only a single point, it may
  /// appear invisible unless rendered with rounded or square
  /// [line caps](https://developer.mozilla.org/en-US/docs/Web/SVG/Attribute/stroke-linecap).
  /// In addition, some curves such as [curveCardinalOpen] only render a visible
  /// segment if it contains multiple points.
  @override
  get defined;

  /// Defines the [Line.defined]-accessor as a constant function that always
  /// returns the specified value.
  @override
  constDefined(defined);

  /// The
  /// [curve factory](https://pub.dev/documentation/d4_shape/latest/topics/Curves-topic.html).
  ///
  /// ```dart
  /// final line = Line(…)..curve = curveStep;
  ///
  /// line.curve; // curveStep
  /// ```
  ///
  /// Defaults to [curveLinear].
  @override
  get curve;

  /// Optional context for rendering the generated line (see [Line.call]) as a
  /// sequence of
  /// [path method](http://www.w3.org/TR/2dcontext/#canvaspathmethods) calls.
  ///
  /// ```dart
  /// final context = …;
  /// final line = Line(…)..context = context;
  ///
  /// line.context; // context
  /// ```
  ///
  /// Defaults to null, which means the generated line is returned as a
  /// [path data](http://www.w3.org/TR/SVG/paths.html#PathData)
  /// string.
  @override
  get context;

  /// The maximum number of digits after the decimal separator.
  ///
  /// ```dart
  /// final line = Line(…)..digits = 3;
  ///
  /// line.digits; // 3
  /// ```
  ///
  /// This option only applies when the associated [context] is null, as when
  /// this line generator is used to produce
  /// [path data](http://www.w3.org/TR/SVG/paths.html#PathData).
  @override
  get digits;

  /// Equivalent to [Line.new], except that if [x] or [y] are not specified, the
  /// respective defaults will be used.
  static Line<List<num>> withDefaults(
      {num Function(List<num>, int, List<List<num>>) x = pointX,
      num Function(List<num>, int, List<List<num>>) y = pointY}) {
    return Line<List<num>>(x, y);
  }
}
