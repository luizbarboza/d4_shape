import 'package:d4_shape/d4_shape.dart';
import 'package:test/test.dart';

void main() {
  test(
      "stackOffsetDiverging(series, order) applies a zero baseline, ignoring existing offsets",
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
    stackOffsetDiverging(series, stackOrderNone(series));
    expect(series, [
      [
        [0, 1],
        [0, 2],
        [0, 1]
      ],
      [
        [1, 4],
        [2, 6],
        [1, 3]
      ],
      [
        [4, 9],
        [6, 8],
        [3, 7]
      ]
    ]);
  });

  test("stackOffsetDiverging(series, order) handles a single series", () {
    final series = [
      [
        [1, 2],
        [2, 4],
        [3, 4]
      ]
    ];
    stackOffsetDiverging(series, stackOrderNone(series));
    expect(series, [
      [
        [0, 1],
        [0, 2],
        [0, 1]
      ]
    ]);
  });

  test("stackOffsetDiverging(series, order) treats NaN as zero", () {
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
    stackOffsetDiverging(series, stackOrderNone(series));
    expect(series, [
      [
        [0, 1],
        [0, 2],
        [0, 1]
      ],
      [
        [1, 4],
        [0, isNaN],
        [1, 3]
      ],
      [
        [4, 9],
        [2, 4],
        [3, 7]
      ]
    ]);
  });

  test("stackOffsetDiverging(series, order) observes the specified order", () {
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
    stackOffsetDiverging(series, stackOrderReverse(series));
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

  test(
      "stackOffsetDiverging(series, order) puts negative values below zero, in order",
      () {
    final series = [
      [
        [0, 1],
        [0, -2],
        [0, -1]
      ],
      [
        [0, -3],
        [0, -4],
        [0, -2]
      ],
      [
        [0, -5],
        [0, -2],
        [0, 4]
      ]
    ];
    stackOffsetDiverging(series, stackOrderNone(series));
    expect(series, [
      [
        [0, 1],
        [-2, 0],
        [-1, 0]
      ],
      [
        [-3, 0],
        [-6, -2],
        [-3, -1]
      ],
      [
        [-8, -3],
        [-8, -6],
        [0, 4]
      ]
    ]);
  });

  test("stackOffsetDiverging(series, order) puts zero values at zero, in order",
      () {
    final series = [
      [
        [0, 1],
        [0, 2],
        [0, -1]
      ],
      [
        [0, 3],
        [0, 0],
        [0, 0]
      ],
      [
        [0, 5],
        [0, 2],
        [0, 4]
      ]
    ];
    stackOffsetDiverging(series, stackOrderNone(series));
    expect(series, [
      [
        [0, 1],
        [0, 2],
        [-1, 0]
      ],
      [
        [1, 4],
        [0, 0],
        [0, 0]
      ],
      [
        [4, 9],
        [2, 4],
        [0, 4]
      ]
    ]);
  });
}
