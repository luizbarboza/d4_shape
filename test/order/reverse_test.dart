import 'package:d4_shape/d4_shape.dart';
import 'package:test/test.dart';

void main() {
  test(
      "stackOrderReverse(series) returns [series.length - 1, series.length - 2, … 0]",
      () {
    expect(stackOrderReverse(List<List<Never>>.filled(4, [])), [3, 2, 1, 0]);
  });
}
