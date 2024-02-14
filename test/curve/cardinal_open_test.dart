import 'package:d4_shape/d4_shape.dart';
import 'package:test/test.dart';

import '../equals_path.dart';

void main() {
  test("line.curve(curveCardinalOpen)(data) generates the expected path", () {
    final l = Line.withDefaults()..curve = curveCardinalOpen;
    expect(l([]), isNull);
    expect(
        l([
          [0, 1]
        ]),
        isNull);
    expect(
        l([
          [0, 1],
          [1, 3]
        ]),
        isNull);
    expect(
        l([
          [0, 1],
          [1, 3],
          [2, 1]
        ]),
        EqualsPath("M1,3Z"));
    expect(
        l([
          [0, 1],
          [1, 3],
          [2, 1],
          [3, 3]
        ]),
        EqualsPath("M1,3C1.333333,3,1.666667,1,2,1"));
  });

  test("line.curve(curveCardinalOpen) uses a default tension of zero", () {
    final l = Line.withDefaults()..curve = curveCardinalOpenTension(0);
    expect(
        (Line.withDefaults()..curve = curveCardinalOpen)([
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
      "line.curve(curveCardinalOpen.tension(tension)) uses the specified tension",
      () {
    expect(
        (Line.withDefaults()..curve = curveCardinalOpenTension(0.5))([
          [0, 1],
          [1, 3],
          [2, 1],
          [3, 3]
        ]),
        EqualsPath("M1,3C1.166667,3,1.833333,1,2,1"));
  });

  test("area.curve(curveCardinalOpen)(data) generates the expected path", () {
    final a = Area.withDefaults()..curve = curveCardinalOpen;
    expect(a([]), isNull);
    expect(
        a([
          [0, 1]
        ]),
        isNull);
    expect(
        a([
          [0, 1],
          [1, 3]
        ]),
        isNull);
    expect(
        a([
          [0, 1],
          [1, 3],
          [2, 1]
        ]),
        EqualsPath("M1,3L1,0Z"));
    expect(
        a([
          [0, 1],
          [1, 3],
          [2, 1],
          [3, 3]
        ]),
        EqualsPath(
            "M1,3C1.333333,3,1.666667,1,2,1L2,0C1.666667,0,1.333333,0,1,0Z"));
  });

  test("area.curve(curveCardinalOpen) uses a default tension of zero", () {
    final a = Area.withDefaults()..curve = curveCardinalOpenTension(0);
    expect(
        (Area.withDefaults()..curve = curveCardinalOpen)([
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
      "area.curve(curveCardinalOpen.tension(tension)) uses the specified tension",
      () {
    expect(
        (Area.withDefaults()..curve = curveCardinalOpenTension(0.5))([
          [0, 1],
          [1, 3],
          [2, 1],
          [3, 3]
        ]),
        EqualsPath(
            "M1,3C1.166667,3,1.833333,1,2,1L2,0C1.833333,0,1.166667,0,1,0Z"));
  });
}
