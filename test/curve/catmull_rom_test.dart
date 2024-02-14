import 'package:d4_shape/d4_shape.dart';
import 'package:test/test.dart';

import '../equals_path.dart';

void main() {
  test("line.curve(curveCatmullRom)(data) generates the expected path", () {
    final l = Line.withDefaults()..curve = curveCatmullRom;
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

  test("line.curve(curveCatmullRomAlpha(1))(data) generates the expected path",
      () {
    final l = Line.withDefaults()..curve = curveCatmullRomAlpha(1);
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

  test("line.curve(curveCatmullRom) uses a default alpha of 0.5 (centripetal)",
      () {
    final l = Line.withDefaults()..curve = curveCatmullRomAlpha(0.5);
    expect(
        (Line.withDefaults()..curve = curveCatmullRom)([
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

  test("area.curve(curveCatmullRomAlpha(0))(data) generates the expected path",
      () {
    final a = Area.withDefaults()..curve = curveCatmullRomAlpha(0);
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

  test("area.curve(curveCatmullRom) uses a default alpha of 0.5 (centripetal)",
      () {
    final a = Area.withDefaults()..curve = curveCatmullRomAlpha(0.5);
    expect(
        (Area.withDefaults()..curve = curveCatmullRom)([
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
}
