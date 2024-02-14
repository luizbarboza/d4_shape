import 'package:d4_shape/d4_shape.dart';
import 'package:test/test.dart';

import '../equals_path.dart';

void main() {
  test("line.curve(curveBumpY)(data) generates the expected path", () {
    final l = Line.withDefaults()..curve = curveBumpY;
    expect(l([]), null);
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
        EqualsPath("M0,1C0,2,1,2,1,3"));
    expect(
        l([
          [0, 1],
          [1, 3],
          [2, 1]
        ]),
        EqualsPath("M0,1C0,2,1,2,1,3C1,2,2,2,2,1"));
  });

  test("area.curve(curveBumpY)(data) generates the expected path", () {
    final a = Area.withDefaults()..curve = curveBumpY;
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
        EqualsPath("M0,1C0,2,1,2,1,3L1,0C1,0,0,0,0,0Z"));
    expect(
        a([
          [0, 1],
          [1, 3],
          [2, 1]
        ]),
        EqualsPath(
            "M0,1C0,2,1,2,1,3C1,2,2,2,2,1L2,0C2,0,1,0,1,0C1,0,0,0,0,0Z"));
  });
}
