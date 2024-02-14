import '../math.dart';
import 'type.dart';

const ka = 0.89081309152928522810;
final kr = sin(pi / 10) / sin(7 * pi / 10);
final kx = sin(tau / 10) * kr;
final ky = -cos(tau / 10) * kr;

/// The pentagonal star (pentagram) symbol type; intended for filling.
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
///                 Plot.dotX(["star"], {fill: "currentColor", r: 12, symbol: Plot.identity})
///             ]
///         });
///     }
/// </script>
///
/// {@category Symbols}
class SymbolStar implements SymbolType {
  const SymbolStar();

  @override
  draw(context, size) {
    final r = sqrt(size * ka);
    final x = kx * r;
    final y = ky * r;
    context.moveTo(0, -r);
    context.lineTo(x, y);
    for (var i = 1; i < 5; ++i) {
      final a = tau * i / 5;
      final c = cos(a);
      final s = sin(a);
      context.lineTo(s * r, -c * r);
      context.lineTo(c * x - s * y, s * x + c * y);
    }
    context.closePath();
  }
}
