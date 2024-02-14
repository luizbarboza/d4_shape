import 'package:d4_path/d4_path.dart';

import 'constant.dart';
import 'curve/cardinal.dart';
import 'curve/curve.dart';
import 'curve/linear.dart';
import 'curve/monotone.dart';
import 'curve/radial.dart';
import 'digits.dart';
import 'line.dart';
import 'point.dart';

part 'area_radial.dart';

sealed class AreaBase<T> with Digits {
  bool Function(T, int, List<T>) defined = constant(true);
  Path? _context;
  CurveFactory _curve = curveLinear;
  Curve? _output;

  num Function(T, int, List<T>) _x0, _y0;
  num Function(T, int, List<T>)? _x1, _y1;

  AreaBase(
      {required num Function(T, int, List<T>) x,
      num Function(T, int, List<T>)? y0,
      required num Function(T, int, List<T>)? y1})
      : _x0 = x,
        _y0 = y0 ?? constant(0) as dynamic,
        _y1 = y1;

  String? call(List<T> data) {
    var n = data.length, defined0 = false;
    late int j;
    late T d;
    Path? buffer;
    List<num> x0z = List.filled(n, 0), y0z = List.filled(n, 0);

    if (_context == null) _output = _curve(buffer = path());

    for (var i = 0; i <= n; ++i) {
      if (!(i < n && defined(d = data[i], i, data)) == defined0) {
        if (defined0 = !defined0) {
          j = i;
          _output!.areaStart();
          _output!.lineStart();
        } else {
          _output!.lineEnd();
          _output!.lineStart();
          for (var k = i - 1; k >= j; --k) {
            _output!.point(x0z[k], y0z[k]);
          }
          _output!.lineEnd();
          _output!.areaEnd();
        }
      }
      if (defined0) {
        x0z[i] = _x0(d, i, data);
        y0z[i] = _y0(d, i, data);
        _output!.point(_x1 != null ? _x1!(d, i, data) : x0z[i],
            _y1 != null ? _y1!(d, i, data) : y0z[i]);
      }
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
        : _output = _curve(_context = context);
  }
}

/// The area generator produces an area defined by a *topline* and a *baseline*
/// as in an area chart.
///
/// Typically, the two lines share the same *[x]*-values ([x0] = [x1]),
/// differing only in *[y]*-value ([y0] and [y1]); most commonly, y0 is defined
/// as a constant representing zero (the y scale’s output for zero). The
/// *topline* is defined by x1 and y1 and is rendered first; the *baseline* is
/// defined by x0 and y0 and is rendered second with the points in reverse
/// order. With a [curveLinear]\ [curve], this produces a clockwise polygon. See
/// also
///[radial areas](https://pub.dev/documentation/d4_shape/latest/topics/Radial%20areas-topic.html).
///
/// {@category Areas}
class Area<T> extends AreaBase<T> {
  /// Constructs a new area generator with the given [x], [y0], and [y1]
  /// accessors.
  ///
  /// ```dart
  /// final area = Area(
  ///   (d, i, data) => x(d["Date"]),
  ///   (d, i, data) => y(0),
  ///   (d, i, data) => y(d["Close"]),
  /// );
  /// ```
  Area({required super.x, super.y0, required super.y1});

  /// Constructs a new area generator with the given [x], [y0], and [y1]
  /// numbers.
  Area.withConstants({required num x, num? y0, required num? y1})
      : super(
            x: constant(x),
            y0: constant(y0 ?? 0),
            y1: y1 != null ? constant(y1) : null);

  /// Generates an area for the given list of [data].
  ///
  /// ```dart
  /// svg.append("path").attr("d", area(data));
  /// ```
  ///
  /// If the area generator has a [context], then the area is rendered to this
  /// context as a sequence of
  /// [path method](http://www.w3.org/TR/2dcontext/#canvaspathmethods) calls and
  /// this function returns void. Otherwise, a
  /// [path data](http://www.w3.org/TR/SVG/paths.html#PathData) string is
  /// returned.
  ///
  /// **CAUTION**: Depending on this area generator’s associated [curve], the
  /// given input [data] may need to be sorted by *x*-value before being passed
  /// to the area generator.
  @override
  call(data);

  /// Alias for [x0], but additionally sets [x1] to null when defined.
  ///
  /// ```dart
  /// final area = Area(…)..x = (d, i, data) => x(d["Date"]);
  ///
  /// area.x; // (d, i, data) => x(d["Date"])
  /// ```
  num Function(T, int, List<T>) get x => _x0;
  set x(num Function(T, int, List<T>) x) {
    _x0 = x;
    _x1 = null;
  }

  /// When an area is generated (see [Area.call]), the x0 accessor will be
  /// invoked for each [defined] element in the input data list, being passed
  /// the element `d`, the index `i`, and the list `data` as three arguments.
  ///
  /// **TIP**: This method is intended for vertically-oriented areas, as when
  /// time goes down↓ rather than right→; for the more common
  /// horizontally-oriented areas, use [x] instead.
  ///
  /// ```dart
  /// final area = Area(…)..x0 = (d, i, data) => x(0);
  ///
  /// area.x0; // (d, i, data) => 20
  /// ```
  ///
  /// The x0 accessor defaults to:
  ///
  /// ```dart
  /// x(d, i, data) {
  ///   return d[0];
  /// }
  /// ```
  ///
  /// The default x0 accessor assumes that the input data are two-element
  /// lists of numbers \[\[x0, y0\], \[x1, y1\], …\]. If your data are in a
  /// different format, or if you wish to transform the data before rendering,
  /// then you should specify a custom accessor as shown above.
  num Function(T, int, List<T>) get x0 => _x0;
  set x0(num Function(T, int, List<T>) x0) => _x0 = x0;

  /// When an area is generated (see [Area.call]), the x1 accessor will be
  /// invoked for each [defined] element in the input data list, being passed
  /// the element `d`, the index `i`, and the list `data` as three arguments.
  ///
  /// **TIP**: This method is intended for vertically-oriented areas, as when
  /// time goes down↓ rather than right→; for the more common
  /// horizontally-oriented areas, use [x] instead.
  ///
  /// ```dart
  /// final area = Area(…)..x1 = (d, i, data) => x(d["Close"]);
  ///
  /// area.x1; // (d, i, data) => d["Close"]
  /// ```
  ///
  /// The x1 accessor defaults to null, indicating that the previously-computed
  /// [x0] value should be reused for the x1 value; this default is intended for
  /// horizontally-oriented areas.
  num Function(T, int, List<T>)? get x1 => _x1;
  set x1(num Function(T, int, List<T>)? x1) => _x1 = x1;

  /// Alias for [y0], but additionally sets [y1] to null when defined.
  ///
  /// **TIP**: This method is intended for vertically-oriented areas, as when
  /// time goes down↓ rather than right→; for the more common
  /// horizontally-oriented areas, use [y0] and [y1] instead.
  ///
  /// ```dart
  /// final area = Area(…)..y = (d, i, data) => y(d["Date"]);
  ///
  /// area.y; // (d, i, data) => y(d["Date"])
  /// ```
  num Function(T, int, List<T>) get y => _y0;
  set y(num Function(T, int, List<T>) y) {
    _y0 = y;
    _y1 = null;
  }

  /// When an area is generated (see [Area.call]), the y0 accessor will be
  /// invoked for each [defined] element in the input data list, being passed
  /// the element `d`, the index `i`, and the list `data` as three arguments.
  ///
  /// For a horizontally-oriented area with a constant baseline (*i.e.*, an area
  /// that is not stacked, and not a ribbon or band), y0 is typically set to the
  /// output of the y scale for zero.
  ///
  /// ```dart
  /// final area = Area(…)..y0 = (d, i, data) => y(0);
  ///
  /// area.y0; // (d, i, data) => 360
  /// ```
  ///
  /// The y0 accessor defaults to:
  ///
  /// ```dart
  /// y(d, i, data) {
  ///   return 0;
  /// }
  /// ```
  ///
  /// In the default SVG coordinate system, note that the default zero
  /// represents the top of the chart rather than the bottom, producing a
  /// flipped (or “hanging”) area.
  num Function(T, int, List<T>) get y0 => _y0;
  set y0(num Function(T, int, List<T>) y0) => _y0 = y0;

  /// When an area is generated (see [Area.call]), the y1 accessor will be
  /// invoked for each [defined] element in the input data list, being passed
  /// the element `d`, the index `i`, and the list `data` as three arguments.
  ///
  /// ```dart
  /// final area = Area(…)..y1 = (d, i, data) => y(d["Close"]);
  ///
  /// area.y1; // (d, i, data) => y(d["Close"])
  /// ```
  ///
  /// The y1 accessor defaults to:
  ///
  /// ```dart
  /// y(d, i, data) {
  ///   return d[1];
  /// }
  /// ```
  ///
  /// The default y1 accessor assumes that the input data are two-element lists
  /// of numbers \[\[x0, y0\], \[x1, y1\], …\]. If your data are in a different
  /// format, or if you wish to transform the data before rendering, then you
  /// should specify a custom accessor as shown above. A null accessor is also
  /// allowed, indicating that the previously-computed [y0] value should be
  /// reused for the y1 value; this can be used for a vertically-oriented area,
  /// as when time goes down↓ instead of right→.
  num Function(T, int, List<T>)? get y1 => _y1;
  set y1(num Function(T, int, List<T>)? y1) => _y1 = y1;

  /// Defines the [Area.x]-accessor as a constant function that always returns
  /// the specified value.
  void constX(num x) {
    this.x = constant(x);
  }

  /// Defines the [Area.x0]-accessor as a constant function that always returns
  /// the specified value.
  void constX0(num x0) {
    _x0 = constant(x0);
  }

  /// Defines the [Area.x1]-accessor as a constant function that always returns
  /// the specified value.
  void constX1(num x1) {
    _x1 = constant(x1);
  }

  /// Defines the [Area.y]-accessor as a constant function that always returns
  /// the specified value.
  void constY(num y) {
    this.y = constant(y);
  }

  /// Defines the [Area.y0]-accessor as a constant function that always returns
  /// the specified value.
  void constY0(num y0) {
    _y0 = constant(y0);
  }

  /// Defines the [Area.y1]-accessor as a constant function that always returns
  /// the specified value.
  void constY1(num y1) {
    _y1 = constant(y1);
  }

  /// An alias for [lineY0].
  Line<T> lineX0() => _lineX0(this);

  /// Returns a new
  /// [line generator](https://pub.dev/documentation/d4_shape/latest/topics/Lines-topic.html)
  /// that has this area generator’s current [defined] accessor, [curve] and
  /// [context]. The line’s
  /// *[x](https://pub.dev/documentation/d4_shape/latest/d4_shape/Line/x.html)*-accessor
  /// is this area’s *[x0]*-accessor, and the line’s
  /// *[y](https://pub.dev/documentation/d4_shape/latest/d4_shape/Line/y.html)*-accessor
  /// is this area’s *[y0]*-accessor.
  Line<T> lineY0() => _lineY0(this);

  /// Returns a new
  /// [line generator](https://pub.dev/documentation/d4_shape/latest/topics/Lines-topic.html)
  /// that has this area generator’s current [defined] accessor, [curve] and
  /// [context]. The line’s
  /// *[x](https://pub.dev/documentation/d4_shape/latest/d4_shape/Line/x.html)*-accessor
  /// is this area’s *[x0]*-accessor, and the line’s
  /// *[y](https://pub.dev/documentation/d4_shape/latest/d4_shape/Line/y.html)*-accessor
  /// is this area’s *[y1]*-accessor.
  Line<T> lineY1() => _lineY1(this);

  /// Returns a new
  /// [line generator](https://pub.dev/documentation/d4_shape/latest/topics/Lines-topic.html)
  /// that has this area generator’s current [defined] accessor, [curve] and
  /// [context]. The line’s
  /// *[x](https://pub.dev/documentation/d4_shape/latest/d4_shape/Line/x.html)*-accessor
  /// is this area’s *[x1]*-accessor, and the line’s
  /// *[y](https://pub.dev/documentation/d4_shape/latest/d4_shape/Line/y.html)*-accessor
  /// is this area’s *[y0]*-accessor.
  Line<T> lineX1() => _lineX1(this);

  /// When an area is generated (see [Area.call]), the defined accessor will be
  /// invoked for each element in the input data list, being passed the element
  /// `d`, the index `i`, and the list `data` as three arguments.
  ///
  /// ```dart
  /// final area = Area(…)..defined = (d, i, data) => !d["Close"].isNaN;
  ///
  /// area.defined; // (d, i, data) => !d["Close"].isNaN;
  /// ```
  ///
  /// If the given element is defined (*i.e.*, if the defined accessor returns a
  /// truthy value for this element), the [x0], [x1], [y0] and [y1] accessors
  /// will subsequently be evaluated and the point will be added to the current
  /// area segment. Otherwise, the element will be skipped, the current area
  /// segment will be ended, and a new area segment will be generated for the
  /// next defined point. As a result, the generated area may have several
  /// discrete segments.
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
  /// Note that if an area segment consists of only a single point, it may
  /// appear invisible unless rendered with rounded or square
  /// [line caps](https://developer.mozilla.org/en-US/docs/Web/SVG/Attribute/stroke-linecap).
  /// In addition, some curves such as [curveCardinalOpen] only render a visible
  /// segment if it contains multiple points.
  @override
  get defined;

  /// Defines the [Area.defined]-accessor as a constant function that always
  /// returns the specified value.
  @override
  void constDefined(bool defined);

  /// The
  /// [curve factory](https://pub.dev/documentation/d4_shape/latest/topics/Curves-topic.html).
  ///
  /// ```dart
  /// final area = Area(…)..curve = curveStep;
  ///
  /// area.curve; // curveStep
  /// ```
  ///
  /// Defaults to [curveLinear].
  @override
  get curve;

  /// Optional context for rendering the generated area (see [Area.call]) as a
  /// sequence of
  /// [path method](http://www.w3.org/TR/2dcontext/#canvaspathmethods) calls.
  ///
  /// ```dart
  /// final context = …;
  /// final area = Area(…)..context = context;
  ///
  /// area.context; // context
  /// ```
  ///
  /// Defaults to null, which means the generated area is returned as a
  /// [path data](http://www.w3.org/TR/SVG/paths.html#PathData)
  /// string.
  @override
  get context;

  /// The maximum number of digits after the decimal separator.
  ///
  /// ```dart
  /// final area = Area(…)..digits = 3;
  ///
  /// area.digits; // 3
  /// ```
  ///
  /// This option only applies when the associated [context] is null, as when
  /// this area generator is used to produce
  /// [path data](http://www.w3.org/TR/SVG/paths.html#PathData).
  @override
  get digits;

  /// Equivalent to [Area.new], except that if [x], [y0] or [y1] are not
  /// specified, the respective defaults will be used.
  static Area<List<num>> withDefaults(
      {num Function(List<num>, int, List<List<num>>) x = pointX,
      num Function(List<num>, int, List<List<num>>)? y0,
      num Function(List<num>, int, List<List<num>>) y1 = pointY}) {
    return Area<List<num>>(x: x, y0: y0, y1: y1);
  }
}

Line<T> _arealine<T>(AreaBase<T> a, num Function(T, int, List<T>) x,
    num Function(T, int, List<T>) y) {
  return Line<T>(x, y)
    ..defined = a.defined
    ..curve = a.curve
    ..context = a.context;
}

Line<T> _lineX0<T>(AreaBase<T> a) => _lineY0(a);

Line<T> _lineY0<T>(AreaBase<T> a) => _arealine(a, a._x0, a._y0);

Line<T> _lineY1<T>(AreaBase<T> a) {
  if (a._y1 == null) throw StateError("y1-accessor is null");
  return _arealine(a, a._x0, a._y1!);
}

Line<T> _lineX1<T>(AreaBase<T> a) {
  if (a._x1 == null) throw StateError("x1-accessor is null");
  return _arealine(a, a._x1!, a._y0);
}
