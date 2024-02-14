import 'package:d4_path/d4_path.dart';

import '../point_radial.dart';
import 'curve.dart';

class CurveBump implements Curve {
  late num _x0, _y0, _point, _line;

  final Path _context;
  final bool _x;

  CurveBump(Path context, bool x)
      : _context = context,
        _x = x {
    _x0 = _y0 = _point = _line = double.nan;
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
    _point = 0;
  }

  @override
  lineEnd() {
    if (_line == 1 || (_line != 0 && _point == 1)) _context.closePath();
    _line = 1 - _line;
  }

  @override
  point(x, y) {
    switch (_point) {
      case 0:
        _point = 1;
        if (_line == 1) {
          _context.lineTo(x, y);
        } else {
          _context.moveTo(x, y);
        }
        break;
      case 1:
        _point = 2; // falls through
        continue a;
      a:
      default:
        if (_x) {
          _context.bezierCurveTo(_x0 = (_x0 + x) / 2, _y0, _x0, y, x, y);
        } else {
          _context.bezierCurveTo(_x0, _y0 = (_y0 + y) / 2, x, _y0, x, y);
        }
        break;
    }
    _x0 = x;
    _y0 = y;
  }
}

class CurveBumpRadial implements Curve {
  late num _x0, _y0, _point;

  final Path _context;

  CurveBumpRadial(Path context) : _context = context {
    _x0 = _y0 = double.nan;
  }

  @override
  areaStart() {}

  @override
  areaEnd() {}

  @override
  lineStart() {
    _point = 0;
  }

  @override
  lineEnd() {}

  @override
  point(x, y) {
    if (_point == 0) {
      _point = 1;
    } else {
      final p0 = pointRadial(_x0, _y0);
      final p1 = pointRadial(_x0, _y0 = (_y0 + y) / 2);
      final p2 = pointRadial(x, _y0);
      final p3 = pointRadial(x, y);
      _context.moveTo(p0[0], p0[1]);
      _context.bezierCurveTo(p1[0], p1[1], p2[0], p2[1], p3[0], p3[1]);
    }
    _x0 = x;
    _y0 = y;
  }
}

/// Produces a Bézier curve between each pair of points, with horizontal
/// tangents at each point.
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
///     module.define("curves", [{curve: "bump-x"}]);
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
Curve curveBumpX(Path context) => CurveBump(context, true);

/// Produces a Bézier curve between each pair of points, with vertical tangents
/// at each point.
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
///     module.define("curves", [{curve: "bump-y"}]);
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
Curve curveBumpY(Path context) => CurveBump(context, false);

Curve curveBumpRadial(Path context) => CurveBumpRadial(context);
