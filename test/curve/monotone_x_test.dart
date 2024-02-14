import 'package:d4_shape/d4_shape.dart';
import 'package:test/test.dart';

import '../equals_path.dart';

void main() {
  test("line.curve(curveMonotoneX)(data) generates the expected path", () {
    final l = Line.withDefaults()..curve = curveMonotoneX;
    expect(l([]), isNull);
    expect(
        l([
          [0, 1]
        ]),
        EqualsPath("M0,1Z"));
    expect(
        l([
          [0, 1],
          [1, 3]
        ]),
        EqualsPath("M0,1L1,3"));
    expect(
        l([
          [0, 1],
          [1, 3],
          [2, 1]
        ]),
        EqualsPath("M0,1C0.333333,2,0.666667,3,1,3C1.333333,3,1.666667,2,2,1"));
    expect(
        l([
          [0, 1],
          [1, 3],
          [2, 1],
          [3, 3]
        ]),
        EqualsPath(
            "M0,1C0.333333,2,0.666667,3,1,3C1.333333,3,1.666667,1,2,1C2.333333,1,2.666667,2,3,3"));
  });

  test("line.curve(curveMonotoneX)(data) preserves monotonicity in y", () {
    final l = Line.withDefaults()..curve = curveMonotoneX;
    expect(
        l([
          [0, 200],
          [100, 100],
          [200, 100],
          [300, 300],
          [400, 300]
        ]),
        EqualsPath(
            "M0,200C33.333333,150,66.666667,100,100,100C133.333333,100,166.666667,100,200,100C233.333333,100,266.666667,300,300,300C333.333333,300,366.666667,300,400,300"));
  });

  test("line.curve(curveMonotoneX)(data) handles duplicate x-values", () {
    final l = Line.withDefaults()..curve = curveMonotoneX;
    expect(
        l([
          [0, 200],
          [0, 100],
          [100, 100],
          [200, 0]
        ]),
        EqualsPath(
            "M0,200C0,200,0,100,0,100C33.333333,100,66.666667,100,100,100C133.333333,100,166.666667,50,200,0"));
    expect(
        l([
          [0, 200],
          [100, 100],
          [100, 0],
          [200, 0]
        ]),
        EqualsPath(
            "M0,200C33.333333,183.333333,66.666667,166.666667,100,100C100,100,100,0,100,0C133.333333,0,166.666667,0,200,0"));
    expect(
        l([
          [0, 200],
          [100, 100],
          [200, 100],
          [200, 0]
        ]),
        EqualsPath(
            "M0,200C33.333333,150,66.666667,100,100,100C133.333333,100,166.666667,100,200,100C200,100,200,0,200,0"));
  });

  test("line.curve(curveMonotoneX)(data) handles segments of infinite slope",
      () {
    final l = Line.withDefaults()..curve = curveMonotoneX;
    expect(
        l([
          [0, 200],
          [100, 150],
          [100, 50],
          [200, 0]
        ]),
        EqualsPath(
            "M0,200C33.333333,191.666667,66.666667,183.333333,100,150C100,150,100,50,100,50C133.333333,16.666667,166.666667,8.333333,200,0"));
    expect(
        l([
          [200, 0],
          [100, 50],
          [100, 150],
          [0, 200]
        ]),
        EqualsPath(
            "M200,0C166.666667,8.333333,133.333333,16.666667,100,50C100,50,100,150,100,150C66.666667,183.333333,33.333333,191.666667,0,200"));
  });

  test("line.curve(curveMonotoneX)(data) ignores coincident points", () {
    final l = Line.withDefaults()..curve = curveMonotoneX;
    final p = l([
      [0, 200],
      [50, 200],
      [100, 100],
      [150, 0],
      [200, 0]
    ]);
    expect(
        l([
          [0, 200],
          [0, 200],
          [50, 200],
          [100, 100],
          [150, 0],
          [200, 0]
        ]),
        p);
    expect(
        l([
          [0, 200],
          [50, 200],
          [50, 200],
          [100, 100],
          [150, 0],
          [200, 0]
        ]),
        p);
    expect(
        l([
          [0, 200],
          [50, 200],
          [100, 100],
          [100, 100],
          [150, 0],
          [200, 0]
        ]),
        p);
    expect(
        l([
          [0, 200],
          [50, 200],
          [100, 100],
          [150, 0],
          [150, 0],
          [200, 0]
        ]),
        p);
    expect(
        l([
          [0, 200],
          [50, 200],
          [100, 100],
          [150, 0],
          [200, 0],
          [200, 0]
        ]),
        p);
  });

  test("area.curve(curveMonotoneX)(data) generates the expected path", () {
    final a = Area.withDefaults()..curve = curveMonotoneX;
    expect(a([]), isNull);
    expect(
        a([
          [0, 1]
        ]),
        EqualsPath("M0,1L0,0Z"));
    expect(
        a([
          [0, 1],
          [1, 3]
        ]),
        EqualsPath("M0,1L1,3L1,0L0,0Z"));
    expect(
        a([
          [0, 1],
          [1, 3],
          [2, 1]
        ]),
        EqualsPath(
            "M0,1C0.333333,2,0.666667,3,1,3C1.333333,3,1.666667,2,2,1L2,0C1.666667,0,1.333333,0,1,0C0.666667,0,0.333333,0,0,0Z"));
    expect(
        a([
          [0, 1],
          [1, 3],
          [2, 1],
          [3, 3]
        ]),
        EqualsPath(
            "M0,1C0.333333,2,0.666667,3,1,3C1.333333,3,1.666667,1,2,1C2.333333,1,2.666667,2,3,3L3,0C2.666667,0,2.333333,0,2,0C1.666667,0,1.333333,0,1,0C0.666667,0,0.333333,0,0,0Z"));
  });
}
