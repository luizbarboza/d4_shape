import '../math.dart';
import 'type.dart';

/// The Greek cross symbol type, with arms of equal length; intended for
/// filling.
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
///                 Plot.dotX(["cross"], {fill: "currentColor", r: 12, symbol: Plot.identity})
///             ]
///         });
///     }
/// </script>
///
/// {@category Symbols}
class SymbolCross implements SymbolType {
  const SymbolCross();

  @override
  draw(context, size) {
    final r = sqrt(size / 5) / 2;
    context.moveTo(-3 * r, -r);
    context.lineTo(-r, -r);
    context.lineTo(-r, -3 * r);
    context.lineTo(r, -3 * r);
    context.lineTo(r, -r);
    context.lineTo(3 * r, -r);
    context.lineTo(3 * r, r);
    context.lineTo(r, r);
    context.lineTo(r, 3 * r);
    context.lineTo(-r, 3 * r);
    context.lineTo(-r, r);
    context.lineTo(-3 * r, r);
    context.closePath();
  }
}
