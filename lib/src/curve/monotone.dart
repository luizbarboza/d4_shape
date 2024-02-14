// Calculate the slopes of the tangents (Hermite-type interpolation) based on
// the following paper: Steffen, M. 1990. A Simple Method for Monotonic
// Interpolation in One Dimension. Astronomy and Astrophysics, Vol. 239, NO.
// NOV(II), P. 443, 1990.
import 'dart:math';

import 'package:d4_path/d4_path.dart';

import 'curve.dart';

int _sign(num x) {
  return x < 0 ? -1 : 1;
}

num _slope3(CurveMonotoneX that, num x2, num y2) {
  var h0 = that._x1 - that._x0,
      h1 = x2 - that._x1,
      s0 = (that._y1 - that._y0) /
          (h0 != 0
              ? h0
              : h1 < 0
                  ? -0.0
                  : 0),
      s1 = (y2 - that._y1) /
          (h1 != 0
              ? h1
              : h0 < 0
                  ? -0.0
                  : 0),
      p = (s0 * h1 + s1 * h0) / (h0 + h1),
      s = (_sign(s0) + _sign(s1)) * min(min(s0.abs(), s1.abs()), 0.5 * p.abs());
  return s.isFinite ? s : 0;
}

// Calculate a one-sided slope.
num _slope2(CurveMonotoneX that, num t) {
  var h = that._x1 - that._x0;
  return h != 0 ? (3 * (that._y1 - that._y0) / h - t) / 2 : t;
}

// According to https://en.wikipedia.org/wiki/Cubic_Hermite_spline#Representations
// "you can express cubic Hermite interpolation in terms of cubic Bézier curves
// with respect to the four values p0, p0 + m0 / 3, p1 - m1 / 3, p1".
void pointMonotone(CurveMonotoneX that, num t0, num t1) {
  var x0 = that._x0,
      y0 = that._y0,
      x1 = that._x1,
      y1 = that._y1,
      dx = (x1 - x0) / 3;
  that._context
      .bezierCurveTo(x0 + dx, y0 + dx * t0, x1 - dx, y1 - dx * t1, x1, y1);
}

class CurveMonotoneX implements Curve {
  late num _x0, _x1, _y0, _y1, _t0;
  num _point = double.nan, _line = double.nan;

  final Path _context;

  CurveMonotoneX(Path context) : _context = context;

  @override
  areaStart() {
    _line = 0;
  }

  @override
  areaEnd() {
    _line = double.nan;
  }

  @override
  lineStart() {
    _x0 = _x1 = _y0 = _y1 = _t0 = double.nan;
    _point = 0;
  }

  @override
  lineEnd() {
    switch (_point) {
      case 2:
        _context.lineTo(_x1, _y1);
        break;
      case 3:
        pointMonotone(this, _t0, _slope2(this, _t0));
        break;
      default:
    }
    if (_line == 1 || (_line != 0 && _point == 1)) _context.closePath();
    _line = 1 - _line;
  }

  @override
  point(x, y) {
    num t1 = double.nan;

    if (x == _x1 && y == _y1) return; // Ignore coincident points.
    switch (_point) {
      case 0:
        _point = 1;
        _line == 1 ? _context.lineTo(x, y) : _context.moveTo(x, y);
        break;
      case 1:
        _point = 2;
        break;
      case 2:
        _point = 3;
        pointMonotone(this, _slope2(this, t1 = _slope3(this, x, y)), t1);
        break;
      default:
        pointMonotone(this, _t0, t1 = _slope3(this, x, y));
        break;
    }

    _x0 = _x1;
    _x1 = x;
    _y0 = _y1;
    _y1 = y;
    _t0 = t1;
  }
}

class CurveMonotoneY extends CurveMonotoneX {
  CurveMonotoneY(Path context) : super(_ReflectContext(context));

  @override
  point(x, y) => super.point(y, x);
}

class _ReflectContext extends Path {
  final Path _context;

  _ReflectContext(Path context) : _context = context;

  @override
  moveTo(x, y) {
    _context.moveTo(y, x);
  }

  @override
  closePath() {
    _context.closePath();
  }

  @override
  lineTo(x, y) {
    _context.lineTo(y, x);
  }

  @override
  bezierCurveTo(x1, y1, x2, y2, x, y) {
    _context.bezierCurveTo(y1, x1, y2, x2, y, x);
  }
}

/// Produces a cubic spline that
/// [preserves monotonicity](https://en.wikipedia.org/wiki/Monotone_cubic_interpolation)
/// in *y*, assuming monotonicity in *x*, as proposed by Steffen in
/// [A simple method for monotonic interpolation in one dimension](http://adsabs.harvard.edu/full/1990A%26A...239..443S):
/// “a smooth curve with continuous first-order derivatives that passes through
/// any given set of data points without spurious oscillations.
///
/// <div id="obs">
///     <div id="in"></div>
///     <div id="out"></div>
/// </div>
///
/// <script type="module">
///
///     import { Runtime, Inspector } from "https://cdn.jsdelivr.net/npm/@observablehq/runtime@5/dist/runtime.js";
///     import * as d3 from "https://cdn.jsdelivr.net/npm/d3@7/+esm";
///     import * as Plot from "https://cdn.jsdelivr.net/npm/@observablehq/plot@0.6/+esm";
///
///     const obs = d3.select("#obs");
///
///     const runtime = new Runtime();
///     const module = runtime.module();
///     const inspector = new Inspector(obs.select("#out").node());
///
///     module.define("points", [[100, 200], [180, 80], [240, 40], [280, 40], [340, 160], [460, 160], [540, 80], [640, 120], [700, 160], [760, 140], [820, 200]]);
///     module.define("curves", [{curve: "monotone-x"}]);
///     module.define("label", null);
///     module.variable(inspector).define("out", ["points", "curves", "label"], definition);
///
///     function definition(points, curves, label) {
///         return Plot.plot({
///             aspectRatio: 1,
///             axis: null,
///             x: {type: "linear", domain: [60, 860]},
///             y: {type: "linear", domain: [240, 0]},
///             color: curves.length > 1 ? {type: "linear", domain: [0, 1], label, scheme: "purd", range: [0.25, 1], legend: true} : undefined,
///             marks: [
///                 Plot.frame({fill: "currentColor", fillOpacity: 0.08}),
///                 Plot.gridX({tickSpacing: 20, color: "currentColor", opacity: 0.1}),
///                 Plot.gridY({tickSpacing: 20, color: "currentColor", opacity: 0.1}),
///                 curves.map((curve) => Plot.line(points, {stroke: curves.length > 1 ? curve.tension : undefined, ...curve})),
///                 Plot.dot(points)
///             ]
///         });
///     }
/// </script>
///
/// Local extrema can occur only at grid points where they are given by the
/// data, but not in between two adjacent grid points.”
///
/// {@category Curves}
Curve curveMonotoneX(Path context) => CurveMonotoneX(context);

/// Produces a cubic spline that
/// [preserves monotonicity](https://en.wikipedia.org/wiki/Monotone_cubic_interpolation)
/// in *x*, assuming monotonicity in *y*, as proposed by Steffen in
/// [A simple method for monotonic interpolation in one dimension](http://adsabs.harvard.edu/full/1990A%26A...239..443S):
/// “a smooth curve with continuous first-order derivatives that passes through
/// any given set of data points without spurious oscillations.
///
/// <div id="obs">
///     <div id="in"></div>
///     <div id="out"></div>
/// </div>
///
/// <script type="module">
///
///     import { Runtime, Inspector } from "https://cdn.jsdelivr.net/npm/@observablehq/runtime@5/dist/runtime.js";
///     import * as d3 from "https://cdn.jsdelivr.net/npm/d3@7/+esm";
///     import * as Plot from "https://cdn.jsdelivr.net/npm/@observablehq/plot@0.6/+esm";
///
///     const obs = d3.select("#obs");
///
///     const runtime = new Runtime();
///     const module = runtime.module();
///     const inspector = new Inspector(obs.select("#out").node());
///
///     module.define("points", [[100, 200], [340, 200], [460, 160], [460, 120], [420, 80], [580, 40], [820, 40]]);
///     module.define("curves", [{curve: "monotone-y"}]);
///     module.define("label", null);
///     module.variable(inspector).define("out", ["points", "curves", "label"], definition);
///
///     function definition(points, curves, label) {
///         return Plot.plot({
///             aspectRatio: 1,
///             axis: null,
///             x: {type: "linear", domain: [60, 860]},
///             y: {type: "linear", domain: [240, 0]},
///             color: curves.length > 1 ? {type: "linear", domain: [0, 1], label, scheme: "purd", range: [0.25, 1], legend: true} : undefined,
///             marks: [
///                 Plot.frame({fill: "currentColor", fillOpacity: 0.08}),
///                 Plot.gridX({tickSpacing: 20, color: "currentColor", opacity: 0.1}),
///                 Plot.gridY({tickSpacing: 20, color: "currentColor", opacity: 0.1}),
///                 curves.map((curve) => Plot.line(points, {stroke: curves.length > 1 ? curve.tension : undefined, ...curve})),
///                 Plot.dot(points)
///             ]
///         });
///     }
/// </script>
///
/// Local extrema can occur only at grid points where they are given by the
/// data, but not in between two adjacent grid points.”
///
/// {@category Curves}
Curve curveMonotoneY(Path context) => CurveMonotoneY(context);
