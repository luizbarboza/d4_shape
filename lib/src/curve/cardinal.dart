import 'package:d4_path/d4_path.dart';

import 'catmull_rom.dart';
import 'curve.dart';
import 'linear.dart';

part 'cardinal_closed.dart';
part 'cardinal_open.dart';

void _pointCardinal(CurveCardinal that, num x, num y) {
  that._context.bezierCurveTo(
      that._x1 + that._k * (that._x2 - that._x0),
      that._y1 + that._k * (that._y2 - that._y0),
      that._x2 + that._k * (that._x1 - x),
      that._y2 + that._k * (that._y1 - y),
      that._x2,
      that._y2);
}

class CurveCardinal implements Curve {
  late num _x0, _y0, _x1, _y1, _x2, _y2, _point, _line;

  final Path _context;
  final num _k;

  CurveCardinal(Path context, num tension)
      : _context = context,
        _k = (1 - tension) / 6 {
    _x0 = _y0 = _x1 = _y1 = _x2 = _y2 = _point = _line = double.nan;
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
    _x0 = _x1 = _x2 = _y0 = _y1 = _y2 = double.nan;
    _point = 0;
  }

  @override
  lineEnd() {
    switch (_point) {
      case 2:
        _context.lineTo(_x2, _y2);
        break;
      case 3:
        _pointCardinal(this, _x1, _y1);
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
        _x1 = x;
        _y1 = y;
        break;
      case 2:
        _point = 3; // falls through
        continue a;
      a:
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

/// Returns a cardinal curve with the specified [tension] in the range \[0, 1\].
///
/// <div id="obs">
///     <div id="in"></div>
///     <div id="out"></div>
/// </div>
///
/// <script type="module">
///
///     import { Runtime, Inspector, Library } from "https://cdn.jsdelivr.net/npm/@observablehq/runtime@5/dist/runtime.js";
///     import * as d3 from "https://cdn.jsdelivr.net/npm/d3@7/+esm";
///     import * as Plot from "https://cdn.jsdelivr.net/npm/@observablehq/plot@0.6/+esm";
///
///     const stdlib = new Library;
///     const Inputs = await stdlib.Inputs();
///     const Generators = stdlib.Generators;
///
///     const tension = Inputs.range([0, 1], {label: "Tension:", step: 0.01, value: 0});
///
///     const obs = d3.select("#obs");
///     obs.select("#in").append(() => tension);
///
///     const runtime = new Runtime();
///     const module = runtime.module();
///     const inspector = new Inspector(obs.select("#out").node());
///
///     module.define("points", [[100, 200], [180, 80], [240, 40], [280, 40], [340, 160], [460, 160], [540, 80], [640, 120], [700, 160], [760, 140], [820, 200]]);
///     module.define("tension", Generators.input(tension));
///     module.define("curves", ["tension"], (tension) => [{curve: "cardinal", tension: tension}]);
///     module.define("label", undefined);
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
///         })
///     }
/// </script>
///
/// The [tension] determines the length of the tangents: a [tension] of one
/// yields all zero tangents, equivalent to [curveLinear]; a [tension] of zero
/// produces a uniform Catmull–Rom (see [curveCatmullRom]) spline. For example:
///
/// ```dart
/// final line = Line(…)..curve = curveCardinalTension(0.5);
/// ```
///
/// {@category Curves}
CurveCardinal Function(Path) curveCardinalTension(num tension) {
  return (context) => CurveCardinal(context, tension);
}

/// Produces a cubic
/// [cardinal spline](https://en.wikipedia.org/wiki/Cubic_Hermite_spline#Cardinal_spline)
/// using the specified control points, with one-sided differences used for the
/// first and last piece.
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
///     module.define("curves", ticks.map((t) => ({curve: "cardinal", tension: t})));
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
/// The default tension (see [curveCardinalTension]) is 0.
///
/// {@category Curves}
Curve curveCardinal(Path context) => curveCardinalTension(0)(context);
