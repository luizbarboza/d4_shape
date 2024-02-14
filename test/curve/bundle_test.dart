import 'package:d4_shape/d4_shape.dart';
import 'package:test/test.dart';

import '../equals_path.dart';

void main() {
  test("line.curve(curveBundle) uses a default beta of 0.85", () {
    final l = Line.withDefaults()..curve = curveBundleBeta(0.85);
    expect(
        (Line.withDefaults()..curve = curveBundle)([
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

  test("line.curve(curveBundle.beta(beta)) uses the specified beta", () {
    expect(
        (Line.withDefaults()..curve = curveBundleBeta(0.5))([
          [0, 1],
          [1, 3],
          [2, 1],
          [3, 3]
        ]),
        EqualsPath(
            "M0,1L0.166667,1.222222C0.333333,1.444444,0.666667,1.888889,1,2C1.333333,2.111111,1.666667,1.888889,2,2C2.333333,2.111111,2.666667,2.555556,2.833333,2.777778L3,3"));
  });
}
