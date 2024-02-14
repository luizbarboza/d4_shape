import 'package:d4_shape/d4_shape.dart';
import 'package:test/test.dart';

import '../equals_path.dart';

void main() {
  test("line.curve(curveStepAfter)(data) generates the expected path", () {
    final l = Line.withDefaults()..curve = curveStepAfter;
    expect(l([]), isNull);
    expect(
        l([
          [0, 1]
        ]),
        EqualsPath("M0,1Z"));
    expect(
        l([
          [0, 1],
          [2, 3]
        ]),
        EqualsPath("M0,1L2,1L2,3"));
    expect(
        l([
          [0, 1],
          [2, 3],
          [4, 5]
        ]),
        EqualsPath("M0,1L2,1L2,3L4,3L4,5"));
  });

  test("area.curve(curveStepAfter)(data) generates the expected path", () {
    final a = Area.withDefaults()..curve = curveStepAfter;
    expect(a([]), isNull);
    expect(
        a([
          [0, 1]
        ]),
        EqualsPath("M0,1L0,0Z"));
    expect(
        a([
          [0, 1],
          [2, 3]
        ]),
        EqualsPath("M0,1L2,1L2,3L2,0L2,0L0,0Z"));
    expect(
        a([
          [0, 1],
          [2, 3],
          [4, 5]
        ]),
        EqualsPath("M0,1L2,1L2,3L4,3L4,5L4,0L4,0L2,0L2,0L0,0Z"));
  });
}
