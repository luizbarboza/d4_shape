import 'package:d4_path/d4_path.dart';
import 'package:d4_shape/d4_shape.dart';
import 'package:test/test.dart';

import 'equals_path.dart';

void main() {
  test("Area.withDefaults() returns a default area shape", () {
    final a = Area.withDefaults();
    expect(a.x0([42, 34], 0, []), 42);
    expect(a.x1, null);
    expect(a.y0([42, 34], 0, []), 0);
    expect(a.y1!([42, 34], 0, []), 34);
    expect(a.defined([42, 34], 0, []), true);
    expect(a.curve, curveLinear);
    expect(a.context, null);
    expect(
        a([
          [0, 1],
          [2, 3],
          [4, 5]
        ]),
        EqualsPath("M0,1L2,3L4,5L4,0L2,0L0,0Z"));
  });

  test("Area.[withDefaults,withConstants](x, y0, y1) sets x0, y0 and y1", () {
    x(_, __, ___) => 0;
    y(_, __, ___) => 0;
    expect(Area.withDefaults(x: x).x0, x);
    expect(Area.withDefaults(x: x, y0: y).y0, y);
    expect(Area.withConstants(x: 3, y0: 2, y1: 1).x0([], 0, []), 3);
    expect(Area.withConstants(x: 3, y0: 2, y1: 1).y0([], 0, []), 2);
    expect(Area.withConstants(x: 3, y0: 2, y1: 1).y1!([], 0, []), 1);
  });

  test("area.x(f)(data) passes d, i and data to the specified function f", () {
    final data = [
          [2, 3],
          [4, 5]
        ],
        actual = [];
    (Area.withDefaults()
      ..x = (d, i, data) {
        actual.add([d, i, data]);
        return 0;
      })(data);
    expect(actual, [
      [
        [2, 3],
        0,
        data
      ],
      [
        [4, 5],
        1,
        data
      ]
    ]);
  });

  test("area.x0(f)(data) passes d, i and data to the specified function f", () {
    final data = [
          [2, 3],
          [4, 5]
        ],
        actual = [];
    (Area.withDefaults()
      ..x0 = (d, i, data) {
        actual.add([d, i, data]);
        return 0;
      })(data);
    expect(actual, [
      [
        [2, 3],
        0,
        data
      ],
      [
        [4, 5],
        1,
        data
      ]
    ]);
  });

  test("area.x1(f)(data) passes d, i and data to the specified function f", () {
    final data = [
          [2, 3],
          [4, 5]
        ],
        actual = [];
    (Area.withDefaults()
      ..x1 = (d, i, data) {
        actual.add([d, i, data]);
        return 0;
      })(data);
    expect(actual, [
      [
        [2, 3],
        0,
        data
      ],
      [
        [4, 5],
        1,
        data
      ]
    ]);
  });

  test("area.y(f)(data) passes d, i and data to the specified function f", () {
    final data = [
          [2, 3],
          [4, 5]
        ],
        actual = [];
    (Area.withDefaults()
      ..y = (d, i, data) {
        actual.add([d, i, data]);
        return 0;
      })(data);
    expect(actual, [
      [
        [2, 3],
        0,
        data
      ],
      [
        [4, 5],
        1,
        data
      ]
    ]);
  });

  test("area.x(f)(data) passes d, i and data to the specified function f", () {
    final data = [
          [2, 3],
          [4, 5]
        ],
        actual = [];
    (Area.withDefaults()
      ..y0 = (d, i, data) {
        actual.add([d, i, data]);
        return 0;
      })(data);
    expect(actual, [
      [
        [2, 3],
        0,
        data
      ],
      [
        [4, 5],
        1,
        data
      ]
    ]);
  });

  test("area.y1(f)(data) passes d, i and data to the specified function f", () {
    final data = [
          [2, 3],
          [4, 5]
        ],
        actual = [];
    (Area.withDefaults()
      ..x = (d, i, data) {
        actual.add([d, i, data]);
        return 0;
      })(data);
    expect(actual, [
      [
        [2, 3],
        0,
        data
      ],
      [
        [4, 5],
        1,
        data
      ]
    ]);
  });

  test("area.defined(f)(data) passes d, i and data to the specified function f",
      () {
    final data = [
          [2, 3],
          [4, 5]
        ],
        actual = [];
    (Area.withDefaults()
      ..defined = (d, i, data) {
        actual.add([d, i, data]);
        return false;
      })(data);
    expect(actual, [
      [
        [2, 3],
        0,
        data
      ],
      [
        [4, 5],
        1,
        data
      ]
    ]);
  });

  test("area.x(x)(data) observes the specified function", () {
    num x(d, __, ___) => d["x"];
    num y(d, __, ___) => d["1"];
    final a = Area.withConstants(x: double.nan, y0: 0, y1: double.nan)
      ..x = x
      ..y1 = y;
    expect(a.x, x);
    expect(a.x0, x);
    expect(a.x1, null);
    expect(
        a([
          {"x": 0, "1": 1},
          {"x": 2, "1": 3},
          {"x": 4, "1": 5}
        ]),
        EqualsPath("M0,1L2,3L4,5L4,0L2,0L0,0Z"));
  });

  test("area.x(x)(data) observes the specified constant", () {
    final x = 0;
    num y(d, __, ___) => d["1"];
    final a = Area.withConstants(x: double.nan, y0: 0, y1: double.nan)
      ..constX(x)
      ..y1 = y;
    expect(a.x({}, 0, []), 0);
    expect(a.x0({}, 0, []), 0);
    expect(a.x1, null);
    expect(
        a([
          {"1": 1},
          {"1": 3},
          {"1": 5}
        ]),
        EqualsPath("M0,1L0,3L0,5L0,0L0,0L0,0Z"));
  });

  test("area.y(y)(data) observes the specified function", () {
    num x(d, __, ___) => d["0"];
    num y(d, __, ___) => d["y"];
    final a = Area.withConstants(x: double.nan, y0: double.nan, y1: double.nan)
      ..x = x
      ..y = y;
    expect(a.y, y);
    expect(a.y0, y);
    expect(a.y1, null);
    expect(
        a([
          {"0": 0, "y": 1},
          {"0": 2, "y": 3},
          {"0": 4, "y": 5}
        ]),
        EqualsPath("M0,1L2,3L4,5L4,5L2,3L0,1Z"));
  });

  test("area.y(y)(data) observes the specified constant", () {
    num x(d, __, ___) => d["0"];
    final y = 0;
    final a = Area.withConstants(x: double.nan, y0: double.nan, y1: double.nan)
      ..x = x
      ..constY(y);
    expect(a.y({}, 0, []), 0);
    expect(a.y0({}, 0, []), 0);
    expect(a.y1, null);
    expect(
        a([
          {"0": 0},
          {"0": 2},
          {"0": 4}
        ]),
        EqualsPath("M0,0L2,0L4,0L4,0L2,0L0,0Z"));
  });

  test("area.curve(curve) sets the curve method", () {
    final a = Area.withDefaults()..curve = curveCardinal;
    expect(
        a([
          [0, 1],
          [1, 3],
          [2, 1],
          [3, 3]
        ]),
        EqualsPath(
            "M0,1C0,1,0.666667,3,1,3C1.333333,3,1.666667,1,2,1C2.333333,1,3,3,3,3L3,0C3,0,2.333333,0,2,0C1.666667,0,1.333333,0,1,0C0.666667,0,0,0,0,0Z"));
  });

  test(
      "area.curve(curveCardinal.tension(tension)) sets the cardinal spline tension",
      () {
    final a = Area.withDefaults()..curve = curveCardinalTension(0.1);
    expect(a([]), null);
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
            "M0,1C0,1,0.700000,3,1,3C1.300000,3,2,1,2,1L2,0C2,0,1.300000,0,1,0C0.700000,0,0,0,0,0Z"));
    expect(
        a([
          [0, 1],
          [1, 3],
          [2, 1],
          [3, 3]
        ]),
        EqualsPath(
            "M0,1C0,1,0.700000,3,1,3C1.300000,3,1.700000,1,2,1C2.300000,1,3,3,3,3L3,0C3,0,2.300000,0,2,0C1.700000,0,1.300000,0,1,0C0.700000,0,0,0,0,0Z"));
  });

  test("area.lineX0() returns a line derived from the area", () {
    defined(_, __, ___) => true;
    final curve = curveCardinal;
    final context = Path();
    x0(_, __, ___) => 0;
    x1(_, __, ___) => 0;
    y(_, __, ___) => 0;
    final a = Area.withDefaults()
      ..defined = defined
      ..curve = curve
      ..context = context
      ..y = y
      ..x0 = x0
      ..x1 = x1;
    final l = a.lineX0();
    expect(l.defined, defined);
    expect(l.curve, curve);
    expect(l.context, context);
    expect(l.x, x0);
    expect(l.y, y);
  });

  test("area.lineX1() returns a line derived from the area", () {
    defined(_, __, ___) => true;
    final curve = curveCardinal;
    final context = Path();
    x0(_, __, ___) => 0;
    x1(_, __, ___) => 0;
    y(_, __, ___) => 0;
    final a = Area.withDefaults()
      ..defined = defined
      ..curve = curve
      ..context = context
      ..y = y
      ..x0 = x0
      ..x1 = x1;
    final l = a.lineX1();
    expect(l.defined, defined);
    expect(l.curve, curve);
    expect(l.context, context);
    expect(l.x, x1);
    expect(l.y, y);
  });

  test("area.lineY0() returns a line derived from the area", () {
    defined(_, __, ___) => true;
    final curve = curveCardinal;
    final context = Path();
    x(_, __, ___) => 0;
    y0(_, __, ___) => 0;
    y1(_, __, ___) => 0;
    final a = Area.withDefaults()
      ..defined = defined
      ..curve = curve
      ..context = context
      ..x = x
      ..y0 = y0
      ..y1 = y1;
    final l = a.lineY0();
    expect(l.defined, defined);
    expect(l.curve, curve);
    expect(l.context, context);
    expect(l.x, x);
    expect(l.y, y0);
  });

  test("area.lineY1() returns a line derived from the area", () {
    defined(_, __, ___) => true;
    final curve = curveCardinal;
    final context = Path();
    x(_, __, ___) => 0;
    y0(_, __, ___) => 0;
    y1(_, __, ___) => 0;
    final a = Area.withDefaults()
      ..defined = defined
      ..curve = curve
      ..context = context
      ..x = x
      ..y0 = y0
      ..y1 = y1;
    final l = a.lineY1();
    expect(l.defined, defined);
    expect(l.curve, curve);
    expect(l.context, context);
    expect(l.x, x);
    expect(l.y, y1);
  });
}
