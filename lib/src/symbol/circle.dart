import '../math.dart';
import 'type.dart';

/// The circle symbol type; intended for either filling or stroking.
///
/// <div id="exampleCurve">
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
///     const exampleCurve = d3.select("#exampleCurve");
///
///     const runtime = new Runtime();
///     const module = runtime.module();
///     const inspector = new Inspector(exampleCurve.select("#out").node());
///
///     module.variable(inspector).define("out", definition);
///
///     function definition() {
///         return Plot.plot({
///             width: 80,
///             height: 40,
///             axis: null,
///             x: {type: "band"},
///             marks: [
///                 Plot.dotX(["circle"], {x: 0, stroke: "currentColor", r: 12, symbol: Plot.identity}),
///                 Plot.dotX(["circle"], {x: 1, fill: "currentColor", r: 12, symbol: Plot.identity}),
///             ]
///         });
///     }
/// </script>
///
/// {@category Symbols}
class SymbolCircle implements SymbolType {
  const SymbolCircle();

  @override
  draw(context, size) {
    final r = sqrt(size / pi);
    context.moveTo(r, 0);
    context.arc(0, 0, r, 0, tau);
  }
}
