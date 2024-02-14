import 'package:d4_shape/d4_shape.dart';
import 'package:test/test.dart';

import '../equals_path.dart';

void main() {
  test("line.curve(curveStep)(data) generates the expected path", () {
    final l = Line.withDefaults()..curve = curveStep;
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
        EqualsPath("M0,1L1,1L1,3L2,3"));
    expect(
        l([
          [0, 1],
          [2, 3],
          [4, 5]
        ]),
        EqualsPath("M0,1L1,1L1,3L3,3L3,5L4,5"));
  });

  test("area.curve(curveStep)(data) generates the expected path", () {
    final a = Area.withDefaults()..curve = curveStep;
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
        EqualsPath("M0,1L1,1L1,3L2,3L2,0L1,0L1,0L0,0Z"));
    expect(
        a([
          [0, 1],
          [2, 3],
          [4, 5]
        ]),
        EqualsPath("M0,1L1,1L1,3L3,3L3,5L4,5L4,0L3,0L3,0L1,0L1,0L0,0Z"));
  });
}
