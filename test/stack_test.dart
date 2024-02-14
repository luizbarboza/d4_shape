import 'package:d4_shape/d4_shape.dart';
import 'package:d4_shape/src/stack.dart';
import 'package:test/test.dart';

void main() {
  test("Stack.withDefaults() has the expected defaults", () {
    final s = Stack.withDefaults();
    expect(s.keys(s, []), []);
    expect(s.value({"foo": 42}, "foo", 0, []), 42);
    expect(s.order, stackOrderNone);
    expect(s.offset, stackOffsetNone);
  });

  test("stack(data) computes the stacked series for the given data", () {
    final s = Stack<int, List<num>>((d, k, _, __) => d[k])
      ..constKeys([0, 1, 2, 3]);
    const data = [
      [1, 3, 5, 1],
      [2, 4, 2, 3],
      [1, 2, 4, 2]
    ];
    expect(s(data), [
      series([
        [0, 1],
        [0, 2],
        [0, 1]
      ], data, 0, 0),
      series([
        [1, 4],
        [2, 6],
        [1, 3]
      ], data, 1, 1),
      series([
        [4, 9],
        [6, 8],
        [3, 7]
      ], data, 2, 2),
      series([
        [9, 10],
        [8, 11],
        [7, 9]
      ], data, 3, 3)
    ]);
  });

  test("stack.keys(array) sets the array of constant keys", () {
    final s = Stack.withDefaults()..constKeys(["0.0", "2.0", "4.0"]);
    expect(s.keys(s, []), ["0.0", "2.0", "4.0"]);
  });

  test("stack.keys(function) sets the key accessor function", () {
    final s = Stack.withDefaults()
      ..keys = (_, __, [___]) {
        return "abc".split("");
      };
    expect(s.keys(s, []), ["a", "b", "c"]);
  });

  test(
      "stack(data, arguments…) passes the key accessor any additional arguments",
      () {
    late String a0, b0;
    k(_, data, [args]) {
      var [a, b] = args;
      a0 = a;
      b0 = b;
      return List.generate(data[0].length, (i) => i);
    }

    var s = Stack<int, List<num>>((d, k, _, __) => d[k])..keys = k;
    var data = [
      [1, 3, 5, 1],
      [2, 4, 2, 3],
      [1, 2, 4, 2]
    ];
    expect(s(data, ["foo", "bar"]), [
      series([
        [0, 1],
        [0, 2],
        [0, 1]
      ], data, "0", 0),
      series([
        [1, 4],
        [2, 6],
        [1, 3]
      ], data, "1", 1),
      series([
        [4, 9],
        [6, 8],
        [3, 7]
      ], data, "2", 2),
      series([
        [9, 10],
        [8, 11],
        [7, 9]
      ], data, "3", 3)
    ]);
    expect(a0, "foo");
    expect(b0, "bar");
  });

  test("stack.value(number) sets the constant value", () {
    final s = Stack.withDefaults()..constValue(42.0);
    expect(s.value({}, null, 0, []), 42);
  });

  test("stack.value(function) sets the value accessor function", () {
    v(_, __, ___, ____) {
      return 42;
    }

    final s = Stack.withDefaults()..value = v;
    expect(s.value, v);
  });

  test("stack(data) passes the value accessor datum, key, index and data", () {
    late Map<String, Object?> actual;
    v(d, k, i, data) {
      actual = {"datum": d, "key": k, "index": i, "data": data};
      return 2;
    }

    var s = Stack.withDefaults()
      ..constKeys(["foo"])
      ..value = v;
    var data = [
      {"foo": 1}
    ];
    expect(s(data), [
      series([
        [0, 2]
      ], data, "foo", 0)
    ]);
    expect(actual, {"datum": data[0], "key": "foo", "index": 0, "data": data});
  });

  test("stack.order(null) is equivalent to stack.order(stackOrderNone)", () {
    final s = Stack.withDefaults()..order = null;
    expect(s.order, stackOrderNone);
    expect(s.order, isA<Function>());
  });

  test("stack.order(function) sets the order function", () {
    final s = Stack<int, List<num>>((d, k, _, __) => d[k])
      ..constKeys([0, 1, 2, 3])
      ..order = stackOrderReverse;
    const data = [
      [1, 3, 5, 1],
      [2, 4, 2, 3],
      [1, 2, 4, 2]
    ];
    expect(s.order, stackOrderReverse);
    expect(s(data), [
      series([
        [9, 10],
        [9, 11],
        [8, 9]
      ], data, 0, 3),
      series([
        [6, 9],
        [5, 9],
        [6, 8]
      ], data, 1, 2),
      series([
        [1, 6],
        [3, 5],
        [2, 6]
      ], data, 2, 1),
      series([
        [0, 1],
        [0, 3],
        [0, 2]
      ], data, 3, 0)
    ]);
  });

  test("stack.offset(null) is equivalent to stack.offset(stackOffsetNone)", () {
    final s = Stack.withDefaults()..offset = null;
    expect(s.offset, stackOffsetNone);
    expect(s.offset, isA<Function>());
  });

  test("stack.offset(function) sets the offset function", () {
    final s = Stack<int, List<num>>((d, k, _, __) => d[k])
      ..constKeys([0, 1, 2, 3])
      ..offset = stackOffsetExpand;
    const data = [
      [1, 3, 5, 1],
      [2, 4, 2, 3],
      [1, 2, 4, 2]
    ];
    expect(s.offset, stackOffsetExpand);
    expect(
        s(data).map(roundSeries),
        [
          [
            [0 / 10, 1 / 10],
            [0 / 11, 2 / 11],
            [0 / 9, 1 / 9]
          ],
          [
            [1 / 10, 4 / 10],
            [2 / 11, 6 / 11],
            [1 / 9, 3 / 9]
          ],
          [
            [4 / 10, 9 / 10],
            [6 / 11, 8 / 11],
            [3 / 9, 7 / 9]
          ],
          [
            [9 / 10, 10 / 10],
            [8 / 11, 11 / 11],
            [7 / 9, 9 / 9]
          ]
        ].map(roundSeries));
  });
}

StackSeries<K, T> series<K, T>(
    List<List<num>> series, List<T> data, K key, int index) {
  final series0 =
      StackSeries<K, T>(series.map((p) => StackSeriesPoint<T>(p)).toList());
  for (var i = 0; i < series0.length; i++) {
    series0[i].data = data[i];
  }
  series0.key = key;
  series0.index = index;
  return series0;
}

Iterable<Iterable<num>> roundSeries(List<List<num>> series) {
  return series.map((point) {
    return point.map((value) {
      return (value * 1e6).round() / 1e6;
    });
  });
}
