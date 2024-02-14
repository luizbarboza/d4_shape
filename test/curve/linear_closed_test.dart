import 'package:d4_shape/d4_shape.dart';
import 'package:test/test.dart';

import '../equals_path.dart';

void main() {
  test("line.curve(curveLinearClosed)(data) generates the expected path", () {
    final l = Line.withDefaults()..curve = curveLinearClosed;
    expect(l([]), isNull);
    expect(
        l([
          [0, 1]
        ]),
        EqualsPath("M0,1Z"));
    expect(
        l([
          [0, 1],
          [2, 3]
        ]),
        EqualsPath("M0,1L2,3Z"));
    expect(
        l([
          [0, 1],
          [2, 3],
          [4, 5]
        ]),
        EqualsPath("M0,1L2,3L4,5Z"));
  });
}
