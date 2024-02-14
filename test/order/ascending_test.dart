import 'package:d4_shape/d4_shape.dart';
import 'package:test/test.dart';

void main() {
  test("stackOrderAscending(series) returns an order by sum", () {
    expect(
        stackOrderAscending([
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
        [2, 0, 1]);
  });

  test("stackOrderAscending(series) treats NaN values as zero", () {
    expect(
        stackOrderAscending([
          [
            [0, 1],
            [0, 2],
            [0, double.nan],
            [0, 3]
          ],
          [
            [0, 2],
            [0, 3],
            [0, double.nan],
            [0, 4]
          ],
          [
            [0, 0],
            [0, 1],
            [0, double.nan],
            [0, 2]
          ]
        ]),
        [2, 0, 1]);
  });
}
