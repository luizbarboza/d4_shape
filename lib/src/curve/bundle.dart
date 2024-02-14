import 'package:d4_path/d4_path.dart';

import 'basis.dart';
import 'curve.dart';

class CurveBundle implements Curve {
  List<num>? _x, _y;

  final Curve _basis;
  final num _beta;

  CurveBundle(Path context, num beta)
      : _basis = curveBasis(context),
        _beta = beta;

  @override
  areaStart() {}

  @override
  areaEnd() {}

  @override
  lineStart() {
    _x = [];
    _y = [];
    _basis.lineStart();
  }

  @override
  lineEnd() {
    var x = _x!, y = _y!, j = x.length - 1;

    if (j > 0) {
      var x0 = x[0], y0 = y[0], dx = x[j] - x0, dy = y[j] - y0, i = -1;
      num t;

      while (++i <= j) {
        t = i / j;
        _basis.point(_beta * x[i] + (1 - _beta) * (x0 + t * dx),
            _beta * y[i] + (1 - _beta) * (y0 + t * dy));
      }
    }

    _x = _y = null;
    _basis.lineEnd();
  }

  @override
  point(x, y) {
    _x!.add(x);
    _y!.add(y);
  }
}

/// Returns a bundle curve with the specified [beta] in the range \[0, 1\],
/// representing the bundle strength.
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
///     const beta = Inputs.range([0, 1], {label: "Beta:", step: 0.01, value: 0.85});
///
///     const obs = d3.select("#obs");
///     obs.select("#in").append(() => beta);
///
///     const runtime = new Runtime();
///     const module = runtime.module();
///     const inspector = new Inspector(obs.select("#out").node());
///
///     module.define("points", [[100, 200], [180, 80], [240, 40], [280, 40], [340, 160], [460, 160], [540, 80], [640, 120], [700, 160], [760, 140], [820, 200]]);
///     module.define("beta", Generators.input(beta));
///     module.define("curves", ["beta"], (beta) => [{curve: "bundle", tension: beta}]);
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
///         });
///     }
/// </script>
///
/// If [beta] equals zero, a straight line between the first and last point is
/// produced; if [beta] equals one, a standard basis see [curveBasis] spline is
/// produced. For example:
///
/// ```dart
/// final line = Line(…)..curve = curveBundleBeta(0.5);
/// ```
///
/// {@category Curves}
CurveFactory curveBundleBeta(num beta) => (Path context) =>
    beta == 1 ? curveBasis(context) : CurveBundle(context, beta);

/// Produces a straightened cubic
/// [basis spline](https://en.wikipedia.org/wiki/B-spline) using the specified
/// control points, with the spline straightened according to the curve’s *beta*
/// (see [curveBundleBeta]), which defaults to 0.85.
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
///     module.define("curves", ticks.map((t) => ({curve: "bundle", tension: t})));
///     module.define("label", "beta");
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
/// This curve is typically used in
/// [hierarchical edge bundling](https://observablehq.com/@d3/hierarchical-edge-bundling)
/// to disambiguate connections, as proposed by
/// [Danny Holten](https://www.win.tue.nl/vis1/home/dholten/) in
/// [Hierarchical Edge Bundles: Visualization of Adjacency Relations in Hierarchical Data](https://www.win.tue.nl/vis1/home/dholten/papers/bundles_infovis.pdf).
/// This curve does not implement [Curve.areaStart] and [Curve.areaEnd]; it is
/// intended to work with
/// [line](https://pub.dev/documentation/d4_shape/latest/topics/Lines-topic.html),
/// not
/// [area](https://pub.dev/documentation/d4_shape/latest/topics/Areas-topic.html).
///
/// {@category Curves}
Curve curveBundle(Path context) => curveBundleBeta(0.85)(context);
