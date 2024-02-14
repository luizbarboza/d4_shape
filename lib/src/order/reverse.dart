import '../stack.dart';
import 'none.dart';

/// Returns the reverse of the given series order \[*n* - 1, *n* - 2, … 0\]
/// where *n* is the number of elements in *series*. Thus, the stack order is
/// given by the reverse of the key accessor (see [Stack.keys]).
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
///                 Plot.areaY(riaa, {x: "year", y: "revenue", z: "format", fill: "group", order: null, reverse: true}),
///                 Plot.ruleY([0])
///             ]
///         });
///     }
/// </script>
///
/// ```dart
/// final stack = Stack(…)..order = stackOrderReverse;
/// ```
///
/// {@category Stacks}
/// {@category Stack orders}
List<int> stackOrderReverse(List<List<List<num>>> series) {
  return stackOrderNone(series).reversed.toList();
}
