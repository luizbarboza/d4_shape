import 'constant.dart';
import 'offset/none.dart';
import 'order/none.dart';
import 'stack.dart';

/// Equivalent to [Stack], except that it is designed to work with tidy data.
///
/// {@category Stacks}
class StackTidy<KL, KG, T> {
  /// The key accessor.
  ///
  /// ```dart
  /// final series = StackTidy<String, String, Map<String, String>>(
  ///     key: (d) => (d["name"]!, d["year"]!), …);
  ///
  /// series.key; // (d) => (d["name"]!, d["year"]!)
  /// ```
  ///
  /// The key accessor must return a two-part key: the layer key and the group
  /// key. And the [value] accessor mustn’t need to know the current keys.
  /// (Because the data is tidy, the value accessor is the same for all
  /// observations.)
  (KL, KG) Function(T) key;

  /// The value accessor.
  ///
  /// ```dart
  /// final series = StackTidy<String, String, Map<String, String>>(
  ///     value: (d) => num.parse(d["value"]!), …);
  ///
  /// stack.value; // (d) => num.parse(d["value"]!)
  /// ```
  num Function(T) value;

  StackOrder _order = stackOrderNone;
  StackOffset _offset = stackOffsetNone;

  /// Constructs a new stack generator with the given [key] and [value]
  /// accessors.
  ///
  /// ```dart
  /// final series = (StackTidy<String, String, Map<String, String>>(
  ///   key: (d) => (d["name"]!, d["year"]!),
  ///   value: (d) => num.parse(d["value"]!),
  /// )..order = stackOrderReverse)(data);
  /// ```
  ///
  /// See [call] for usage.
  StackTidy({required this.key, required this.value});

  /// Generates a stack for the given list of [data] and returns an list
  /// representing each series.
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
  /// stack, or column, for each *date*):
  ///
  /// ```dart
  /// final series = StackTidy<String, DateTime, Map<String, Object>>(
  ///   key: (d) => (d["fruit"] as String, d["date"] as DateTime),
  ///   value: (d) => d["sales"] as num,
  /// )(data);
  /// ```
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
  List<StackSeries<KL, T>> call(Iterable<T> data) {
    final layerKeys = <KL>{};
    final groupKeys = <KG>{};
    final values = <(KL, KG), (T, num)>{};
    final sz = <StackSeries<KL, T>>[];
    List<int> oz;

    for (final d in data) {
      final key = this.key(d);
      layerKeys.add(key.$1);
      groupKeys.add(key.$2);
      values[key] = (d, value(d));
    }

    for (final kl in layerKeys) {
      final layer = StackSeries<KL, T>([])..key = kl;
      sz.add(layer);
      for (final kg in groupKeys) {
        final v = values[(kl, kg)];
        layer.add(StackSeriesPoint([0, v?.$2 ?? 0])..data = v?.$1);
      }
    }

    oz = order(sz).toList();
    for (var i = 0; i < sz.length; ++i) {
      sz[oz[i]].index = i;
    }

    _offset(sz, oz);
    return sz;
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
  /// final stack = StackTidy(…)..order = stackOrderNone;
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
  /// The order accessor defaults to [stackOrderNone]. See [stack orders][] for
  /// the built-in orders.
  ///
  /// [stack orders]: https://pub.dev/documentation/d4_shape/latest/topics/Stack%20orders-topic.html
  Iterable<int> Function(List<List<List<num>>>) get order => _order;
  set order(Iterable<int> Function(List<List<List<num>>>)? order) {
    _order = order ?? stackOrderNone;
  }

  /// Given the generated series list and the order index list, it is then
  /// responsible for updating the lower and upper values in the series list.
  ///
  /// ```dart
  /// final stack = StackTidy(…)..offset = stackOffsetExpand;
  ///
  /// stack.offset; // stackOffsetExpand
  /// ```
  ///
  /// See the built-in offsets for a reference implementation.
  ///
  /// The offset accessor defaults to [stackOffsetNone]; this uses a zero
  /// baseline. See [stack offsets][] for the built-in offsets.
  ///
  /// [stack offsets]: https://pub.dev/documentation/d4_shape/latest/topics/Stack%20ofssets-topic.html
  void Function(List<List<List<num>>>, List<int>) get offset => _offset;
  set offset(void Function(List<List<List<num>>>, List<int>)? offset) {
    _offset = offset ?? stackOffsetNone;
  }
}
