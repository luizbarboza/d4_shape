import 'package:d4_shape/d4_shape.dart';
import 'package:test/test.dart';

import '../equals_path.dart';

void main() {
  test("line.curve(curveCardinalClosed)(data) generates the expected path", () {
    final l = Line.withDefaults()..curve = curveCardinalClosed;
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
        EqualsPath("M1,3L0,1Z"));
    expect(
        l([
          [0, 1],
          [1, 3],
          [2, 1]
        ]),
        EqualsPath(
            "M1,3C1.333333,3,2.166667,1.333333,2,1C1.833333,0.666667,0.166667,0.666667,0,1C-0.166667,1.333333,0.666667,3,1,3"));
    expect(
        l([
          [0, 1],
          [1, 3],
          [2, 1],
          [3, 3]
        ]),
        EqualsPath(
            "M1,3C1.333333,3,1.666667,1,2,1C2.333333,1,3.333333,3,3,3C2.666667,3,0.333333,1,0,1C-0.333333,1,0.666667,3,1,3"));
  });

  test("line.curve(curveCardinalClosed) uses a default tension of zero", () {
    final l = Line.withDefaults()..curve = curveCardinalClosedTension(0);
    expect(
        (Line.withDefaults()..curve = curveCardinalClosed)([
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

  test(
      "line.curve(curveCardinalClosed.tension(tension)) uses the specified tension",
      () {
    expect(
        (Line.withDefaults()..curve = curveCardinalClosedTension(0.5))([
          [0, 1],
          [1, 3],
          [2, 1],
          [3, 3]
        ]),
        EqualsPath(
            "M1,3C1.166667,3,1.833333,1,2,1C2.166667,1,3.166667,3,3,3C2.833333,3,0.166667,1,0,1C-0.166667,1,0.833333,3,1,3"));
  });

  test("area.curve(curveCardinalClosed)(data) generates the expected path", () {
    final a = Area.withDefaults()..curve = curveCardinalClosed;
    expect(a([]), isNull);
    expect(
        a([
          [0, 1]
        ]),
        "M0,1ZM0,0Z");
    expect(
        a([
          [0, 1],
          [1, 3]
        ]),
        "M1,3L0,1ZM0,0L1,0Z");
    expect(
        a([
          [0, 1],
          [1, 3],
          [2, 1]
        ]),
        EqualsPath(
            "M1,3C1.333333,3,2.166667,1.333333,2,1C1.833333,0.666667,0.166667,0.666667,0,1C-0.166667,1.333333,0.666667,3,1,3M1,0C0.666667,0,-0.166667,0,0,0C0.166667,0,1.833333,0,2,0C2.166667,0,1.333333,0,1,0"));
    expect(
        a([
          [0, 1],
          [1, 3],
          [2, 1],
          [3, 3]
        ]),
        EqualsPath(
            "M1,3C1.333333,3,1.666667,1,2,1C2.333333,1,3.333333,3,3,3C2.666667,3,0.333333,1,0,1C-0.333333,1,0.666667,3,1,3M2,0C1.666667,0,1.333333,0,1,0C0.666667,0,-0.333333,0,0,0C0.333333,0,2.666667,0,3,0C3.333333,0,2.333333,0,2,0"));
  });

  test("area.curve(curveCardinalClosed) uses a default tension of zero", () {
    final a = Area.withDefaults()..curve = curveCardinalClosedTension(0);
    expect(
        (Area.withDefaults()..curve = curveCardinalClosed)([
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

  test(
      "area.curve(curveCardinalClosed.tension(tension)) uses the specified tension",
      () {
    expect(
        (Area.withDefaults()..curve = curveCardinalClosedTension(0.5))([
          [0, 1],
          [1, 3],
          [2, 1],
          [3, 3]
        ]),
        EqualsPath(
            "M1,3C1.166667,3,1.833333,1,2,1C2.166667,1,3.166667,3,3,3C2.833333,3,0.166667,1,0,1C-0.166667,1,0.833333,3,1,3M2,0C1.833333,0,1.166667,0,1,0C0.833333,0,-0.166667,0,0,0C0.166667,0,2.833333,0,3,0C3.166667,0,2.166667,0,2,0"));
  });
}
