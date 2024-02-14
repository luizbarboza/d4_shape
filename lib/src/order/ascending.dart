import 'none.dart';

/// Returns a series order such that the smallest series (according to the sum
/// of values) is at the bottom.
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
///                 label: "Annual revenue (billions)",
///                 transform: (d) => d / 1000 // convert millions to billions
///             },
///             marks: [
///                 Plot.areaY(riaa, {x: "year", y: "revenue", z: "format", fill: "group", order: "sum"}),
///                 Plot.ruleY([0])
///             ]
///         });
///     }
/// </script>
///
/// ```dart
/// final stack = Stack(…)..order = stackOrderAscending;
/// ```
///
/// {@category Stacks}
/// {@category Stack orders}
List<int> stackOrderAscending(List<List<List<num>>> series) {
  var sums = series.map(sum).toList();
  return stackOrderNone(series)
    ..sort((a, b) {
      var s = sums[a] - sums[b];
      return s > 0
          ? 1
          : s < 0
              ? -1
              : 0;
    });
}

num sum(List<List<num>> series) {
  var i = -1, n = series.length;
  num s = 0, v;
  while (++i < n) {
    if ((v = series[i][1]) != 0 && !v.isNaN) s += v;
  }
  return s;
}
