import 'package:d4_shape/d4_shape.dart';
import 'package:test/test.dart';

import '../equals_path.dart';

void main() {
  test("line.curve(curveCatmullRomOpen)(data) generates the expected path", () {
    final l = Line.withDefaults()..curve = curveCatmullRomOpen;
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

  test(
      "line.curve(curveCatmullRomOpenAlpha(1))(data) generates the expected path",
      () {
    final l = Line.withDefaults()..curve = curveCatmullRomOpenAlpha(1);
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

  test(
      "line.curve(curveCatmullRomOpen) uses a default alpha of 0.5 (centripetal)",
      () {
    final l = Line.withDefaults()..curve = curveCatmullRomOpenAlpha(0.5);
    expect(
        (Line.withDefaults()..curve = curveCatmullRomOpen)([
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
      "area.curve(curveCatmullRomOpenAlpha(0.5))(data) generates the expected path",
      () {
    final a = Area.withDefaults()..curve = curveCatmullRomOpenAlpha(0.5);
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

  test(
      "area.curve(curveCatmullRomOpen) uses a default alpha of 0.5 (centripetal)",
      () {
    final a = Area.withDefaults()..curve = curveCatmullRomOpenAlpha(0.5);
    expect(
        (Area.withDefaults()..curve = curveCatmullRomOpen)([
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
