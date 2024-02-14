import '../offset/wiggle.dart';
import 'appearance.dart';
import 'ascending.dart';

/// Returns a series order such that the earliest series (according to the
/// maximum value) are on the inside and the later series are on the outside.
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
///                 Plot.areaY(riaa, {x: "year", y: "revenue", z: "format", fill: "group", offset: "wiggle", order: "inside-out"}),
///             ]
///         });
///     }
/// </script>
///
/// ```dart
/// final stack = Stack(…)..order = stackOrderInsideOut;
/// ```
///
/// This order is recommended for streamgraphs in conjunction with the
/// [stackOffsetWiggle]. See
/// [Stacked Graphs — Geometry & Aesthetics](http://leebyron.com/streamgraph/)
/// by Byron & Wattenberg for more information.
///
/// {@category Stacks}
/// {@category Stack orders}
List<int> stackOrderInsideOut(List<List<List<num>>> series) {
  int n = series.length, i, j;
  var sums = series.map(sum).toList(),
      order = stackOrderAppearance(series),
      tops = <int>[],
      bottoms = <int>[];
  num top = 0, bottom = 0;

  for (i = 0; i < n; ++i) {
    j = order[i];
    if (top < bottom) {
      top += sums[j];
      tops.add(j);
    } else {
      bottom += sums[j];
      bottoms.add(j);
    }
  }

  return bottoms.reversed.followedBy(tops).toList();
}
