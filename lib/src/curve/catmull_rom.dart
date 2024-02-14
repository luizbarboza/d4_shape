import 'dart:math';

import 'package:d4_path/d4_path.dart';

import '../math.dart';
import 'cardinal.dart';
import 'curve.dart';

part 'catmull_rom_closed.dart';
part 'catmull_rom_open.dart';

void _pointCatmullRom(CurveCatmullRom that, num x, num y) {
  var x1 = that._x1, y1 = that._y1, x2 = that._x2, y2 = that._y2;

  if (that._l01a > epsilon) {
    var a = 2 * that._l012a + 3 * that._l01a * that._l12a + that._l122a,
        n = 3 * that._l01a * (that._l01a + that._l12a);
    x1 = (x1 * a - that._x0 * that._l122a + that._x2 * that._l012a) / n;
    y1 = (y1 * a - that._y0 * that._l122a + that._y2 * that._l012a) / n;
  }

  if (that._l23a > epsilon) {
    var b = 2 * that._l232a + 3 * that._l23a * that._l12a + that._l122a,
        m = 3 * that._l23a * (that._l23a + that._l12a);
    x2 = (x2 * b + that._x1 * that._l232a - x * that._l122a) / m;
    y2 = (y2 * b + that._y1 * that._l232a - y * that._l122a) / m;
  }

  that._context.bezierCurveTo(x1, y1, x2, y2, that._x2, that._y2);
}

class CurveCatmullRom implements Curve {
  late num _x0,
      _y0,
      _x1,
      _y1,
      _x2,
      _y2,
      _l01a,
      _l012a,
      _l12a,
      _l122a,
      _l23a,
      _l232a,
      _point,
      _line;

  final Path _context;
  final num _alpha;

  CurveCatmullRom(Path context, num alpha)
      : _context = context,
        _alpha = alpha {
    _line = double.nan;
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
    _l01a = _l12a = _l23a = _l012a = _l122a = _l232a = _point = 0;
  }

  @override
  lineEnd() {
    switch (_point) {
      case 2:
        _context.lineTo(_x2, _y2);
        break;
      case 3:
        point(_x2, _y2);
        break;
      default:
    }
    if (_line == 1 || (_line != 0 && _point == 1)) _context.closePath();
    _line = 1 - _line;
  }

  @override
  point(num x, num y) {
    if (_point > 0) {
      var x23 = _x2 - x, y23 = _y2 - y;
      _l23a = sqrt(_l232a = pow(x23 * x23 + y23 * y23, _alpha));
    }

    switch (_point) {
      case 0:
        _point = 1;
        _line == 1 ? _context.lineTo(x, y) : _context.moveTo(x, y);
        break;
      case 1:
        _point = 2;
        break;
      case 2:
        _point = 3; // falls through
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

/// Returns a cubic Catmull–Rom curve with the specified [alpha] in the range
/// \[0, 1\].
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
///     const alpha = Inputs.range([0, 1], {label: "Alpha:", step: 0.01, value: 0.5});
///
///     const obs = d3.select("#obs");
///     obs.select("#in").append(() => alpha);
///
///     const runtime = new Runtime();
///     const module = runtime.module();
///     const inspector = new Inspector(obs.select("#out").node());
///
///     module.define("points", [[100, 200], [180, 80], [240, 40], [280, 40], [340, 160], [460, 160], [540, 80], [640, 120], [700, 160], [760, 140], [820, 200]]);
///     module.define("alpha", Generators.input(alpha));
///     module.define("curves", ["alpha"], (alpha) => [{curve: "catmull-rom", tension: alpha}]);
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
///             Plot.frame({fill: "currentColor", fillOpacity: 0.08}),
///             Plot.gridX({tickSpacing: 20, color: "currentColor", opacity: 0.1}),
///             Plot.gridY({tickSpacing: 20, color: "currentColor", opacity: 0.1}),
///             curves.map((curve) => Plot.line(points, {stroke: curves.length > 1 ? curve.tension : undefined, ...curve})),
///             Plot.dot(points)
///             ]
///         });
///     }
/// </script>
///
/// If [alpha] is zero, produces a uniform spline, equivalent to [curveCardinal]
///  with a tension of zero; if [alpha] is one, produces a chordal spline; if
/// [alpha] is 0.5, produces a
/// [centripetal spline](https://en.wikipedia.org/wiki/Centripetal_Catmull–Rom_spline).
/// Centripetal splines are recommended to avoid self-intersections and
/// overshoot. For example:
///
/// ```dart
/// final line = Line(…)..curve = curveCatmullRom(0.5);
/// ```
///
/// {@category Curves}
CurveFactory curveCatmullRomAlpha(num alpha) =>
    (Path context) => alpha != 0 && !alpha.isNaN
        ? CurveCatmullRom(context, alpha)
        : CurveCardinal(context, 0);

/// Produces a cubic Catmull–Rom spline using the specified control points and
/// the parameter *alpha* (see [curveCatmullRomAlpha]), which defaults to 0.5,
/// as proposed by Yuksel et al. in
/// [On the Parameterization of Catmull–Rom Curves](http://www.cemyuksel.com/research/catmullrom_param/),
/// with one-sided differences used for the first and last piece.
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
///     module.define("curves", ticks.map((t) => ({curve: "catmull-rom-closed", tension: t})));
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
/// {@category Curves}
Curve curveCatmullRom(Path context) => curveCatmullRomAlpha(0.5)(context);
