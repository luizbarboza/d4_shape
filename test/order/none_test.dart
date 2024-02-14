import 'package:d4_shape/d4_shape.dart';
import 'package:test/test.dart';

void main() {
  test("stackOrderNone(series) returns [0, 1, … series.length - 1]", () {
    expect(stackOrderNone(List<List<Never>>.filled(4, [])), [0, 1, 2, 3]);
  });
}
