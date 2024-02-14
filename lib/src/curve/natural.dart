import 'package:d4_path/d4_path.dart';

import 'curve.dart';

class CurveNatural implements Curve {
  late List<num>? _x, _y;
  var _line = double.nan;

  final Path _context;

  CurveNatural(Path context) : _context = context;

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
    _x = [];
    _y = [];
  }

  @override
  lineEnd() {
    var x = _x!, y = _y!, n = x.length;

    if (n > 0) {
      _line == 1 ? _context.lineTo(x[0], y[0]) : _context.moveTo(x[0], y[0]);
      if (n == 2) {
        _context.lineTo(x[1], y[1]);
      } else {
        var px = _controlPoints(x), py = _controlPoints(y);
        for (var i0 = 0, i1 = 1; i1 < n; ++i0, ++i1) {
          _context.bezierCurveTo(
              px.$1[i0], py.$1[i0], px.$2[i0], py.$2[i0], x[i1], y[i1]);
        }
      }
    }

    if (_line == 1 || (_line != 0 && n == 1)) _context.closePath();
    _line = 1 - _line;
    _x = _y = null;
  }

  @override
  point(x, y) {
    _x!.add(x);
    _y!.add(y);
  }
}

// See https://www.particleincell.com/2012/bezier-splines/ for derivation.
(List<num>, List<num>) _controlPoints(List<num> x) {
  int i, n = x.length - 1;
  if (n == 0) return ([], []);
  num m;
  var a = List<num>.filled(n, 0),
      b = List<num>.filled(n, 0),
      r = List<num>.filled(n, 0);
  a[0] = 0;
  b[0] = 2;
  r[0] = x[0] + 2 * x[1];
  for (i = 1; i < n - 1; ++i) {
    a[i] = 1;
    b[i] = 4;
    r[i] = 4 * x[i] + 2 * x[i + 1];
  }
  a[n - 1] = 2;
  b[n - 1] = 7;
  r[n - 1] = 8 * x[n - 1] + x[n];
  for (i = 1; i < n; ++i) {
    m = a[i] / b[i - 1];
    b[i] -= m;
    r[i] -= m * r[i - 1];
  }
  a[n - 1] = r[n - 1] / b[n - 1];
  for (i = n - 2; i >= 0; --i) {
    a[i] = (r[i] - a[i + 1]) / b[i];
  }
  b[n - 1] = (x[n] + a[n - 1]) / 2;
  for (i = 0; i < n - 1; ++i) {
    b[i] = 2 * x[i + 1] - a[i + 1];
  }
  return (a, b);
}

/// Produces a [natural](https://en.wikipedia.org/wiki/Spline_interpolation)
/// [cubic spline](http://mathworld.wolfram.com/CubicSpline.html) with the
/// second derivative of the spline set to zero at the endpoints.
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
///     module.define("curves", [{curve: "natural"}]);
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
/// {@category Curves}
Curve curveNatural(Path context) => CurveNatural(context);
