import 'dart:math';

import 'package:d4_shape/d4_shape.dart';
import 'package:test/test.dart';

import 'equals_path.dart';

void main() {
  test("Line.withDefaults() returns a default line shape", () {
    final l = Line.withDefaults();
    expect(l.x([42, 34], 0, []), 42);
    expect(l.y([42, 34], 0, []), 34);
    expect(l.defined([42, 34], 0, []), true);
    expect(l.curve, curveLinear);
    expect(l.context, null);
    expect(
        l([
          [0, 1],
          [2, 3],
          [4, 5]
        ]),
        EqualsPath("M0,1L2,3L4,5"));
  });

  test("Line.withDefaults(x, y) sets x and y", () {
    num x(List<num> _, int __, List<List<num>> ___) {
      return 0;
    }

    num y(List<num> _, int __, List<List<num>> ___) {
      return 0;
    }

    expect(Line.withDefaults(x: x).x, x);
    expect(Line.withDefaults(x: x, y: y).y, y);
    expect(Line.withConstants(3, 2).x([], 0, []), 3);
    expect(Line.withConstants(3, 2).y([], 0, []), 2);
  });

  test("line.x(f)(data) passes d, i and data to the specified function f", () {
    final data = [
          [2, 3],
          [4, 5]
        ],
        actual = [];
    (Line.withDefaults()
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

  test("line.y(f)(data) passes d, i and data to the specified function f", () {
    final data = [
          [2, 3],
          [4, 5]
        ],
        actual = [];
    (Line.withDefaults()
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

  test("line.defined(f)(data) passes d, i and data to the specified function f",
      () {
    final data = [
          [2, 3],
          [4, 5]
        ],
        actual = [];
    (Line.withDefaults()
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

  test("line.x(x)(data) observes the specified function", () {
    final l = Line.withConstants(double.nan, double.nan)
      ..x = (d, _, __) {
        return d["x"]!;
      }
      ..y = (d, _, __) {
        return d["1"]!;
      };
    expect(
        l([
          {"x": 0, "1": 1},
          {"x": 2, "1": 3},
          {"x": 4, "1": 5}
        ]),
        EqualsPath("M0,1L2,3L4,5"));
  });

  test("line.x(x)(data) observes the specified constant", () {
    final l = Line.withConstants(double.nan, double.nan)
      ..constX(0)
      ..y = (d, _, __) {
        return d["1"]!;
      };
    expect(
        l([
          {"1": 1},
          {"1": 3},
          {"1": 5}
        ]),
        EqualsPath("M0,1L0,3L0,5"));
  });

  test("line.y(y)(data) observes the specified function", () {
    final l = Line.withConstants(double.nan, double.nan)
      ..x = (d, _, __) {
        return d["0"]!;
      }
      ..y = (d, _, __) {
        return d["y"]!;
      };
    expect(
        l([
          {"0": 0, "y": 1},
          {"0": 2, "y": 3},
          {"0": 4, "y": 5}
        ]),
        EqualsPath("M0,1L2,3L4,5"));
  });

  test("line.y(y)(data) observes the specified constant", () {
    final l = Line.withConstants(double.nan, double.nan)
      ..x = (d, _, __) {
        return d["0"]!;
      }
      ..constY(0);
    expect(
        l([
          {"0": 0},
          {"0": 2},
          {"0": 4}
        ]),
        EqualsPath("M0,0L2,0L4,0"));
  });

  test("line.curve(curve) sets the curve method", () {
    final l = Line.withDefaults()..curve = curveLinearClosed;
    expect(l([]), null);
    expect(
        l([
          [0, 1],
          [2, 3]
        ]),
        EqualsPath("M0,1L2,3Z"));
  });

  test("line.digits(digits) sets the maximum fractional digits", () {
    final points = [
      [0, pi],
      [e, 4]
    ];
    final l = Line.withDefaults();
    expect(l.digits, 3);
    expect(l(points), "M0.0,3.142L2.718,4.0");
    expect(l..digits = 6, l);
    expect(l.digits, 6);
    expect(l(points), "M0.0,3.141593L2.718282,4.0");
    expect(Line.withDefaults()(points), "M0.0,3.142L2.718,4.0");
    expect(l..digits = null, l);
    expect(l.digits, null);
    expect(l(points), "M0,3.141592653589793L2.718281828459045,4");
    expect(Line.withDefaults()(points), "M0.0,3.142L2.718,4.0");
    expect(l..digits = 3, l);
    expect(l.digits, 3);
    expect(l(points), "M0.0,3.142L2.718,4.0");
  });
}
