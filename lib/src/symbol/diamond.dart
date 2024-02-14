import '../math.dart';
import 'type.dart';

final tan30 = sqrt(1 / 3);
final tan30_2 = tan30 * 2;

/// The rhombus symbol type; intended for filling.
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
///                 Plot.dotX(["diamond"], {fill: "currentColor", r: 12, symbol: Plot.identity})
///             ]
///         });
///     }
/// </script>
///
/// {@category Symbols}
class SymbolDiamond implements SymbolType {
  const SymbolDiamond();

  @override
  draw(context, size) {
    final y = sqrt(size / tan30_2);
    final x = y * tan30;
    context.moveTo(0, -y);
    context.lineTo(x, 0);
    context.lineTo(0, y);
    context.lineTo(-x, 0);
    context.closePath();
  }
}
