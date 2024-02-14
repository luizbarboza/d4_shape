import 'package:d4_path/d4_path.dart';

import 'curve.dart';

part 'basis_closed.dart';
part 'basis_open.dart';

void _basisPoint(CurveBasis that, num x, num y) {
  that._context.bezierCurveTo(
      (2 * that._x0 + that._x1) / 3,
      (2 * that._y0 + that._y1) / 3,
      (that._x0 + 2 * that._x1) / 3,
      (that._y0 + 2 * that._y1) / 3,
      (that._x0 + 4 * that._x1 + x) / 6,
      (that._y0 + 4 * that._y1 + y) / 6);
}

class CurveBasis implements Curve {
  late num _x0, _y0, _x1, _y1, _point, _line;

  final Path _context;

  CurveBasis(Path context) : _context = context {
    _x0 = _y0 = _x1 = _y1 = _point = _line = double.nan;
  }

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
    _x0 = _x1 = _y0 = _y1 = double.nan;
    _point = 0;
  }

  @override
  lineEnd() {
    switch (_point) {
      case 3:
        _basisPoint(this, _x1, _y1); // proceed
        continue a;
      a:
      case 2:
        _context.lineTo(_x1, _y1);
        break;
      default:
    }
    if (_line == 1 || (_line != 0 && _point == 1)) _context.closePath();
    _line = 1 - _line;
  }

  @override
  point(x, y) {
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
        _context.lineTo((5 * _x0 + _x1) / 6, (5 * _y0 + _y1) / 6); // proceed
        continue a;
      a:
      default:
        _basisPoint(this, x, y);
        break;
    }
    _x0 = _x1;
    _x1 = x;
    _y0 = _y1;
    _y1 = y;
  }
}

/// Produces a cubic [basis spline](https://en.wikipedia.org/wiki/B-spline)
/// using the specified control points.
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
///     module.define("curves", [{curve: "basis"}]);
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
/// The first and last points are triplicated such that the spline starts at the
/// first point and ends at the last point, and is tangent to the line between
/// the first and second points, and to the line between the penultimate and
/// last points.
///
/// {@category Curves}
Curve curveBasis(Path context) => CurveBasis(context);
