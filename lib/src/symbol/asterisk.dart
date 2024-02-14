import '../math.dart';
import 'type.dart';

final sqrt3 = sqrt(3);

/// The asterisk symbol type; intended for stroking.
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
///             width: 40,
///             height: 40,
///             axis: null,
///             marks: [
///                 Plot.dotX(["asterisk"], {stroke: "currentColor", r: 12, symbol: Plot.identity})
///             ]
///         });
///     }
/// </script>
///
/// {@category Symbols}
class SymbolAsterisk implements SymbolType {
  const SymbolAsterisk();

  @override
  draw(context, size) {
    final r = sqrt(size + min(size / 28, 0.75)) * 0.59436;
    final t = r / 2;
    final u = t * sqrt3;
    context.moveTo(0, r);
    context.lineTo(0, -r);
    context.moveTo(-u, -t);
    context.lineTo(u, t);
    context.moveTo(-u, t);
    context.lineTo(u, -t);
  }
}
