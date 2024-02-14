import 'package:d4_shape/d4_shape.dart';
import 'package:test/test.dart';

void main() {
  test(
      "stackOffsetNone(series, order) stacks upon the first layer’s existing positions",
      () {
    final series = [
      [
        [1, 2],
        [2, 4],
        [3, 4]
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
    stackOffsetNone(series, stackOrderNone(series));
    expect(series, [
      [
        [1, 2],
        [2, 4],
        [3, 4]
      ],
      [
        [2, 5],
        [4, 8],
        [4, 6]
      ],
      [
        [5, 10],
        [8, 10],
        [6, 10]
      ]
    ]);
  });

  test("stackOffsetNone(series, order) treats NaN as zero", () {
    final series = [
      [
        [0, 1],
        [0, 2],
        [0, 1]
      ],
      [
        [0, 3],
        [0, double.nan],
        [0, 2]
      ],
      [
        [0, 5],
        [0, 2],
        [0, 4]
      ]
    ];
    stackOffsetNone(series, stackOrderNone(series));
    expect(series, [
      [
        [0, 1],
        [0, 2],
        [0, 1]
      ],
      [
        [1, 4],
        [2, isNaN],
        [1, 3]
      ],
      [
        [4, 9],
        [2, 4],
        [3, 7]
      ]
    ]);
  });

  test("stackOffsetNone(series, order) observes the specified order", () {
    final series = [
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
    stackOffsetNone(series, stackOrderReverse(series));
    expect(series, [
      [
        [8, 9],
        [6, 8],
        [6, 7]
      ],
      [
        [5, 8],
        [2, 6],
        [4, 6]
      ],
      [
        [0, 5],
        [0, 2],
        [0, 4]
      ]
    ]);
  });
}
