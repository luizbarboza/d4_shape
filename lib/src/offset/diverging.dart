/// Positive values are stacked above zero, negative values are
/// [stacked below zero](https://observablehq.com/@d3/diverging-stacked-bar-chart/2?intent=fork),
/// and zero values are stacked at zero.
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
///                 Plot.areaY(riaa, {x: "year", y: (d) => (d.group === "Disc" ? -1 : 1) * d.revenue, z: "format", fill: "group", order: "appearance"}),
///                 Plot.ruleY([0])
///             ]
///         });
///     }
/// </script>
///
/// ```dart
/// final stack = Stack(…)..offset = stackOffsetDiverging;
/// ```
///
/// {@category Stacks}
/// {@category Stack offsets}
void stackOffsetDiverging(List<List<List<num>>> series, List<int> order) {
  int i, n;
  if (!((n = series.length) > 0)) return;
  num dy, yp, yn;
  List<num> d;
  for (var j = 0, m = series[order[0]].length; j < m; ++j) {
    yp = yn = 0;
    for (i = 0; i < n; ++i) {
      if ((dy = (d = series[order[i]][j])[1] - d[0]) > 0) {
        d[0] = yp;
        d[1] = yp += dy;
      } else if (dy < 0) {
        d[1] = yn;
        d[0] = yn += dy;
      } else {
        d[0] = 0;
        d[1] = dy;
      }
    }
  }
}
