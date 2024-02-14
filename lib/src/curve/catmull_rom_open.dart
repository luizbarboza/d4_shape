part of 'catmull_rom.dart';

class CurveCatmullRomOpen extends CurveCatmullRom {
  CurveCatmullRomOpen(super.context, super.alpha);

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
    _x0 = _x1 = _x2 = _y0 = _y1 = _y2 = double.nan;
    _l01a = _l12a = _l23a = _l012a = _l122a = _l232a = _point = 0;
  }

  @override
  lineEnd() {
    if (_line == 1 || (_line != 0 && _point == 3)) _context.closePath();
    _line = 1 - _line;
  }

  @override
  point(x, y) {
    if (_point > 0) {
      var x23 = _x2 - x, y23 = _y2 - y;
      _l23a = sqrt(_l232a = pow(x23 * x23 + y23 * y23, _alpha));
    }

    switch (_point) {
      case 0:
        _point = 1;
        break;
      case 1:
        _point = 2;
        break;
      case 2:
        _point = 3;
        _line == 1 ? _context.lineTo(_x2, _y2) : _context.moveTo(_x2, _y2);
        break;
      case 3:
        _point = 4; // falls through
        continue a;
      a:
      default:
        _pointCatmullRom(this, x, y);
        break;
    }

    _l01a = _l12a;
    _l12a = _l23a;
    _l012a = _l122a;
    _l122a = _l232a;
    _x0 = _x1;
    _x1 = _x2;
    _x2 = x;
    _y0 = _y1;
    _y1 = _y2;
    _y2 = y;
  }
}

/// Equivalent to [curveCatmullRomAlpha], but returns a [curveCatmullRomOpen].
///
/// {@category Curves}
CurveFactory curveCatmullRomOpenAlpha(num alpha) =>
    (Path context) => alpha != 0 && !alpha.isNaN
        ? CurveCatmullRomOpen(context, alpha)
        : CurveCardinalOpen(context, 0);

/// Produces a cubic Catmull–Rom spline using the specified control points and
/// the parameter *alpha* (see [curveCatmullRomClosedAlpha]), which defaults to
/// 0.5, as proposed by Yuksel et al.
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
///     module.define("curves", ticks.map((t) => ({curve: "catmull-rom-open", tension: t})));
///     module.define("label", "alpha");
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
/// Unlike [curveCatmullRom], one-sided differences are not used for the first
/// and last piece, and thus the curve starts at the second point and ends at
/// the penultimate point.
///
/// {@category Curves}
Curve curveCatmullRomOpen(Path context) =>
    curveCatmullRomOpenAlpha(0.5)(context);
