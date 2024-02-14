import 'package:d4_shape/d4_shape.dart';
import 'package:test/test.dart';

void main() {
  test("stackOrderDescending(series) returns an order by sum", () {
    expect(
        stackOrderDescending([
          [
            [0, 1],
            [0, 2],
            [0, 3]
          ],
          [
            [0, 2],
            [0, 3],
            [0, 4]
          ],
          [
            [0, 0],
            [0, 1],
            [0, 2]
          ]
        ]),
        [1, 0, 2]);
  });

  test("stackOrderDescending(series) treats NaN values as zero", () {
    expect(
        stackOrderDescending([
          [
            [0, 1],
            [0, 2],
            [0, 3],
            [0, double.nan]
          ],
          [
            [0, 2],
            [0, 3],
            [0, 4],
            [0, double.nan]
          ],
          [
            [0, 0],
            [0, 1],
            [0, 2],
            [0, double.nan]
          ]
        ]),
        [1, 0, 2]);
  });
}
