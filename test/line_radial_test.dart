import 'package:d4_shape/d4_shape.dart';
import 'package:test/test.dart';

import 'equals_path.dart';

void main() {
  test("lineRadial() returns a default radial line shape", () {
    final l = LineRadial.withDefaults();
    expect(l.angle([42, 34], 0, []), 42);
    expect(l.radius([42, 34], 0, []), 34);
    expect(l.defined([42, 34], 0, []), true);
    expect(l.curve, curveLinear);
    expect(l.context, null);
    expect(
        l([
          [0, 1],
          [2, 3],
          [4, 5]
        ]),
        EqualsPath("M0,-1L2.727892,1.248441L-3.784012,3.268218"));
  });
}
