import 'none.dart';

/// Applies a zero baseline and normalizes the values for each point such that
/// the topline is always one.
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
///                 percent: true
///             },
///             marks: [
///                 Plot.areaY(riaa, {x: "year", y: "revenue", z: "format", fill: "group", offset: "expand", order: "-appearance"}),
///                 Plot.ruleY([0])
///             ]
///         });
///     }
/// </script>
///
/// ```dart
/// final stack = Stack(…)..offset = stackOffsetExpand;
/// ```
///
/// {@category Stacks}
/// {@category Stack offsets}
void stackOffsetExpand(List<List<List<num>>> series, List<int> order) {
  int i, n;
  if (!((n = series.length) > 0)) return;
  num y0, y;
  for (var j = 0, m = series[0].length; j < m; ++j) {
    for (y = i = 0; i < n; ++i) {
      y0 = series[i][j][1];
      if (y0.isFinite) y += y0;
    }
    if (y != 0) {
      for (i = 0; i < n; ++i) {
        series[i][j][1] /= y;
      }
    }
  }
  stackOffsetNone(series, order);
}
