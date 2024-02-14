import '../math.dart';
import 'type.dart';

final sqrt3 = sqrt(3);

/// The up-pointing triangle symbol type; intended for filling.
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
///                 Plot.dotX(["triangle"], {fill: "currentColor", r: 12, symbol: Plot.identity})
///             ]
///         });
///     }
/// </script>
///
/// {@category Symbols}
class SymbolTriangle implements SymbolType {
  const SymbolTriangle();

  @override
  draw(context, size) {
    final y = -sqrt(size / (sqrt3 * 3));
    context.moveTo(0, y * 2);
    context.lineTo(-sqrt3 * y, -y);
    context.lineTo(sqrt3 * y, -y);
    context.closePath();
  }
}
