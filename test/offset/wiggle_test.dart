import 'package:d4_shape/d4_shape.dart';
import 'package:test/test.dart';

void main() {
  test("stackOffsetWiggle(series, order) minimizes weighted wiggle", () {
    final series = <List<List<num>>>[
      [
        [0, 1],
        [0, 2],
        [0, 1]
      ],
      [
        [0, 3],
        [0, 4],
        [0, 2]
      ],
      [
        [0, 5],
        [0, 2],
        [0, 4]
      ]
    ];
    stackOffsetWiggle(series, stackOrderNone(series));
    expect(
        series.map(roundSeries),
        [
          [
            [0, 1],
            [-1, 1],
            [0.7857143, 1.7857143]
          ],
          [
            [1, 4],
            [1, 5],
            [1.7857143, 3.7857143]
          ],
          [
            [4, 9],
            [5, 7],
            [3.7857143, 7.7857143]
          ]
        ].map(roundSeries));
  });

  test("stackOffsetWiggle(series, order) treats NaN as zero", () {
    final series = <List<List<num>>>[
      [
        [0, 1],
        [0, 2],
        [0, 1]
      ],
      [
        [0, double.nan],
        [0, double.nan],
        [0, double.nan]
      ],
      [
        [0, 3],
        [0, 4],
        [0, 2]
      ],
      [
        [0, 5],
        [0, 2],
        [0, 4]
      ]
    ];
    stackOffsetWiggle(series, stackOrderNone(series));
    expect(
        series.map(roundSeries),
        [
          [
            [0, 1],
            [-1, 1],
            [0.7857143, 1.7857143]
          ],
          [
            [1, isNaN],
            [1, isNaN],
            [1.7857143, isNaN]
          ],
          [
            [1, 4],
            [1, 5],
            [1.7857143, 3.7857143]
          ],
          [
            [4, 9],
            [5, 7],
            [3.7857143, 7.7857143]
          ]
        ].map(roundSeries));
  });

  test("stackOffsetWiggle(series, order) observes the specified order", () {
    final series = <List<List<num>>>[
      [
        [0, 1],
        [0, 2],
        [0, 1]
      ],
      [
        [0, 3],
        [0, 4],
        [0, 2]
      ],
      [
        [0, 5],
        [0, 2],
        [0, 4]
      ]
    ];
    stackOffsetWiggle(series, stackOrderReverse(series));
    expect(
        series.map(roundSeries),
        [
          [
            [8, 9],
            [8, 10],
            [7.21428571, 8.21428571]
          ],
          [
            [5, 8],
            [4, 8],
            [5.21428571, 7.21428571]
          ],
          [
            [0, 5],
            [2, 4],
            [1.21428571, 5.21428571]
          ]
        ].map(roundSeries));
  });
}

Iterable<Iterable<Object>> roundSeries(List<List<Object>> series) {
  return series.map((point) {
    return point.map((value) {
      return value is! num || value.isNaN ? value : (value * 1e6).round() / 1e6;
    });
  });
}
