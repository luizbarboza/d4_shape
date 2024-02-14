import 'package:d4_shape/d4_shape.dart';
import 'package:test/test.dart';

import '../equals_path.dart';

void main() {
  test("line.curve(curveCardinal)(data) generates the expected path", () {
    final l = Line.withDefaults()..curve = curveCardinal;
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
        EqualsPath("M0,1C0,1,0.666667,3,1,3C1.333333,3,2,1,2,1"));
    expect(
        l([
          [0, 1],
          [1, 3],
          [2, 1],
          [3, 3]
        ]),
        EqualsPath(
            "M0,1C0,1,0.666667,3,1,3C1.333333,3,1.666667,1,2,1C2.333333,1,3,3,3,3"));
  });

  test("line.curve(curveCardinal) uses a default tension of zero", () {
    final l = Line.withDefaults()..curve = curveCardinalTension(0);
    expect(
        (Line.withDefaults()..curve = curveCardinal)([
          [0, 1],
          [1, 3],
          [2, 1],
          [3, 3]
        ]),
        l([
          [0, 1],
          [1, 3],
          [2, 1],
          [3, 3]
        ]));
  });

  test("line.curve(curveCardinal.tension(tension)) uses the specified tension",
      () {
    expect(
        (Line.withDefaults()..curve = curveCardinalTension(0.5))([
          [0, 1],
          [1, 3],
          [2, 1],
          [3, 3]
        ]),
        EqualsPath(
            "M0,1C0,1,0.833333,3,1,3C1.166667,3,1.833333,1,2,1C2.166667,1,3,3,3,3"));
  });

  test("area.curve(curveCardinal)(data) generates the expected path", () {
    final a = Area.withDefaults()..curve = curveCardinal;
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
            "M0,1C0,1,0.666667,3,1,3C1.333333,3,2,1,2,1L2,0C2,0,1.333333,0,1,0C0.666667,0,0,0,0,0Z"));
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

  test("area.curve(curveCardinal) uses a default tension of zero", () {
    final a = Area.withDefaults()..curve = curveCardinalTension(0);
    expect(
        (Area.withDefaults()..curve = curveCardinal)([
          [0, 1],
          [1, 3],
          [2, 1],
          [3, 3]
        ]),
        a([
          [0, 1],
          [1, 3],
          [2, 1],
          [3, 3]
        ]));
  });

  test("area.curve(curveCardinal.tension(tension)) uses the specified tension",
      () {
    expect(
        (Area.withDefaults()..curve = curveCardinalTension(0.5))([
          [0, 1],
          [1, 3],
          [2, 1],
          [3, 3]
        ]),
        EqualsPath(
            "M0,1C0,1,0.833333,3,1,3C1.166667,3,1.833333,1,2,1C2.166667,1,3,3,3,3L3,0C3,0,2.166667,0,2,0C1.833333,0,1.166667,0,1,0C0.833333,0,0,0,0,0Z"));
  });
}
