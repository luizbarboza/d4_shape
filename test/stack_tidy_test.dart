import 'package:d4_shape/d4_shape.dart';
import 'package:d4_shape/src/stack.dart';
import 'package:test/test.dart';

void main() {
  test("stackTidy(data) computes the stacked series for the given data", () {
    final s = StackTidy<int, int, ((int, int), int)>(
      key: (d) => d.$1,
      value: (d) => d.$2,
    );
    final data = tidy([
      [1, 3, 5, 1],
      [2, 4, 2, 3],
      [1, 2, 4, 2]
    ]);
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

  test("stack.order(function) sets the order function", () {
    final s = StackTidy<int, int, ((int, int), int)>(
      key: (d) => d.$1,
      value: (d) => d.$2,
    )..order = stackOrderReverse;
    final data = tidy([
      [1, 3, 5, 1],
      [2, 4, 2, 3],
      [1, 2, 4, 2]
    ]);
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

  test("stack.offset(function) sets the offset function", () {
    final s = StackTidy<int, int, ((int, int), int)>(
      key: (d) => d.$1,
      value: (d) => d.$2,
    )..offset = stackOffsetExpand;
    final data = tidy([
      [1, 3, 5, 1],
      [2, 4, 2, 3],
      [1, 2, 4, 2]
    ]);
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

List<((int, int), T)> tidy<T>(List<List<T>> data) {
  final tidyData = <((int, int), T)>[];
  for (final g in data.indexed) {
    for (final l in g.$2.indexed) {
      tidyData.add(((l.$1, g.$1), l.$2));
    }
  }
  return tidyData;
}
