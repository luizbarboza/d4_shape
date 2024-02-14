import 'package:d4_path/d4_path.dart';

import 'constant.dart';
import 'digits.dart';
import 'math.dart';
import 'pie.dart';

num arcInnerRadius(_, [List<Object?>? args]) {
  return (args![0] as Map)["innerRadius"];
}

num arcOuterRadius(_, [List<Object?>? args]) {
  return (args![0] as Map)["outerRadius"];
}

num arcStartAngle(_, [List<Object?>? args]) {
  return (args![0] as Map)["startAngle"];
}

num arcEndAngle(_, [List<Object?>? args]) {
  return (args![0] as Map)["endAngle"];
}

num arcPadAngle(_, [List<Object?>? args]) {
  return args?[0] != null
      ? (args![0] as Map)["padAngle"]
      : double.nan; // Note: optional!
}

List<num>? _intersect(
    num x0, num y0, num x1, num y1, num x2, num y2, num x3, num y3) {
  var x10 = x1 - x0,
      y10 = y1 - y0,
      x32 = x3 - x2,
      y32 = y3 - y2,
      t = y32 * x10 - x32 * y10;
  if (t * t < epsilon) return null;
  t = (x32 * (y0 - y2) - y32 * (x0 - x2)) / t;
  return [x0 + t * x10, y0 + t * y10];
}

// Compute perpendicular offset line of length rc.
// http://mathworld.wolfram.com/Circle-LineIntersection.html
Map<String, num> _cornerTangents(
    num x0, num y0, num x1, num y1, num r1, num rc, bool cw) {
  var x01 = x0 - x1,
      y01 = y0 - y1,
      lo = (cw ? rc : -rc) / sqrt(x01 * x01 + y01 * y01),
      ox = lo * y01,
      oy = -lo * x01,
      x11 = x0 + ox,
      y11 = y0 + oy,
      x10 = x1 + ox,
      y10 = y1 + oy,
      x00 = (x11 + x10) / 2,
      y00 = (y11 + y10) / 2,
      dx = x10 - x11,
      dy = y10 - y11,
      d2 = dx * dx + dy * dy,
      r = r1 - rc,
      D = x11 * y10 - x10 * y11,
      d = (dy < 0 ? -1 : 1) * sqrt(max(0, r * r * d2 - D * D)),
      cx0 = (D * dy - dx * d) / d2,
      cy0 = (-D * dx - dy * d) / d2,
      cx1 = (D * dy + dx * d) / d2,
      cy1 = (-D * dx + dy * d) / d2,
      dx0 = cx0 - x00,
      dy0 = cy0 - y00,
      dx1 = cx1 - x00,
      dy1 = cy1 - y00;

  // Pick the closer of the two intersection points.
  // TODO Is there a faster way to determine which intersection to use?
  if (dx0 * dx0 + dy0 * dy0 > dx1 * dx1 + dy1 * dy1) {
    cx0 = cx1;
    cy0 = cy1;
  }

  return {
    "cx": cx0,
    "cy": cy0,
    "x01": -ox,
    "y01": -oy,
    "x11": cx0 * (r1 / r - 1),
    "y11": cy0 * (r1 / r - 1)
  };
}

/// The arc generator produces a
/// [circular](https://en.wikipedia.org/wiki/Circular_sector) or
/// [annular](https://en.wikipedia.org/wiki/Annulus_(mathematics)) sector, as in
/// a [pie](https://observablehq.com/@d3/pie-chart/2?intent=fork) or
/// [donut](https://observablehq.com/@d3/donut-chart/2?intent=fork) chart.
///
/// Arcs are centered at the origin; use a
/// [transform](http://www.w3.org/TR/SVG/coords.html#TransformAttribute) to move
/// the arc to a different position.
///
/// ```dart
/// svg.append("path")
///     .attr("transform", "translate(100,100)")
///     .attr("d", Arc.withDefaults()([{
///       "innerRadius": 100,
///       "outerRadius": 200,
///       "startAngle": -pi / 2,
///       "endAngle": pi / 2
///     }]));
/// ```
///
/// If the absolute difference between the [startAngle] and the [endAngle] (the
/// *angular span*) is greater than 2π, the arc generator will produce a
/// complete circle or annulus. If it is less than 2π, the arc’s angular length
/// will be equal to the absolute difference between the two angles (going
/// clockwise if the signed difference is positive and anticlockwise if it is
/// negative). If the absolute difference is less than 2π, the arc may have
/// rounded corners (see [cornerRadius]) and angular padding (see [padAngle]).
///
/// See also the [Pie] generator, which computes the necessary angles to
/// represent an array of data as a pie or donut chart; these angles can then be
/// passed to an arc generator.
///
/// {@category Arcs}
class Arc with Digits {
  /// The inner radius accessor.
  ///
  /// ```dart
  /// final arc = Arc(…)..innerRadius = (thisArg, [args]) => 40;
  ///
  /// arc.innerRadius; // (thisArg, [args]) => 40
  /// ```
  ///
  /// The inner radius accessor defaults to:
  ///
  /// ```dart
  /// innerRadius(thisArg, [args]) {
  ///   args[0]["innerRadius"];
  /// }
  /// ```
  ///
  /// Specifying the inner radius as a function is useful for constructing a
  /// stacked polar bar chart, often in conjunction with a
  /// [sqrt scale](https://pub.dev/documentation/d4_scale/latest/topics/Pow%20scales-topic.html).
  /// More commonly, a constant inner radius is used for a donut or pie chart.
  /// If the outer radius is smaller than the inner radius, the inner and outer
  /// radii are swapped. A negative value is treated as zero.
  num Function(Arc, [List<Object?>?]) innerRadius;

  /// The outer radius accessor.
  ///
  /// ```dart
  /// final arc = Arc(…)..outerRadius = (thisArg, [args]) => 240;
  ///
  /// arc.outerRadius; // (thisArg, [args]) => 40
  /// ```
  ///
  /// The outer radius accessor defaults to:
  ///
  /// ```dart
  /// outerRadius(thisArg, [args]) {
  ///   args[0]["outerRadius"];
  /// }
  /// ```
  ///
  /// Specifying the outer radius as a function is useful for constructing a
  /// coxcomb or polar bar chart, often in conjunction with a
  /// [sqrt scale](https://pub.dev/documentation/d4_scale/latest/topics/Pow%20scales-topic.html).
  /// More commonly, a constant outer radius is used for a pie or donut
  /// chart. If the outer radius is smaller than the inner radius, the inner
  /// and outer radii are swapped. A negative value is treated as zero.
  num Function(Arc, [List<Object?>?]) outerRadius;

  /// The corner radius accessor.
  ///
  /// <div id="obs">
  ///     <div id="in"></div>
  ///     <div id="out"></div>
  /// </div>
  ///
  /// <script type="module">
  ///
  ///     import { Runtime, Inspector, Library } from "https://cdn.jsdelivr.net/npm/@observablehq/runtime@5/dist/runtime.js";
  ///     import * as d3 from "https://cdn.jsdelivr.net/npm/d3@7/+esm";
  ///
  ///     const stdlib = new Library;
  ///     const Inputs = await stdlib.Inputs();
  ///     const Generators = stdlib.Generators;
  ///
  ///     const padAngle = Inputs.range([0, 0.1], {label: "padAngle:", step: 0.001, value: 0.03});
  ///     const padRadius = Inputs.range([0, 400], {label: "padRadius:", step: 1, value: 200});
  ///     const cornerRadius = Inputs.range([0, 80], {label: "cornerRadius:", step: 1, value: 18});
  ///
  ///     const obs = d3.select("#obs");
  ///     obs.select("#in").append(() => cornerRadius);
  ///
  ///     const runtime = new Runtime();
  ///     const module = runtime.module();
  ///     const inspector = new Inspector(obs.select("#out").node());
  ///
  ///     module.define("padAngle", Generators.input(padAngle));
  ///     module.define("padRadius", Generators.input(padRadius));
  ///     module.define("cornerRadius", Generators.input(cornerRadius));
  ///     module.variable(inspector).define("out", ["padAngle", "padRadius", "cornerRadius"], definition);
  ///
  ///     function definition(padAngle, padRadius, cornerRadius) {
  ///         const width = 400;
  ///         const height = 400;
  ///         const outerRadius = height / 2 - 10;
  ///         const innerRadius = outerRadius / 3;
  ///         const data = [1, 1, 2, 3, 5, 8, 13, 21];
  ///         const pie = d3.pie().padAngle(padAngle);
  ///         const arc = d3.arc().innerRadius(innerRadius).outerRadius(outerRadius).padRadius(padRadius);
  ///
  ///         const svg = d3.create("svg")
  ///             .attr("width", width)
  ///             .attr("height", height)
  ///             .attr("viewBox", [-width / 2, -height / 2, width, height])
  ///             .attr("style", "max-width: 100%; height: auto;");
  ///
  ///         svg.selectChildren("[fill='none']")
  ///             .data(cornerRadius ? [null] : [])
  ///             .join("g")
  ///             .attr("fill", "none")
  ///             .attr("stroke", "currentColor")
  ///             .selectAll("path")
  ///             .data(pie(data))
  ///             .join("path")
  ///             .attr("d", arc.cornerRadius(0));
  ///
  ///         svg.selectChildren("[fill='currentColor']")
  ///             .data([null])
  ///             .join("g")
  ///             .attr("fill", "currentColor")
  ///             .attr("fill-opacity", 0.2)
  ///             .attr("stroke", "currentColor")
  ///             .attr("stroke-width", "1.5px")
  ///             .attr("stroke-linejoin", "round")
  ///             .selectAll("path")
  ///             .data(pie(data))
  ///             .join("path")
  ///             .attr("d", arc.cornerRadius(cornerRadius));
  ///
  ///         return svg.node();
  ///     }
  /// </script>
  ///
  /// ```dart
  /// final arc = Arc(…)..cornerRadius = (thisArg, [args]) => 18;
  ///
  /// arc.cornerRadius; // (thisArg, [args]) => 18
  /// ```
  ///
  /// The corner radius accessor defaults to:
  ///
  /// ```dart
  /// cornerRadius(thisArg, [args]) {
  ///   args[0]["cornerRadius"];
  /// }
  /// ```
  ///
  /// If the corner radius is greater than zero, the corners of the arc are
  /// rounded using circles of the given radius. For a circular sector, the
  /// two outer corners are rounded; for an annular sector, all four corners
  /// are rounded.
  ///
  /// The corner radius may not be larger than ([outerRadius] -
  /// [innerRadius]) / 2. In addition, for arcs whose angular span is less
  /// than π, the corner radius may be reduced as two adjacent rounded
  /// corners intersect. This occurs more often with the inner corners. See
  /// the [arc corners animation](https://observablehq.com/@d3/arc-corners)
  /// for illustration.
  num Function(Arc, [List<Object?>?]) cornerRadius;

  /// The start angle accessor.
  ///
  /// ```dart
  /// final arc = Arc(…)..startAngle = (thisArg, [args]) => pi / 4;
  ///
  /// arc.startAngle; // (thisArg, [args]) => 0.7853981633974483
  /// ```
  ///
  /// The start angle accessor defaults to:
  ///
  /// ```dart
  /// startAngle(thisArg, [args]) {
  ///   args[0]["startAngle"];
  /// }
  /// ```
  ///
  /// The *angle* is specified in radians, with 0 at -*y* (12 o’clock) and
  /// positive angles proceeding clockwise. If |[endAngle] - [startAngle]| ≥
  /// 2π, a complete circle or annulus is generated rather than a sector.
  num Function(Arc, [List<Object?>?]) startAngle;

  /// The end angle accessor.
  ///
  /// ```dart
  /// final arc = Arc(…)..endAngle = (thisArg, [args]) => pi;
  ///
  /// arc.endAngle; // (thisArg, [args]) => 3.141592653589793
  /// ```
  ///
  /// The end angle accessor defaults to:
  ///
  /// ```dart
  /// endAngle(thisArg, [args]) {
  ///   args[0]["endAngle"];
  /// }
  /// ```
  ///
  /// The *angle* is specified in radians, with 0 at -*y* (12 o’clock) and
  /// positive angles proceeding clockwise. If |[endAngle] - [startAngle]| ≥
  /// 2π, a complete circle or annulus is generated rather than a sector.
  num Function(Arc, [List<Object?>?]) endAngle;

  /// The pad angle accessor.
  ///
  /// <div id="obs">
  ///     <div id="in"></div>
  ///     <div id="out"></div>
  /// </div>
  ///
  /// <script type="module">
  ///
  ///     import { Runtime, Inspector, Library } from "https://cdn.jsdelivr.net/npm/@observablehq/runtime@5/dist/runtime.js";
  ///     import * as d3 from "https://cdn.jsdelivr.net/npm/d3@7/+esm";
  ///
  ///     const stdlib = new Library;
  ///     const Inputs = await stdlib.Inputs();
  ///     const Generators = stdlib.Generators;
  ///
  ///     const padAngle = Inputs.range([0, 0.1], {label: "padAngle:", step: 0.001, value: 0.03});
  ///     const padRadius = Inputs.range([0, 400], {label: "padRadius:", step: 1, value: 200});
  ///     const cornerRadius = Inputs.range([0, 80], {label: "cornerRadius:", step: 1, value: 0});
  ///
  ///     const obs = d3.select("#obs");
  ///     obs.select("#in").append(() => padAngle);
  ///
  ///     const runtime = new Runtime();
  ///     const module = runtime.module();
  ///     const inspector = new Inspector(obs.select("#out").node());
  ///
  ///     module.define("padAngle", Generators.input(padAngle));
  ///     module.define("padRadius", Generators.input(padRadius));
  ///     module.define("cornerRadius", Generators.input(cornerRadius));
  ///     module.variable(inspector).define("out", ["padAngle", "padRadius", "cornerRadius"], definition);
  ///
  ///     function definition(padAngle, padRadius, cornerRadius) {
  ///         const width = 400;
  ///         const height = 400;
  ///         const outerRadius = height / 2 - 10;
  ///         const innerRadius = outerRadius / 3;
  ///         const data = [1, 1, 2, 3, 5, 8, 13, 21];
  ///         const pie = d3.pie().padAngle(padAngle);
  ///         const arc = d3.arc().innerRadius(innerRadius).outerRadius(outerRadius).padRadius(padRadius);
  ///
  ///         const svg = d3.create("svg")
  ///             .attr("width", width)
  ///             .attr("height", height)
  ///             .attr("viewBox", [-width / 2, -height / 2, width, height])
  ///             .attr("style", "max-width: 100%; height: auto;");
  ///
  ///         svg.selectChildren("[fill='none']")
  ///             .data(cornerRadius ? [null] : [])
  ///             .join("g")
  ///             .attr("fill", "none")
  ///             .attr("stroke", "currentColor")
  ///             .selectAll("path")
  ///             .data(pie(data))
  ///             .join("path")
  ///             .attr("d", arc.cornerRadius(0));
  ///
  ///         svg.selectChildren("[fill='currentColor']")
  ///             .data([null])
  ///             .join("g")
  ///             .attr("fill", "currentColor")
  ///             .attr("fill-opacity", 0.2)
  ///             .attr("stroke", "currentColor")
  ///             .attr("stroke-width", "1.5px")
  ///             .attr("stroke-linejoin", "round")
  ///             .selectAll("path")
  ///             .data(pie(data))
  ///             .join("path")
  ///             .attr("d", arc.cornerRadius(cornerRadius));
  ///
  ///         return svg.node();
  ///     }
  /// </script>
  ///
  /// ```dart
  /// final arc = Arc(…)..padAngle = (thisArg, [args]) => 0;
  ///
  /// arc.padAngle; // (thisArg, [args]) => 0
  /// ```
  ///
  /// The pad angle accessor defaults to:
  ///
  /// ```dart
  /// padAngle(thisArg, [args]) {
  ///   args?[0] != null ? args[0]["padAngle"] : double.nan;
  /// }
  /// ```
  ///
  /// The pad angle is converted to a fixed linear distance separating adjacent
  /// arcs, defined as [padRadius] × padAngle. This distance is subtracted
  /// equally from the [startAngle] and [endAngle] of the arc. If the arc forms
  /// a complete circle or annulus, as when |endAngle - startAngle| ≥ 2π, the
  /// pad angle is ignored.
  ///
  /// If the [innerRadius] or angular span is small relative to the pad angle,
  /// it may not be possible to maintain parallel edges between adjacent arcs.
  /// In this case, the inner edge of the arc may collapse to a point, similar
  /// to a circular sector. For this reason, padding is typically only applied
  /// to annular sectors (*i.e.*, when innerRadius is positive), as shown in
  /// this diagram:
  ///
  /// The recommended minimum inner radius when using padding is outerRadius \*
  /// padAngle / sin(θ), where θ is the angular span of the smallest arc before
  /// padding. For example, if the outer radius is 200 pixels and the pad angle
  /// is 0.02 radians, a reasonable θ is 0.04 radians, and a reasonable inner
  /// radius is 100 pixels. See the
  /// [arc padding animation](https://observablehq.com/@d3/arc-pad-angle) for
  /// illustration.
  ///
  /// Often, the pad angle is not set directly on the arc generator, but is
  /// instead computed by the
  /// [pie generator](https://pub.dev/documentation/d4_shape/latest/topics/Pies-topic.html)
  /// so as to ensure that the area of padded arcs is proportional to their
  /// value; see [Pie.padAngle]. See the
  /// [pie padding animation](https://observablehq.com/@d3/arc-pad-angle) for
  /// illustration. If you apply a constant pad angle to the arc generator
  /// directly, it tends to subtract disproportionately from smaller arcs,
  /// introducing distortion.
  num Function(Arc, [List<Object?>?]) padAngle;

  /// The pad radius accessor.
  ///
  /// <div id="obs">
  ///     <div id="in"></div>
  ///     <div id="out"></div>
  /// </div>
  ///
  /// <script type="module">
  ///
  ///     import { Runtime, Inspector, Library } from "https://cdn.jsdelivr.net/npm/@observablehq/runtime@5/dist/runtime.js";
  ///     import * as d3 from "https://cdn.jsdelivr.net/npm/d3@7/+esm";
  ///
  ///     const stdlib = new Library;
  ///     const Inputs = await stdlib.Inputs();
  ///     const Generators = stdlib.Generators;
  ///
  ///     const padAngle = Inputs.range([0, 0.1], {label: "padAngle:", step: 0.001, value: 0.03});
  ///     const padRadius = Inputs.range([0, 400], {label: "padRadius:", step: 1, value: 200});
  ///     const cornerRadius = Inputs.range([0, 80], {label: "cornerRadius:", step: 1, value: 0});
  ///
  ///     const obs = d3.select("#obs");
  ///     obs.select("#in").append(() => padRadius);
  ///
  ///     const runtime = new Runtime();
  ///     const module = runtime.module();
  ///     const inspector = new Inspector(obs.select("#out").node());
  ///
  ///     module.define("padAngle", Generators.input(padAngle));
  ///     module.define("padRadius", Generators.input(padRadius));
  ///     module.define("cornerRadius", Generators.input(cornerRadius));
  ///     module.variable(inspector).define("out", ["padAngle", "padRadius", "cornerRadius"], definition);
  ///
  ///     function definition(padAngle, padRadius, cornerRadius) {
  ///         const width = 400;
  ///         const height = 400;
  ///         const outerRadius = height / 2 - 10;
  ///         const innerRadius = outerRadius / 3;
  ///         const data = [1, 1, 2, 3, 5, 8, 13, 21];
  ///         const pie = d3.pie().padAngle(padAngle);
  ///         const arc = d3.arc().innerRadius(innerRadius).outerRadius(outerRadius).padRadius(padRadius);
  ///
  ///         const svg = d3.create("svg")
  ///             .attr("width", width)
  ///             .attr("height", height)
  ///             .attr("viewBox", [-width / 2, -height / 2, width, height])
  ///             .attr("style", "max-width: 100%; height: auto;");
  ///
  ///         svg.selectChildren("[fill='none']")
  ///             .data(cornerRadius ? [null] : [])
  ///             .join("g")
  ///             .attr("fill", "none")
  ///             .attr("stroke", "currentColor")
  ///             .selectAll("path")
  ///             .data(pie(data))
  ///             .join("path")
  ///             .attr("d", arc.cornerRadius(0));
  ///
  ///         svg.selectChildren("[fill='currentColor']")
  ///             .data([null])
  ///             .join("g")
  ///             .attr("fill", "currentColor")
  ///             .attr("fill-opacity", 0.2)
  ///             .attr("stroke", "currentColor")
  ///             .attr("stroke-width", "1.5px")
  ///             .attr("stroke-linejoin", "round")
  ///             .selectAll("path")
  ///             .data(pie(data))
  ///             .join("path")
  ///             .attr("d", arc.cornerRadius(cornerRadius));
  ///
  ///         return svg.node();
  ///     }
  /// </script>
  ///
  /// The pad radius accessor defaults to null, indicating that the pad radius
  /// should be automatically computed as sqrt([innerRadius] × innerRadius +
  /// [outerRadius] × outerRadius). The pad radius determines the fixed linear
  /// distance separating adjacent arcs, defined as padRadius × [padAngle].
  num Function(Arc, [List<Object?>?])? padRadius;

  /// Optional context for rendering the generated link (see [Arc.call]) as a
  /// sequence of
  /// [path method](http://www.w3.org/TR/2dcontext/#canvaspathmethods) calls.
  ///
  /// ```dart
  /// final context = …;
  /// final arc = Arc(…)..context = context;
  ///
  /// arc.context; // context
  /// ```
  ///
  /// Defaults to null, which means the generated link is returned as a
  /// [path data](http://www.w3.org/TR/SVG/paths.html#PathData)
  /// string.
  Path? context;

  /// Constructs a new arc generator with the given [innerRadius],
  /// [outerRadius], [cornerRadius], [startAngle], [endAngle], [padAngle], and,
  /// optionally, [padRadius] accessors.
  Arc(
      {required this.innerRadius,
      required this.outerRadius,
      num Function(Arc, [List<Object?>?])? cornerRadius,
      required this.startAngle,
      required this.endAngle,
      required this.padAngle,
      this.padRadius})
      : cornerRadius = cornerRadius ?? constant(0) as dynamic;

  /// Constructs a new arc generator with the given [innerRadius],
  /// [outerRadius], [cornerRadius], [startAngle], [endAngle], [padAngle], and,
  /// optionally, [padRadius] numbers.
  Arc.withConstants(
      {required num innerRadius,
      required num outerRadius,
      num? cornerRadius,
      required num startAngle,
      required num endAngle,
      required num padAngle,
      num? padRadius})
      : this(
            innerRadius: constant(innerRadius),
            outerRadius: constant(outerRadius),
            cornerRadius: constant(cornerRadius ?? 0),
            startAngle: constant(startAngle),
            endAngle: constant(endAngle),
            padAngle: constant(padAngle),
            padRadius: padRadius != null ? constant(padRadius) : null);

  /// Generates an arc for the given [args].
  ///
  /// The [args] are arbitrary; they are propagated to the arc generator’s
  /// accessor functions along with the `this` object. For example, with the
  /// default settings, an object with radii and angles is expected:
  ///
  /// ```dart
  /// final arc = Arc(…);
  ///
  /// arc([{
  ///   "innerRadius": 0,
  ///   "outerRadius": 100,
  ///   "startAngle": 0,
  ///   "endAngle": Math.PI / 2
  /// }]); // "M0,-100A100,100,0,0,1,100,0L0,0Z"
  /// ```
  ///
  /// If the radii and angles are instead defined as constants, you can generate
  /// an arc without any arguments:
  ///
  /// ```dart
  /// (Arc(…)
  ///     ..constInnerRadius(0)
  ///     ..constOuterRadius(100)
  ///     ..constStartAngle(0)
  ///     ..constEndAngle(pi / 2))
  ///   (); // "M0,-100A100,100,0,0,1,100,0L0,0Z"
  /// ```
  ///
  /// If the arc generator has a [context], then the arc is rendered to this
  /// context as a sequence of
  /// [path method](http://www.w3.org/TR/2dcontext/#canvaspathmethods) calls and
  /// this function returns void.
  /// Otherwise, a [path data](http://www.w3.org/TR/SVG/paths.html#PathData)
  /// string is returned.
  String? call([List<Object?>? args]) {
    Path? buffer;
    num r,
        r0 = innerRadius(this, args),
        r1 = outerRadius(this, args),
        a0 = startAngle(this, args) - halfPi,
        a1 = endAngle(this, args) - halfPi,
        da = abs(a1 - a0);
    var cw = a1 > a0;

    context ??= buffer = path();

    // Ensure that the outer radius is always larger than the inner radius.
    if (r1 < r0) {
      r = r1;
      r1 = r0;
      r0 = r;
    }

    // Is it a point?
    if (!(r1 > epsilon)) {
      context!.moveTo(0, 0);
    } else if (da > tau - epsilon) {
      context!.moveTo(r1 * cos(a0), r1 * sin(a0));
      context!.arc(0, 0, r1, a0, a1, !cw);
      if (r0 > epsilon) {
        context!.moveTo(r0 * cos(a1), r0 * sin(a1));
        context!.arc(0, 0, r0, a1, a0, cw);
      }
    }

    // Or is it a circular or annular sector?
    else {
      var a01 = a0,
          a11 = a1,
          a00 = a0,
          a10 = a1,
          da0 = da,
          da1 = da,
          ap = padAngle(this, args) / 2,
          rp = (ap > epsilon)
              ? (padRadius != null
                  ? padRadius!(this, args)
                  : sqrt(r0 * r0 + r1 * r1))
              : 0,
          rc = min(abs(r1 - r0) / 2, cornerRadius(this, args)),
          rc0 = rc,
          rc1 = rc;
      Map<String, num> t0, t1;

      // Apply padding? Note that since r1 ≥ r0, da1 ≥ da0.
      if (rp > epsilon) {
        var p0 = asin(rp / r0 * sin(ap)), p1 = asin(rp / r1 * sin(ap));
        if ((da0 -= p0 * 2) > epsilon) {
          p0 *= (cw ? 1 : -1);
          a00 += p0;
          a10 -= p0;
        } else {
          da0 = 0;
          a00 = a10 = (a0 + a1) / 2;
        }
        if ((da1 -= p1 * 2) > epsilon) {
          p1 *= (cw ? 1 : -1);
          a01 += p1;
          a11 -= p1;
        } else {
          da1 = 0;
          a01 = a11 = (a0 + a1) / 2;
        }
      }

      var x01 = r1 * cos(a01),
          y01 = r1 * sin(a01),
          x10 = r0 * cos(a10),
          y10 = r0 * sin(a10),
          x11 = r1 * cos(a11),
          y11 = r1 * sin(a11),
          x00 = r0 * cos(a00),
          y00 = r0 * sin(a00);

      List<num>? oc;

      // Apply rounded corners?
      if (rc > epsilon) {
        // Restrict the corner radius according to the sector angle. If this
        // intersection fails, it’s probably because the arc is too small, so
        // disable the corner radius entirely.
        if (da < pi) {
          if ((oc = _intersect(x01, y01, x00, y00, x11, y11, x10, y10)) !=
              null) {
            var ax = x01 - oc![0],
                ay = y01 - oc[1],
                bx = x11 - oc[0],
                by = y11 - oc[1],
                kc = 1 /
                    sin(acos((ax * bx + ay * by) /
                            (sqrt(ax * ax + ay * ay) *
                                sqrt(bx * bx + by * by))) /
                        2),
                lc = sqrt(oc[0] * oc[0] + oc[1] * oc[1]);
            rc0 = min(rc, (r0 - lc) / (kc - 1));
            rc1 = min(rc, (r1 - lc) / (kc + 1));
          } else {
            rc0 = rc1 = 0;
          }
        }
      }

      // Is the sector collapsed to a line?
      if (!(da1 > epsilon)) {
        context!.moveTo(x01, y01);
      } else if (rc1 > epsilon) {
        t0 = _cornerTangents(x00, y00, x01, y01, r1, rc1, cw);
        t1 = _cornerTangents(x11, y11, x10, y10, r1, rc1, cw);

        context!.moveTo(t0["cx"]! + t0["x01"]!, t0["cy"]! + t0["y01"]!);

        // Have the corners merged?
        if (rc1 < rc) {
          context!.arc(t0["cx"]!, t0["cy"]!, rc1, atan2(t0["y01"]!, t0["x01"]!),
              atan2(t1["y01"]!, t1["x01"]!), !cw);
        } else {
          context!.arc(t0["cx"]!, t0["cy"]!, rc1, atan2(t0["y01"]!, t0["x01"]!),
              atan2(t0["y11"]!, t0["x11"]!), !cw);
          context!.arc(
              0,
              0,
              r1,
              atan2(t0["cy"]! + t0["y11"]!, t0["cx"]! + t0["x11"]!),
              atan2(t1["cy"]! + t1["y11"]!, t1["cx"]! + t1["x11"]!),
              !cw);
          context!.arc(t1["cx"]!, t1["cy"]!, rc1, atan2(t1["y11"]!, t1["x11"]!),
              atan2(t1["y01"]!, t1["x01"]!), !cw);
        }
      }

      // Or is the outer ring just a circular arc?
      else {
        context!.moveTo(x01, y01);
        context!.arc(0, 0, r1, a01, a11, !cw);
      }

      // Is there no inner ring, and it’s a circular sector?
      // Or perhaps it’s an annular sector collapsed due to padding?
      if (!(r0 > epsilon) || !(da0 > epsilon)) {
        context!.lineTo(x10, y10);
      } else if (rc0 > epsilon) {
        t0 = _cornerTangents(x10, y10, x11, y11, r0, -rc0, cw);
        t1 = _cornerTangents(x01, y01, x00, y00, r0, -rc0, cw);

        context!.lineTo(t0["cx"]! + t0["x01"]!, t0["cy"]! + t0["y01"]!);

        // Have the corners merged?
        if (rc0 < rc) {
          context!.arc(t0["cx"]!, t0["cy"]!, rc0, atan2(t0["y01"]!, t0["x01"]!),
              atan2(t1["y01"]!, t1["x01"]!), !cw);
        } else {
          context!.arc(t0["cx"]!, t0["cy"]!, rc0, atan2(t0["y01"]!, t0["x01"]!),
              atan2(t0["y11"]!, t0["x11"]!), !cw);
          context!.arc(
              0,
              0,
              r0,
              atan2(t0["cy"]! + t0["y11"]!, t0["cx"]! + t0["x11"]!),
              atan2(t1["cy"]! + t1["y11"]!, t1["cx"]! + t1["x11"]!),
              cw);
          context!.arc(t1["cx"]!, t1["cy"]!, rc0, atan2(t1["y11"]!, t1["x11"]!),
              atan2(t1["y01"]!, t1["x01"]!), !cw);
        }
      }

      // Or is the inner ring just a circular arc?
      else {
        context!.arc(0, 0, r0, a10, a00, cw);
      }
    }

    context!.closePath();

    if (buffer != null) {
      context = null;
      return buffer.toString();
    }

    return null;
  }

  /// Computes the midpoint \[*x*, *y*\] of the center line of the arc that
  /// would be generated (see [Arc.call]) by the given arguments.
  ///
  /// The [args] are arbitrary; they are propagated to the arc generator’s
  /// accessor functions along with the `this` object. To be consistent with the
  /// generated arc, the accessors must be deterministic, *i.e.*, return the
  /// same value given the same arguments. The midpoint is defined as
  /// ([startAngle] + [endAngle]) / 2 and ([innerRadius] + [outerRadius]) / 2.
  /// For example:
  ///
  /// Note that this is **not the geometric center** of the arc, which may be
  /// outside the arc; this method is merely a convenience for positioning
  /// labels.
  List<num> centroid([List<Object?>? args]) {
    var r = (innerRadius(this, args) + outerRadius(this, args)) / 2,
        a = (startAngle(this, args) + endAngle(this, args)) / 2 - pi / 2;
    return [cos(a) * r, sin(a) * r];
  }

  /// Defines the [Arc.innerRadius]-accessor as a constant function that always
  /// returns the specified value.
  void constInnerRadius(num innerRadius) {
    this.innerRadius = constant(innerRadius);
  }

  /// Defines the [Arc.outerRadius]-accessor as a constant function that always
  /// returns the specified value.
  void constOuterRadius(num outerRadius) {
    this.outerRadius = constant(outerRadius);
  }

  /// Defines the [Arc.cornerRadius]-accessor as a constant function that always
  /// returns the specified value.
  void constCornerRadius(num cornerRadius) {
    this.cornerRadius = constant(cornerRadius);
  }

  /// Defines the [Arc.padRadius]-accessor as a constant function that always
  /// returns the specified value.
  void constPadRadius(num padRadius) {
    this.padRadius = constant(padRadius);
  }

  /// Defines the [Arc.startAngle]-accessor as a constant function that always
  /// returns the specified value.
  void constStartAngle(num startAngle) {
    this.startAngle = constant(startAngle);
  }

  /// Defines the [Arc.endAngle]-accessor as a constant function that always
  /// returns the specified value.
  void constEndAngle(num endAngle) {
    this.endAngle = constant(endAngle);
  }

  /// Defines the [Arc.padAngle]-accessor as a constant function that always
  /// returns the specified value.
  void constPadAngle(num padAngle) {
    this.padAngle = constant(padAngle);
  }

  /// The maximum number of digits after the decimal separator.
  ///
  /// ```dart
  /// final arc = Arc(…)..digits = 3;
  ///
  /// arc.digits; // 3
  /// ```
  ///
  /// This option only applies when the associated [context] is null, as when
  /// this arc generator is used to produce
  /// [path data](http://www.w3.org/TR/SVG/paths.html#PathData).
  @override
  get digits;

  /// Constructs a new arc generator with the default settings.
  ///
  /// ```dart
  /// final arc = Arc.withDefaults();
  /// ```
  ///
  /// Or, with the radii and angles configured as constants:
  ///
  /// ```dart
  /// final arc = Arc.withDefaults()
  ///     ..constInnerRadius(0)
  ///     ..constOuterRadius(100)
  ///     ..constStartAngle(0)
  ///     ..constEndAngle(pi / 2);
  /// ```
  static Arc withDefaults(
      {num Function(Arc, [List<Object?>?]) innerRadius = arcInnerRadius,
      num Function(Arc, [List<Object?>?]) outerRadius = arcOuterRadius,
      num Function(Arc, [List<Object?>?])? cornerRadius,
      num Function(Arc, [List<Object?>?]) startAngle = arcStartAngle,
      num Function(Arc, [List<Object?>?]) endAngle = arcEndAngle,
      num Function(Arc, [List<Object?>?]) padAngle = arcPadAngle,
      num Function(Arc, [List<Object?>?])? padRadius}) {
    return Arc(
        innerRadius: innerRadius,
        outerRadius: outerRadius,
        cornerRadius: cornerRadius,
        startAngle: startAngle,
        endAngle: endAngle,
        padAngle: padAngle,
        padRadius: padRadius);
  }
}
