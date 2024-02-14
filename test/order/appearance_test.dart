import 'package:d4_shape/d4_shape.dart';
import 'package:test/test.dart';

void main() {
  test("stackOrderAppearance(series) returns an order by appearance", () {
    expect(
        stackOrderAppearance([
          [
            [0, 0],
            [0, 0],
            [0, 1]
          ],
          [
            [0, 3],
            [0, 2],
            [0, 0]
          ],
          [
            [0, 0],
            [0, 4],
            [0, 0]
          ]
        ]),
        [1, 2, 0]);
  });

  test("stackOrderAppearance(series) treats double.nan values as zero", () {
    expect(
        stackOrderAppearance([
          [
            [0, double.nan],
            [0, double.nan],
            [0, 1]
          ],
          [
            [0, 3],
            [0, 2],
            [0, double.nan]
          ],
          [
            [0, double.nan],
            [0, 4],
            [0, double.nan]
          ]
        ]),
        [1, 2, 0]);
  });
}
