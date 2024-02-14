part of 'cardinal.dart';

class CurveCardinalClosed extends CurveCardinal {
  late num _x3, _y3, _x4, _y4, _x5, _y5;

  CurveCardinalClosed(super.context, super.tension);

  @override
  areaStart() {
    _line = 0;
  }

  @override
  areaEnd() {}

  @override
  lineStart() {
    _x0 = _x1 =
        _x2 = _x3 = _x4 = _x5 = _y0 = _y1 = _y2 = _y3 = _y4 = _y5 = double.nan;
    _point = 0;
  }

  @override
  lineEnd() {
    switch (_point) {
      case 1:
        _context.moveTo(_x3, _y3);
        _context.closePath();
        break;
      case 2:
        _context.lineTo(_x3, _y3);
        _context.closePath();
        break;
      case 3:
        point(_x3, _y3);
        point(_x4, _y4);
        point(_x5, _y5);
        break;
      default:
    }
  }

  @override
  point(x, y) {
    switch (_point) {
      case 0:
        _point = 1;
        _x3 = x;
        _y3 = y;
        break;
      case 1:
        _point = 2;
        _context.moveTo(_x4 = x, _y4 = y);
        break;
      case 2:
        _point = 3;
        _x5 = x;
        _y5 = y;
        break;
      default:
        _pointCardinal(this, x, y);
        break;
    }
    _x0 = _x1;
    _x1 = _x2;
    _x2 = x;
    _y0 = _y1;
    _y1 = _y2;
    _y2 = y;
  }
}

/// Equivalent to [curveCardinalTension], but returns a [curveCardinalClosed].
///
/// {@category Curves}
CurveFactory curveCardinalClosedTension(num tension) =>
    (Path context) => CurveCardinalClosed(context, tension);

/// Produces a closed cubic
/// [cardinal spline](https://en.wikipedia.org/wiki/Cubic_Hermite_spline#Cardinal_spline)
/// using the specified control points. When a line segment ends, the first
/// three control points are repeated, producing a closed loop.
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
///     const ticks = [0, 0.25, 0.5, 0.75, 1];
///
///     module.define("points", [[100, 200], [180, 80], [240, 40], [280, 40], [340, 160], [460, 160], [540, 80], [640, 120], [700, 160], [760, 140], [820, 200]]);
///     module.define("curves", ticks.map((t) => ({curve: "cardinal-closed", tension: t})));
///     module.define("label", "tension");
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
/// The default tension (see [curveCardinalClosedTension]) is 0.
///
/// {@category Curves}
Curve curveCardinalClosed(Path context) =>
    curveCardinalClosedTension(0)(context);
