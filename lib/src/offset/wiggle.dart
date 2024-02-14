import '../order/inside_out.dart';
import 'none.dart';

/// Shifts the baseline so as to minimize the weighted wiggle of layers.
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
///     const riaa = d3.csvParse(await (await fetch("https://raw.githubusercontent.com/d3/d3/9f9d46849c5b5751609b169ffda497e6d79e7c2e/docs/public/data/riaa-us-revenue.csv")).text(), d3.autoType);
///
///     module.define("riaa", riaa)
///     module.variable(inspector).define("out", ["riaa"], definition);
///
///     function definition(riaa) {
///         return Plot.plot({
///             height: 200,
///             y: {
///                 grid: true,
///                 label: "Annual revenue (%)",
///                 transform: (d) => d / 1e3
///             },
///             marks: [
///                 Plot.areaY(riaa, {x: "year", y: "revenue", z: "format", fill: "group", offset: "wiggle"})
///             ]
///         });
///     }
/// </script>
///
/// ```dart
/// final stack = Stack(…)..offset = stackOffsetWiggle;
/// ```
///
/// This offset is recommended for streamgraphs in conjunction with the
/// [stackOrderInsideOut]. See
/// [Stacked Graphs — Geometry & Aesthetics](http://leebyron.com/streamgraph/)
/// by Bryon & Wattenberg for more information.
///
/// {@category Stacks}
/// {@category Stack offsets}
void stackOffsetWiggle(List<List<List<num>>> series, List<int> order) {
  int m, n;
  List<List<num>> s0;
  if (!((n = series.length) > 0) ||
      !((m = (s0 = series[order[0]]).length) > 0)) {
    return;
  }
  int j = 1;
  num y = 0;
  for (; j < m; ++j) {
    num s1 = 0, s2 = 0;
    for (var i = 0; i < n; ++i) {
      var si = series[order[i]], sij0 = si[j][1], sij1 = si[j - 1][1];
      sij0 = sij0.isNaN ? 0 : sij0;
      var s3 = (sij0 - (sij1.isNaN ? 0 : sij1)) / 2;
      for (var k = 0; k < i; ++k) {
        var sk = series[order[k]], skj0 = sk[j][1], skj1 = sk[j - 1][1];
        s3 += (skj0.isNaN ? 0 : skj0) - (skj1.isNaN ? 0 : skj1);
      }
      s1 += sij0;
      s2 += s3 * sij0;
    }
    s0[j - 1][1] += s0[j - 1][0] = y;
    if (s1 != 0) y -= s2 / s1;
  }
  s0[j - 1][1] += s0[j - 1][0] = y;
  stackOffsetNone(series, order);
}
