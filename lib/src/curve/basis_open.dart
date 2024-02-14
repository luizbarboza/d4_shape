part of 'basis.dart';

class CurveBasisOpen extends CurveBasis {
  CurveBasisOpen(super.context);

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
    if (_line == 1 || (_line != 0 && _point == 3)) _context.closePath();
    _line = 1 - _line;
  }

  @override
  point(x, y) {
    switch (_point) {
      case 0:
        _point = 1;
        break;
      case 1:
        _point = 2;
        break;
      case 2:
        _point = 3;
        var x0 = (_x0 + 4 * _x1 + x) / 6, y0 = (_y0 + 4 * _y1 + y) / 6;
        _line == 1 ? _context.lineTo(x0, y0) : _context.moveTo(x0, y0);
        break;
      case 3:
        _point = 4; // falls through
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
///     module.define("curves", [{curve: "basis-open"}]);
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
/// Unlike [curveBasis], the first and last points are not repeated, and thus
/// the curve typically does not intersect these points.
///
/// {@category Curves}
Curve curveBasisOpen(Path context) => CurveBasisOpen(context);
