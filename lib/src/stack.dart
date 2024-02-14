import 'area.dart';
import 'constant.dart';
import 'delegating_list.dart';
import 'offset/none.dart';
import 'offset/wiggle.dart';
import 'order/none.dart';
import 'pie.dart';

num stackValue<K>(Map<K, num> d, K key, _, __) {
  return d[key] ?? double.nan;
}

StackSeries<K, T> stackSeries<K, T>(K key) {
  final series = StackSeries<K, T>([]);
  return series..key = key;
}

/// Stacking converts lengths into contiguous position intervals.
///
/// For example, a bar chart of monthly sales might be broken down into a
/// multi-series bar chart by category, stacking bars vertically and applying a
/// categorical color encoding. Stacked charts can show overall value and
/// per-category value simultaneously; however, it is typically harder to
/// compare across categories as only the bottom layer of the stack is aligned.
/// So, chose the stack [order] carefully, and consider a streamgraph (see
/// [stackOffsetWiggle]). (See also
/// [grouped charts](https://observablehq.com/@d3/grouped-bar-chart/2?intent=fork).)
///
/// Like the [Pie] generator, the stack generator does not produce a shape
/// directly. Instead it computes positions which you can then pass to an
/// [Area] generator or use directly, say to position bars.
///
/// {@category Stacks}
class Stack<K, T> {
  /// The keys accessor;
  ///
  /// ```dart
  /// final stack = Stack(…)..keys = (thisArg, data, [args]) => ["apples", "bananas", "cherries", "durians"];
  ///
  /// stack.keys; // (thisArg, data, [args]) => ["apples", "bananas", "cherries", "durians"]
  /// ```
  ///
  /// The keys accessor defaults to the empty list. A series (layer) is
  /// generated (see [Stack.call]) for each key. Keys are typically strings, but
  /// they may be arbitrary values. The series’ key is passed to the [value]
  /// accessor, along with each data point, to compute the point’s value.
  List<K> Function(Stack<K, T>, Iterable<T>, [List<Object?>?]) keys =
      constant([]);

  /// The value accessor.
  ///
  /// ```dart
  /// final stack = Stack(…)..value = (d, key, i, data) => d[key];
  ///
  /// stack.value; // (d, key, i, data) => d[key]
  /// ```
  ///
  /// The value accessor defaults to:
  ///
  /// ```dart
  /// value(d, key, i, data) {
  ///   return d[key];
  /// }
  /// ```
  ///
  /// **CAUTION**: The default value accessor assumes that the input data is an
  /// list of maps exposing named properties with numeric values. This is a
  /// “wide” rather than “tidy” representation of data and is no longer
  /// recommended. See [Stack.call] for an example using tidy data.
  num Function(T, K, int, Iterable<T>) value;
  Iterable<int> Function(List<List<List<num>>>) _order = stackOrderNone;
  var _offset = stackOffsetNone;

  /// Constructs a new stack generator with the given [value] accessor.
  ///
  /// See [call] for usage.
  Stack(this.value);

  /// Constructs a new stack generator with the given [value] number.
  Stack.withConstants(num value) : value = constant(value);

  /// Generates a stack for the given list of [data] and returns an list
  /// representing each series.
  ///
  /// Any additional [args] are arbitrary; they are propagated to accessors
  /// along with the `this` object.
  ///
  /// For example, consider this tidy table of monthly fruit sales:
  ///
  /// date    | fruit    |   sales
  /// --------|----------|--------:
  ///  1/2015 | apples   |    3840
  ///  1/2015 | bananas  |    1920
  ///  1/2015 | cherries |     960
  ///  1/2015 | durians  |     400
  ///  2/2015 | apples   |    1600
  ///  2/2015 | bananas  |    1440
  ///  2/2015 | cherries |     960
  ///  2/2015 | durians  |     400
  ///  3/2015 | apples   |     640
  ///  3/2015 | bananas  |     960
  ///  3/2015 | cherries |     640
  ///  3/2015 | durians  |     400
  ///  4/2015 | apples   |     320
  ///  4/2015 | bananas  |     480
  ///  4/2015 | cherries |     640
  ///  4/2015 | durians  |     400
  ///
  /// This could be represented in Dart as an list of maps, perhaps parsed from
  /// [CSV](https://pub.dev/documentation/d4_dsv/latest/d4_dsv/d4_dsv-library.html):
  ///
  /// ```dart
  /// final data = [
  ///   {"date": DateTime.parse("2015-01-01"), "fruit": "apples", "sales": 3840},
  ///   {"date": DateTime.parse("2015-01-01"), "fruit": "bananas", "sales": 1920},
  ///   {"date": DateTime.parse("2015-01-01"), "fruit": "cherries", "sales": 960},
  ///   {"date": DateTime.parse("2015-01-01"), "fruit": "durians", "sales": 400},
  ///   {"date": DateTime.parse("2015-02-01"), "fruit": "apples", "sales": 1600},
  ///   {"date": DateTime.parse("2015-02-01"), "fruit": "bananas", "sales": 1440},
  ///   {"date": DateTime.parse("2015-02-01"), "fruit": "cherries", "sales": 960},
  ///   {"date": DateTime.parse("2015-02-01"), "fruit": "durians", "sales": 400},
  ///   {"date": DateTime.parse("2015-03-01"), "fruit": "apples", "sales": 640},
  ///   {"date": DateTime.parse("2015-03-01"), "fruit": "bananas", "sales": 960},
  ///   {"date": DateTime.parse("2015-03-01"), "fruit": "cherries", "sales": 640},
  ///   {"date": DateTime.parse("2015-03-01"), "fruit": "durians", "sales": 400},
  ///   {"date": DateTime.parse("2015-04-01"), "fruit": "apples", "sales": 320},
  ///   {"date": DateTime.parse("2015-04-01"), "fruit": "bananas", "sales": 480},
  ///   {"date": DateTime.parse("2015-04-01"), "fruit": "cherries", "sales": 640},
  ///   {"date": DateTime.parse("2015-04-01"), "fruit": "durians", "sales": 400}
  /// ];
  /// ```
  ///
  /// To compute the stacked series (a series, or layer, for each *fruit*; and a
  /// stack, or column, for each *date*), we can
  /// [index](https://pub.dev/documentation/d4_array/latest/d4_array/index.html)
  /// the data by *date* and then *fruit*, compute the distinct *fruit* names
  /// across the data set, and lastly get the *sales* value for each *date* and
  /// *fruit*.
  ///
  /// ```dart
  /// final series = (Stack(…)
  ///     ..keys = ((thisArg, data, [args]) => union(data.map((d) => d["fruit"])).toList()) // apples, bananas, cherries, …
  ///     ..value = (d, key, i, data) => d[key]["sales"])
  ///   (index2(data, (d) => d["date"], (d) => d["fruit"]).values);
  /// ```
  ///
  /// **TIP**: See
  /// [union](https://pub.dev/documentation/d4_array/latest/d4_array/union.html)
  /// and
  /// [index2](https://pub.dev/documentation/d4_array/latest/d4_array/index2.html)
  /// from d4_array.
  ///
  /// The resulting list has one element per *series*. Each series has one point
  /// per month, and each point has a lower and upper value defining the
  /// baseline and topline:
  ///
  /// ```dart
  /// [
  ///   [[   0, 3840], [   0, 1600], [   0,  640], [   0,  320]], // apples
  ///   [[3840, 5760], [1600, 3040], [ 640, 1600], [ 320,  800]], // bananas
  ///   [[5760, 6720], [3040, 4000], [1600, 2240], [ 800, 1440]], // cherries
  ///   [[6720, 7120], [4000, 4400], [2240, 2640], [1440, 1840]]  // durians
  /// ]
  /// ```
  ///
  /// Each series in then typically passed to an
  /// [area generator](https://pub.dev/documentation/d4_shape/latest/topics/Areas-topic.html)
  /// to render an area chart, or used to construct rectangles for a bar chart.
  ///
  /// ```dart
  /// svg.append("g")
  ///   .selectAll("g")
  ///   .data(series)
  ///   .join("g")
  ///     .attr("fill", (d) => color(d.key))
  ///   .selectAll("rect")
  ///   .data((D) => D)
  ///   .join("rect")
  ///     .attr("x", (d) => x(d["data"][0]))
  ///     .attr("y", (d) => y(d[1]))
  ///     .attr("height", (d) => y(d[0]) - y(d[1]))
  ///     .attr("width", x.bandwidth);
  /// ```
  ///
  /// The series are determined by the [keys] accessor; each series *i* in the
  /// returned list corresponds to the *i*th key. Each series is an list of
  /// points, where each point *j* corresponds to the *j*th element in the input
  /// *data*. Lastly, each point is represented as an list \[*y0*, *y1*\] where
  /// *y0* is the lower value (baseline) and *y1* is the upper value (topline);
  /// the difference between *y0* and *y1* corresponds to the computed [value]
  /// for this point. The key for each series is available as *series*.key, and
  /// the
  /// [index](https://pub.dev/documentation/d4_shape/latest/topics/Stack%20orders-topic.html)
  /// as *series*.index. The input data element for each point is available as
  /// *point*.data.
  List<StackSeries<K, T>> call(Iterable<T> data, [List<Object?>? args]) {
    var sz = keys(this, data, args).map(stackSeries<K, T>).toList();
    int i, n = sz.length, j = -1;
    List<int> oz;

    for (final d in data) {
      ++j;
      for (i = 0; i < n; ++i) {
        sz[i]
            .add(StackSeriesPoint([0, value(d, sz[i].key, j, data)])..data = d);
      }
    }

    oz = _order(sz).toList();
    for (i = 0; i < n; ++i) {
      sz[oz[i]].index = i;
    }

    _offset(sz, oz);
    return sz;
  }

  /// Defines the [Stack.keys]-accessor as a constant function that always
  /// returns the specified value.
  void constKeys(List<K> keys) {
    this.keys = constant(keys);
  }

  /// Defines the [Stack.value]-accessor as a constant function that always
  /// returns the specified value.
  void constValue(num value) {
    this.value = constant(value);
  }

  /// Given the generated series list, it must return an list of numeric indices
  /// representing the stack order.
  ///
  /// ```dart
  /// final stack = Stack(…)..order = stackOrderNone;
  ///
  /// stack.order; // stackOrderNone
  /// ```
  ///
  /// For example, to use reverse order of keys
  ///
  /// ```dart
  /// final stack = Stack(…)..order = (series) => range(stop: series.length).reversed;
  /// ```
  ///
  /// The stack order is computed prior to the [offset]; thus, the lower value
  /// for all points is zero at the time the order is computed. The index
  /// attribute for each series is also not set until after the order is
  /// computed.
  ///
  /// The order accessor defaults to [stackOrderNone]; this uses the order given
  /// by the [keys] accessor. See
  /// [stack orders](https://pub.dev/documentation/d4_shape/latest/topics/Stack%20orders-topic.html)
  /// for the built-in orders.
  Iterable<int> Function(List<List<List<num>>>) get order => _order;
  set order(Iterable<int> Function(List<List<List<num>>>)? order) {
    _order = order ?? stackOrderNone;
  }

  /// Given the generated series list and the order index list, it is then
  /// responsible for updating the lower and upper values in the series list.
  ///
  /// ```dart
  /// final stack = Stack(…)..offset = stackOffsetExpand;
  ///
  /// stack.offset; // stackOffsetExpand
  /// ```
  ///
  /// See the built-in offsets for a reference implementation.
  ///
  /// The offset accessor defaults to [stackOffsetNone]; this uses a zero
  /// baseline. See
  /// [stack offsets](https://pub.dev/documentation/d4_shape/latest/topics/Stack%20ofssets-topic.html)
  /// for the built-in offsets.
  void Function(List<List<List<num>>>, List<int>) get offset => _offset;
  set offset(void Function(List<List<List<num>>>, List<int>)? offset) {
    _offset = offset ?? stackOffsetNone;
  }

  /// Equivalent to [Stack.new], except that if [value] is not specified, its
  /// default is used.
  static Stack<K, Map<K, num>> withDefaults<K>(
      [num Function(Map<K, num>, K, int, Iterable<Map<K, num>>)? value]) {
    return Stack(value ?? stackValue);
  }
}

class StackSeries<K, T> extends DelegatingList<StackSeriesPoint<T>> {
  late final K key;
  late final int index;

  StackSeries(super.source);
}

class StackSeriesPoint<T> extends DelegatingList<num> {
  late final T data;

  StackSeriesPoint(super.source);
}
