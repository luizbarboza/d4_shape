import 'package:d4_shape/d4_shape.dart';
import 'package:test/test.dart';

import '../equals_path.dart';

void main() {
  test("line.curve(curveBumpX)(data) generates the expected path", () {
    final l = Line.withDefaults()..curve = curveBumpX;
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
        EqualsPath("M0,1C0.500000,1,0.500000,3,1,3"));
    expect(
        l([
          [0, 1],
          [1, 3],
          [2, 1]
        ]),
        EqualsPath("M0,1C0.500000,1,0.500000,3,1,3C1.500000,3,1.500000,1,2,1"));
  });

  test("area.curve(curveBumpX)(data) generates the expected path", () {
    final a = Area.withDefaults()..curve = curveBumpX;
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
        EqualsPath(
            "M0,1C0.500000,1,0.500000,3,1,3L1,0C0.500000,0,0.500000,0,0,0Z"));
    expect(
        a([
          [0, 1],
          [1, 3],
          [2, 1]
        ]),
        EqualsPath(
            "M0,1C0.500000,1,0.500000,3,1,3C1.500000,3,1.500000,1,2,1L2,0C1.500000,0,1.500000,0,1,0C0.500000,0,0.500000,0,0,0Z"));
  });
}
