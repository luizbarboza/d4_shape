import 'package:d4_shape/d4_shape.dart';
import 'package:test/test.dart';

void main() {
  test("stackOffsetExpand(series, order) expands to fill [0, 1]", () {
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
    stackOffsetExpand(series, stackOrderNone(series));
    expect(series, [
      [
        [0 / 9, 1 / 9],
        [0 / 8, 2 / 8],
        [0 / 7, 1 / 7]
      ],
      [
        [1 / 9, 4 / 9],
        [2 / 8, 6 / 8],
        [1 / 7, 3 / 7]
      ],
      [
        [4 / 9, 9 / 9],
        [6 / 8, 8 / 8],
        [3 / 7, 7 / 7]
      ]
    ]);
  });

  test("stackOffsetExpand(series, order) treats NaN as zero", () {
    final series = <List<List<num>>>[
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
    stackOffsetExpand(series, stackOrderNone(series));
    expect(series, [
      [
        [0 / 9, 1 / 9],
        [0 / 4, 2 / 4],
        [0 / 7, 1 / 7]
      ],
      [
        [1 / 9, 4 / 9],
        [2 / 4, isNaN],
        [1 / 7, 3 / 7]
      ],
      [
        [4 / 9, 9 / 9],
        [2 / 4, 4 / 4],
        [3 / 7, 7 / 7]
      ]
    ]);
  });

  test("stackOffsetExpand(series, order) observes the specified order", () {
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
    stackOffsetExpand(series, stackOrderReverse(series));
    expect(series, [
      [
        [8 / 9, 9 / 9],
        [6 / 8, 8 / 8],
        [6 / 7, 7 / 7]
      ],
      [
        [5 / 9, 8 / 9],
        [2 / 8, 6 / 8],
        [4 / 7, 6 / 7]
      ],
      [
        [0 / 9, 5 / 9],
        [0 / 8, 2 / 8],
        [0 / 7, 4 / 7]
      ]
    ]);
  });
}
