import 'package:d4_path/d4_path.dart';

import 'curve.dart';

class CurveLinearClosed implements Curve {
  num _point = double.nan;

  final Path _context;

  CurveLinearClosed(Path context) : _context = context;

  @override
  areaStart() {}

  @override
  areaEnd() {}

  @override
  lineStart() {
    _point = 0;
  }

  @override
  lineEnd() {
    if (_point > 0) _context.closePath();
  }

  @override
  point(x, y) {
    if (_point > 0) {
      _context.lineTo(x, y);
    } else {
      _point = 1;
      _context.moveTo(x, y);
    }
  }
}

/// Produces a closed polyline through the specified points by repeating the
/// first point when the line segment ends.
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
///     module.define("curves", [{curve: "linear-closed"}]);
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
Curve curveLinearClosed(Path context) => CurveLinearClosed(context);
