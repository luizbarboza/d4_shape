import 'arc.dart';
import 'constant.dart';
import 'delegating_map.dart';
import 'descending.dart';
import 'identity.dart';
import 'math.dart';

/// The pie generator computes the necessary angles to represent a tabular
/// dataset as a pie or donut chart; these angles can then be passed to an arc
/// generator. (The pie generator does not produce a shape directly.)
///
/// {@category Pies}
class Pie<T> {
  /// When a pie is generated (see [Pie.call]), the value accessor will be
  /// invoked for each element in the input data list, being passed the element
  /// `d`, the index `i`, and the list `data` as three arguments.
  ///
  /// ```dart
  /// final pie = Pie(…)..value = (d, i, data) => d["value"];
  ///
  /// pie.value; // (d, i, data) => d["value"]
  /// ```
  ///
  /// The value accessor defaults to:
  ///
  /// ```dart
  /// value(d, i, data) {
  ///   return d;
  /// }
  /// ```
  ///
  /// If your data are not numbers, then you should specify an accessor that
  /// returns the corresponding numeric value for a given datum. For example,
  /// given a CSV file with number and name fields:
  ///
  /// ```
  /// number,name
  /// 4,Locke
  /// 8,Reyes
  /// 15,Ford
  /// 16,Jarrah
  /// 23,Shephard
  /// 42,Kwon
  /// ```
  ///
  /// You might say:
  ///
  /// ```dart
  /// final data = await csv("lost.csv", autoType);
  /// final pie = Pie(…)..value = (d, i, data) => d["number"];
  /// final arcs = pie(data);
  /// ```
  ///
  /// This is similar to
  /// [mapping](https://api.dart.dev/stable/3.2.6/dart-core/Iterable/map.html)
  /// your data to values before invoking the pie generator:
  ///
  /// ```dart
  /// finak arcs = Pie(…)(data.map((d) => d["number"]));
  /// ```
  ///
  /// The benefit of an accessor is that the input data remains associated with
  /// the returned objects, thereby making it easier to access other fields of
  /// the data, for example to set the color or to add text labels.
  num Function(T, int, List<T>) value;
  Comparator<num>? _sortValues = descending;
  Comparator<T>? _sort;

  /// The overall start angle of the pie.
  ///
  /// ```dart
  /// final pie = Pie(…)..startAngle = (thisArg, [args]) => 0;
  ///
  /// pie.startAngle; // (thisArg, [args]) => 0
  /// ```
  ///
  /// The start angle is the *overall* start angle of the pie, *i.e.*, the start
  /// angle of the first arc. It is typically expressed as a constant number but
  /// can also be expressed as a function of data. When a function, the start
  /// angle accessor is invoked once, being passed this pie generator and the
  /// same arguments.
  ///
  /// The start angle accessor defaults to:
  ///
  /// ```dart
  /// startAngle(thisArg, [args]) {
  ///   return 0;
  /// }
  /// ```
  ///
  /// Angles are in radians, with 0 at -*y* (12 o’clock) and positive angles
  /// proceeding clockwise.
  num Function(Pie<T>, [List<Object?>?]) startAngle = constant(0);

  /// The overall end angle of the pie.
  ///
  /// ```dart
  /// final pie = Pie(…)..endAngle = (thisArg, [args]) => pi;
  ///
  /// pie.endAngle; // (thisArg, [args]) => pi
  /// ```
  ///
  /// The end angle here means the *overall* end angle of the pie, *i.e.*, the
  /// end angle of the last arc. It is typically expressed as a constant number
  /// but can also be expressed as a function of data. When a function, the end
  /// angle accessor is invoked once, being passed this pie generator and the
  /// same arguments.
  ///
  /// The end angle accessor defaults to:
  ///
  /// ```dart
  /// endAngle(thisArg, [args]) {
  ///   return pi;
  /// }
  /// ```
  ///
  /// Angles are in radians, with 0 at -*y* (12 o’clock) and positive angles
  /// proceeding clockwise. The value of the end angle is constrained to
  /// [startAngle] ± τ, such that |endAngle - startAngle| ≤ τ.
  num Function(Pie<T>, [List<Object?>?]) endAngle = constant(tau);

  /// The pad angle of the pie.
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
  /// final pie = Pie(…)..padAngle = (thisArg, [args]) => …;
  ///
  /// pie.padAngle; // (thisArg, [args]) => …
  /// ```
  ///
  /// The pad angle specifies the angular separation in radians between
  /// adjacent arcs. The total amount of padding is the specified *angle* times
  /// the number of elements in the input data list, and at most |[endAngle] -
  /// [startAngle]|; the remaining space is divided proportionally by [value]
  /// such that the relative area of each arc is preserved.
  ///
  /// The pad angle is typically expressed as a constant number but can also be
  /// expressed as a function of data. When a function, the pad angle accessor
  /// is invoked once, being passed this pie generator and the same arguments.
  ///
  /// The start angle accessor defaults to:
  ///
  /// ```dart
  /// padAngle(thisArg, [args]) {
  ///   return 0;
  /// }
  /// ```
  num Function(Pie<T>, [List<Object?>?]) padAngle = constant(0);

  /// Constructs a new pie generator with the given [value] accessor.
  Pie(this.value);

  /// Constructs a new stack generator with the given [value] number.
  Pie.withConstants(num value) : value = constant(value);

  /// Generates a pie for the given list of [data], returning an list of maps
  /// representing each datum’s arc angles.
  ///
  /// For example, given a set of numbers, here is how to compute the angles for
  /// a pie chart:
  ///
  /// ```dart
  /// final data = [1, 1, 2, 3, 5, 8, 13, 21];
  /// final pie = Pie((d, i, data) => d);
  /// final arcs = pie(data);
  /// ```
  ///
  /// The resulting `arcs` is an list of maps:
  ///
  /// ```dart
  /// [
  ///   {"value":  1, "index": 6, "startAngle": 6.050474740247008, "endAngle": 6.166830023713296, "padAngle": 0},
  ///   {"value":  1, "index": 7, "startAngle": 6.166830023713296, "endAngle": 6.283185307179584, "padAngle": 0},
  ///   {"value":  2, "index": 5, "startAngle": 5.817764173314431, "endAngle": 6.050474740247008, "padAngle": 0},
  ///   {"value":  3, "index": 4, "startAngle": 5.468698322915565, "endAngle": 5.817764173314431, "padAngle": 0},
  ///   {"value":  5, "index": 3, "startAngle": 4.886921905584122, "endAngle": 5.468698322915565, "padAngle": 0},
  ///   {"value":  8, "index": 2, "startAngle": 3.956079637853813, "endAngle": 4.886921905584122, "padAngle": 0},
  ///   {"value": 13, "index": 1, "startAngle": 2.443460952792061, "endAngle": 3.956079637853813, "padAngle": 0},
  ///   {"value": 21, "index": 0, "startAngle": 0.000000000000000, "endAngle": 2.443460952792061, "padAngle": 0}
  /// ]
  /// ```
  ///
  /// Each map in the returned list has the following properties:
  ///
  /// * `value` - the numeric [value] of the arc.
  /// * `index` - the zero-based [sort]ed index of the arc.
  /// * `startAngle` - the [startAngle] of the arc.
  /// * `endAngle` - the [endAngle] of the arc.
  /// * `padAngle` - the [padAngle] of the arc.
  ///
  /// This representation is designed to work with the arc generator’s default
  /// [Arc.startAngle], [Arc.endAngle] and [Arc.padAngle] accessors. Angles are
  /// in radians, with 0 at -*y* (12 o’clock) and positive angles proceeding
  /// clockwise.
  ///
  /// The length of the returned list is the same as [data], and each element
  /// *i* in the returned array corresponds to the element *i* in the input
  /// data. The returned list of arcs is in the same order as the data, even
  /// when the pie chart is sorted (see [sortValues]).
  ///
  /// Any additional [args] are arbitrary; they are propagated to the pie
  /// generator’s accessor functions along with the `this` object.
  List<PieArc> call(Iterable<T> data, [List<Object?>? args]) {
    int i, n = (data = data.toList()).length, j;
    var index = List.filled(n, 0), arcs = List<num>.filled(n, 0);
    num k,
        sum = 0,
        a0 = startAngle(this, args),
        da = min(tau, max(-tau, endAngle(this, args) - a0)),
        a1,
        p = min(da.abs() / n, padAngle(this, args)),
        pa = p * (da < 0 ? -1 : 1),
        v;
    List<PieArc?> arcs0 = List.filled(n, null);

    for (i = 0; i < n; ++i) {
      if ((v = arcs[index[i] = i] = value((data as List<T>)[i], i, data)) > 0) {
        sum += v;
      }
    }

    // Optionally sort the arcs by previously-computed values or by data.
    if (_sortValues != null) {
      index.sort((i, j) {
        return _sortValues!(arcs[i], arcs[j]);
      });
    } else if (_sort != null) {
      index.sort((i, j) {
        return _sort!((data as List<T>)[i], data[j]);
      });
    }

    // Compute the arcs! They are stored in the original data's order.
    k = sum != 0 ? (da - n * pa) / sum : 0;
    for (i = 0; i < n; ++i, a0 = a1) {
      j = index[i];
      v = arcs[j];
      a1 = a0 + (v > 0 ? v * k : 0) + pa;
      arcs0[j] = PieArc<T>({
        "index": i,
        "value": v,
        "startAngle": a0,
        "endAngle": a1,
        "padAngle": p
      }, (data as List<T>)[j]);
    }

    return arcs0.cast();
  }

  void constValue(num value) {
    this.value = constant(value);
  }

  /// The value comparator.
  ///
  /// ```dart
  /// final pie = Pie(…)..sortValues = (a, b) => ascending;
  ///
  /// pie.sortValues; // (a, b) => ascending
  /// ```
  ///
  /// The value comparator is similar to the data comparator ([sort]), except
  /// the two arguments *a* and *b* are values derived from the input data list
  /// using the value accessor ([sortValues]) rather than the data elements.
  /// If the arc for *a* should be before the arc for *b*, then the comparator
  /// must return a number less than zero; if the arc for *a* should be after
  /// the arc for *b*, then the comparator must return a number greater than
  /// zero; returning zero means that the relative order of *a* and *b* is
  /// unspecified.
  ///
  /// The value comparator defaults to
  /// [descending](https://pub.dev/documentation/d4_array/latest/d4_array/descending.html).
  /// If both the data comparator ([sort]) and the value comparator are null,
  /// then arcs are positioned in the original input order. Setting the value
  /// comparator implicitly sets the data comparator ([sort]) to null.
  ///
  /// Sorting does not affect the order of the generated arc list (see
  /// [Pie.call]) which is always in the same order as the input data list; it
  /// merely affects the computed angles of each arc. The first arc starts at
  /// the [startAngle] and the last arc ends at the [endAngle].
  int Function(num, num)? get sortValues => _sortValues;
  set sortValues(int Function(num, num)? sortValues) {
    _sortValues = sortValues;
    _sort = null;
  }

  /// The data comparator.
  ///
  /// ```dart
  /// final pie = Pie(…)..sort = (a, b) => ascending(a["name"], b["name"]);
  ///
  /// pie.sort; // (a, b) => ascending(a["name"], b["name"])
  /// ```
  ///
  /// The data comparator takes two arguments *a* and *b*, each elements from
  /// the input data array. If the arc for *a* should be before the arc for *b*,
  /// then the comparator must return a number less than zero; if the arc for
  /// *a* should be after the arc for *b*, then the comparator must return a
  /// number greater than zero; returning zero means that the relative order of
  /// *a* and *b* is unspecified.
  ///
  /// The data comparator defaults to null. If both the data comparator and the
  /// value comparator (see [sortValues]) are null, then arcs are positioned in
  /// the original input order. Setting the data comparator implicitly sets the
  /// value comparator to null.
  ///
  /// Sorting does not affect the order of the generated arc list (see
  /// [Pie.call]) which is always in the same order as the input data list; it
  /// only affects the computed angles of each arc. The first arc starts at the
  /// [startAngle] and the last arc ends at the [endAngle].
  int Function(T, T)? get sort => _sort;
  set sort(int Function(T, T)? sort) {
    _sort = sort;
    _sortValues = null;
  }

  /// Defines the [Pie.startAngle]-accessor as a constant function that always
  /// returns the specified value.
  void constStartAngle(num startAngle) {
    this.startAngle = constant(startAngle);
  }

  /// Defines the [Pie.endAngle]-accessor as a constant function that always
  /// returns the specified value.
  void constEndAngle(num endAngle) {
    this.endAngle = constant(endAngle);
  }

  /// Defines the [Pie.padAngle]-accessor as a constant function that always
  /// returns the specified value.
  void constPadAngle(num padAngle) {
    this.padAngle = constant(padAngle);
  }

  /// Equivalent to [Pie.new], except that if [value] is not specified, its
  /// default is used.
  static Pie<num> withDefaults(
      [num Function(num, int, List<num>) value = identity]) {
    return Pie<num>(value);
  }
}

class PieArc<T> extends DelegatingMap<String, num> {
  final T data;

  PieArc(super.source, this.data);
}
