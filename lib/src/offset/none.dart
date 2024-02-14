/// Applies a zero baseline.
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
///                 Plot.areaY(riaa, {x: "year", y: "revenue", z: "format", fill: "group", order: "appearance"}),
///                 Plot.ruleY([0])
///             ]
///         });
///     }
/// </script>
///
/// ```dart
/// final stack = Stack(…)..offset = stackOffsetNone;
/// ```
///
/// {@category Stacks}
/// {@category Stack offsets}
void stackOffsetNone(List<List<List<num>>> series, List<int> order) {
  int j, n;
  if (!((n = series.length) > 1)) return;
  List<List<num>> s0;
  for (var i = 1, s1 = series[order[0]], m = s1.length; i < n; ++i) {
    s0 = s1;
    s1 = series[order[i]];
    for (j = 0; j < m; ++j) {
      s1[j][1] += s1[j][0] = s0[j][1].isNaN ? s0[j][0] : s0[j][1];
    }
  }
}
