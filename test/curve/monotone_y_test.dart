import 'package:d4_shape/d4_shape.dart';
import 'package:test/test.dart';

import '../equals_path.dart';

void main() {
  test("line.curve(curveMonotoneY)(data) generates the expected path", () {
    final l = Line.withDefaults()..curve = curveMonotoneY;
    expect(l([]), isNull);
    expect(
        l([
          [0, 1]
        ].map(reflect).toList()),
        EqualsPath("M1,0Z"));
    expect(
        l([
          [0, 1],
          [1, 3]
        ].map(reflect).toList()),
        EqualsPath("M1,0L3,1"));
    expect(
        l([
          [0, 1],
          [1, 3],
          [2, 1]
        ].map(reflect).toList()),
        EqualsPath("M1,0C2,0.333333,3,0.666667,3,1C3,1.333333,2,1.666667,1,2"));
    expect(
        l([
          [0, 1],
          [1, 3],
          [2, 1],
          [3, 3]
        ].map(reflect).toList()),
        EqualsPath(
            "M1,0C2,0.333333,3,0.666667,3,1C3,1.333333,1,1.666667,1,2C1,2.333333,2,2.666667,3,3"));
  });

  test("line.curve(curveMonotoneY)(data) preserves monotonicity in y", () {
    final l = Line.withDefaults()..curve = curveMonotoneY;
    expect(
        l([
          [0, 200],
          [100, 100],
          [200, 100],
          [300, 300],
          [400, 300]
        ].map(reflect).toList()),
        EqualsPath(
            "M200,0C150,33.333333,100,66.666667,100,100C100,133.333333,100,166.666667,100,200C100,233.333333,300,266.666667,300,300C300,333.333333,300,366.666667,300,400"));
  });

  test("line.curve(curveMonotoneY)(data) handles duplicate x-values", () {
    final l = Line.withDefaults()..curve = curveMonotoneY;
    expect(
        l([
          [0, 200],
          [0, 100],
          [100, 100],
          [200, 0]
        ].map(reflect).toList()),
        EqualsPath(
            "M200,0C200,0,100,0,100,0C100,33.333333,100,66.666667,100,100C100,133.333333,50,166.666667,0,200"));
    expect(
        l([
          [0, 200],
          [100, 100],
          [100, 0],
          [200, 0]
        ].map(reflect).toList()),
        EqualsPath(
            "M200,0C183.333333,33.333333,166.666667,66.666667,100,100C100,100,0,100,0,100C0,133.333333,0,166.666667,0,200"));
    expect(
        l([
          [0, 200],
          [100, 100],
          [200, 100],
          [200, 0]
        ].map(reflect).toList()),
        EqualsPath(
            "M200,0C150,33.333333,100,66.666667,100,100C100,133.333333,100,166.666667,100,200C100,200,0,200,0,200"));
  });

  test("line.curve(curveMonotoneY)(data) handles segments of infinite slope",
      () {
    final l = Line.withDefaults()..curve = curveMonotoneY;
    expect(
        l([
          [0, 200],
          [100, 150],
          [100, 50],
          [200, 0]
        ].map(reflect).toList()),
        EqualsPath(
            "M200,0C191.666667,33.333333,183.333333,66.666667,150,100C150,100,50,100,50,100C16.666667,133.333333,8.333333,166.666667,0,200"));
    expect(
        l([
          [200, 0],
          [100, 50],
          [100, 150],
          [0, 200]
        ].map(reflect).toList()),
        EqualsPath(
            "M0,200C8.333333,166.666667,16.666667,133.333333,50,100C50,100,150,100,150,100C183.333333,66.666667,191.666667,33.333333,200,0"));
  });

  test("line.curve(curveMonotoneY)(data) ignores coincident points", () {
    final l = Line.withDefaults()..curve = curveMonotoneY,
        p = l([
          [0, 200],
          [50, 200],
          [100, 100],
          [150, 0],
          [200, 0]
        ].map(reflect).toList());
    expect(
        l([
          [0, 200],
          [0, 200],
          [50, 200],
          [100, 100],
          [150, 0],
          [200, 0]
        ].map(reflect).toList()),
        p);
    expect(
        l([
          [0, 200],
          [50, 200],
          [50, 200],
          [100, 100],
          [150, 0],
          [200, 0]
        ].map(reflect).toList()),
        p);
    expect(
        l([
          [0, 200],
          [50, 200],
          [100, 100],
          [100, 100],
          [150, 0],
          [200, 0]
        ].map(reflect).toList()),
        p);
    expect(
        l([
          [0, 200],
          [50, 200],
          [100, 100],
          [150, 0],
          [150, 0],
          [200, 0]
        ].map(reflect).toList()),
        p);
    expect(
        l([
          [0, 200],
          [50, 200],
          [100, 100],
          [150, 0],
          [200, 0],
          [200, 0]
        ].map(reflect).toList()),
        p);
  });

  test("area.curve(curveMonotoneY)(data) generates the expected path", () {
    final a = Area.withDefaults()..curve = curveMonotoneY;
    expect(a(<List<num>>[].map(reflect).toList()), isNull);
    expect(
        a([
          [0, 1]
        ].map(reflect).toList()),
        EqualsPath("M1,0L1,0Z"));
    expect(
        a([
          [0, 1],
          [1, 3]
        ].map(reflect).toList()),
        EqualsPath("M1,0L3,1L3,0L1,0Z"));
    expect(
        a([
          [0, 1],
          [1, 3],
          [2, 1]
        ].map(reflect).toList()),
        EqualsPath(
            "M1,0C2,0.333333,3,0.666667,3,1C3,1.333333,2,1.666667,1,2L1,0C1,0,3,0,3,0C3,0,1,0,1,0Z"));
    expect(
        a([
          [0, 1],
          [1, 3],
          [2, 1],
          [3, 3]
        ].map(reflect).toList()),
        EqualsPath(
            "M1,0C2,0.333333,3,0.666667,3,1C3,1.333333,1,1.666667,1,2C1,2.333333,2,2.666667,3,3L3,0C3,0,1,0,1,0C1,0,3,0,3,0C3,0,1,0,1,0Z"));
  });
}

List<num> reflect(List<num> p) {
  return [p[1], p[0]];
}
