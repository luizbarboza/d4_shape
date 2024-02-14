import 'package:d4_shape/d4_shape.dart';
import 'package:test/test.dart';

import '../equals_path.dart';

void main() {
  test("line.curve(curveBasisOpen)(data) generates the expected path", () {
    final l = Line.withDefaults()..curve = curveBasisOpen;
    expect(l([]), isNull);
    expect(
        l([
          [0, 0]
        ]),
        isNull);
    expect(
        l([
          [0, 0],
          [0, 10]
        ]),
        isNull);
    expect(
        l([
          [0, 0],
          [0, 10],
          [10, 10]
        ]),
        EqualsPath("M1.666667,8.333333Z"));
    expect(
        l([
          [0, 0],
          [0, 10],
          [10, 10],
          [10, 0]
        ]),
        EqualsPath(
            "M1.666667,8.333333C3.333333,10,6.666667,10,8.333333,8.333333"));
    expect(
        l([
          [0, 0],
          [0, 10],
          [10, 10],
          [10, 0],
          [0, 0]
        ]),
        EqualsPath(
            "M1.666667,8.333333C3.333333,10,6.666667,10,8.333333,8.333333C10,6.666667,10,3.333333,8.333333,1.666667"));
  });

  test("area.curve(curveBasisOpen)(data) generates the expected path", () {
    final a = Area.withDefaults()..curve = curveBasisOpen;
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
          [0, 0],
          [0, 10],
          [10, 10]
        ]),
        EqualsPath("M1.666667,8.333333L1.666667,0Z"));
    expect(
        a([
          [0, 0],
          [0, 10],
          [10, 10],
          [10, 0]
        ]),
        EqualsPath(
            "M1.666667,8.333333C3.333333,10,6.666667,10,8.333333,8.333333L8.333333,0C6.666667,0,3.333333,0,1.666667,0Z"));
    expect(
        a([
          [0, 0],
          [0, 10],
          [10, 10],
          [10, 0],
          [0, 0]
        ]),
        EqualsPath(
            "M1.666667,8.333333C3.333333,10,6.666667,10,8.333333,8.333333C10,6.666667,10,3.333333,8.333333,1.666667L8.333333,0C10,0,10,0,8.333333,0C6.666667,0,3.333333,0,1.666667,0Z"));
  });
}
