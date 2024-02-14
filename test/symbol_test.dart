import 'dart:math';

import 'package:d4_shape/d4_shape.dart';
import 'package:test/test.dart';

import 'equals_path.dart';
import 'polygon_context.dart';

void main() {
  test("symbol() returns a default symbol shape", () {
    final s = Symbol();
    expect(s.type(s), isA<SymbolCircle>());
    expect(s.size(s), 64);
    expect(s.context, null);
    expect(
        s(),
        EqualsPath(
            "M4.513517,0A4.513517,4.513517,0,1,1,-4.513517,0A4.513517,4.513517,0,1,1,4.513517,0"));
  });

  test(
      "symbol().size(f)(…) propagates the context and arguments to the specified function",
      () {
    final s = Symbol();
    final expected = {
      "that": s,
      "args": [42]
    };
    late Map actual;
    (s
      ..size = (s, [args]) {
        actual = {"that": s, "args": args};
        return 64;
      })(expected["args"] as List<Object?>);
    expect(actual, expected);
  });

  test(
      "symbol().type(f)(…) propagates the context and arguments to the specified function",
      () {
    final s = Symbol();
    final expected = {
      "that": s,
      "args": [42]
    };
    late Map actual;
    (s
      ..type = (s, [args]) {
        actual = {"that": s, "args": args};
        return SymbolCircle();
      })(expected["args"] as List<Object?>);
    expect(actual, expected);
  });

  test("symbol.size(size) observes the specified size function", () {
    num size(Symbol s, [List<Object?>? args]) {
      return (args![0] as Map)["z"] * 2 + args[1];
    }

    final s = Symbol()..size = size;
    expect(s.size, size);
    expect(
        s([
          {"z": 0},
          0
        ]),
        EqualsPath("M0,0"));
    expect(
        s([
          {"z": pi / 2},
          0
        ]),
        EqualsPath("M1,0A1,1,0,1,1,-1,0A1,1,0,1,1,1,0"));
    expect(
        s([
          {"z": 2 * pi},
          0
        ]),
        EqualsPath("M2,0A2,2,0,1,1,-2,0A2,2,0,1,1,2,0"));
    expect(
        s([
          {"z": pi},
          1
        ]),
        EqualsPath(
            "M1.522600,0A1.522600,1.522600,0,1,1,-1.522600,0A1.522600,1.522600,0,1,1,1.522600,0"));
    expect(
        s([
          {"z": 4 * pi},
          2
        ]),
        EqualsPath(
            "M2.938813,0A2.938813,2.938813,0,1,1,-2.938813,0A2.938813,2.938813,0,1,1,2.938813,0"));
  });

  test("symbol.size(size) observes the specified size constant", () {
    final s = Symbol();
    expect((s..constSize(42)).size(s), 42);
    expect((s..constSize(0))(), EqualsPath("M0,0"));
    expect(
        (s..constSize(pi))(), EqualsPath("M1,0A1,1,0,1,1,-1,0A1,1,0,1,1,1,0"));
    expect((s..constSize(4 * pi))(),
        EqualsPath("M2,0A2,2,0,1,1,-2,0A2,2,0,1,1,2,0"));
  });

  test("symbol.type(symbolAsterisk) generates the expected path", () {
    final s = Symbol()
      ..constType(SymbolAsterisk())
      ..size = (s, [args]) {
        return args![0] as num;
      };
    expect(s([0]), EqualsPath("M0,0L0,0M0,0L0,0M0,0L0,0"));
    expect(
        s([20]),
        EqualsPath(
            "M0,2.705108L0,-2.705108M-2.342692,-1.352554L2.342692,1.352554M-2.342692,1.352554L2.342692,-1.352554"));
  });

  test("symbol.type(symbolCircle) generates the expected path", () {
    final s = Symbol()
      ..constType(SymbolCircle())
      ..size = (s, [args]) {
        return args![0] as num;
      };
    expect(s([0]), EqualsPath("M0,0"));
    expect(
        s([20]),
        EqualsPath(
            "M2.523133,0A2.523133,2.523133,0,1,1,-2.523133,0A2.523133,2.523133,0,1,1,2.523133,0"));
  });

  test("symbol.type(symbolCross) generates a polygon with the specified size",
      () {
    final p = PolygonContext(),
        s = Symbol()
          ..constType(SymbolCross())
          ..context = p;
    (s..constSize(1))();
    expect(p.area(), closeTo(1, 1e-6));
    (s..constSize(240))();
    expect(p.area(), closeTo(240, 1e-6));
  });

  test("symbol.type(symbolCross) generates the expected path", () {
    final s = Symbol()
      ..constType(SymbolCross())
      ..size = (s, [args]) {
        return args![0] as num;
      };
    expect(s([0]),
        EqualsPath("M0,0L0,0L0,0L0,0L0,0L0,0L0,0L0,0L0,0L0,0L0,0L0,0Z"));
    expect(
        s([20]),
        EqualsPath(
            "M-3,-1L-1,-1L-1,-3L1,-3L1,-1L3,-1L3,1L1,1L1,3L-1,3L-1,1L-3,1Z"));
  });

  test("symbol.type(symbolDiamond) generates a polygon with the specified size",
      () {
    final p = PolygonContext(),
        s = Symbol()
          ..constType(SymbolDiamond())
          ..context = p;
    (s..constSize(1))();
    expect(p.area(), closeTo(1, 1e-6));
    (s..constSize(240))();
    expect(p.area(), closeTo(240, 1e-6));
  });

  test("symbol.type(symbolDiamond) generates the expected path", () {
    final s = Symbol()
      ..constType(SymbolDiamond())
      ..size = (s, [args]) {
        return args![0] as num;
      };
    expect(s([0]), EqualsPath("M0,0L0,0L0,0L0,0Z"));
    expect(
        s([10]), EqualsPath("M0,-2.942831L1.699044,0L0,2.942831L-1.699044,0Z"));
  });

  test("symbol.type(symbolDiamond2) generates the expected path", () {
    final s = Symbol()
      ..constType(SymbolDiamond2())
      ..size = (s, [args]) {
        return args![0] as num;
      };
    expect(s([0]), EqualsPath("M0,0L0,0L0,0L0,0Z"));
    expect(
        s([20]), EqualsPath("M0,-2.800675L2.800675,0L0,2.800675L-2.800675,0Z"));
  });

  test("symbol.type(symbolPlus) generates the expected path", () {
    final s = Symbol()
      ..constType(SymbolPlus())
      ..size = (s, [args]) {
        return args![0] as num;
      };
    expect(s([0]), EqualsPath("M0,0L0,0M0,0L0,0"));
    expect(
        s([20]), EqualsPath("M-3.714814,0L3.714814,0M0,3.714814L0,-3.714814"));
  });

  test("symbol.type(symbolStar) generates a polygon with the specified size",
      () {
    final p = PolygonContext(),
        s = Symbol()
          ..constType(SymbolStar())
          ..context = p;
    (s..constSize(1))();
    expect(p.area(), closeTo(1, 1e-6));
    (s..constSize(240))();
    expect(p.area(), closeTo(240, 1e-6));
  });

  test("symbol.type(symbolStar) generates the expected path", () {
    final s = Symbol()
      ..constType(SymbolStar())
      ..size = (s, [args]) {
        return args![0] as num;
      };
    expect(s([0]), EqualsPath("M0,0L0,0L0,0L0,0L0,0L0,0L0,0L0,0L0,0L0,0Z"));
    expect(
        s([10]),
        EqualsPath(
            "M0,-2.984649L0.670095,-0.922307L2.838570,-0.922307L1.084237,0.352290L1.754333,2.414632L0,1.140035L-1.754333,2.414632L-1.084237,0.352290L-2.838570,-0.922307L-0.670095,-0.922307Z"));
  });

  test("symbol.type(symbolSquare) generates a polygon with the specified size",
      () {
    final p = PolygonContext(),
        s = Symbol()
          ..constType(SymbolSquare())
          ..context = p;
    (s..constSize(1))();
    expect(p.area(), closeTo(1, 1e-6));
    (s..constSize(240))();
    expect(p.area(), closeTo(240, 1e-6));
  });

  test("symbol.type(symbolSquare) generates the expected path", () {
    final s = Symbol()
      ..constType(SymbolSquare())
      ..size = (s, [args]) {
        return args![0] as num;
      };
    expect(s([0]), EqualsPath("M0,0h0v0h0Z"));
    expect(s([4]), EqualsPath("M-1,-1h2v2h-2Z"));
    expect(s([16]), EqualsPath("M-2,-2h4v4h-4Z"));
  });

  test("symbol.type(symbolSquare2) generates the expected path", () {
    final s = Symbol()
      ..constType(SymbolSquare2())
      ..size = (s, [args]) {
        return args![0] as num;
      };
    expect(s([0]), EqualsPath("M0,0L0,0L0,0L0,0Z"));
    expect(
        s([20]),
        EqualsPath(
            "M1.981603,1.981603L1.981603,-1.981603L-1.981603,-1.981603L-1.981603,1.981603Z"));
  });

  test(
      "symbol.type(symbolTriangle) generates a polygon with the specified size",
      () {
    final p = PolygonContext(),
        s = Symbol()
          ..constType(SymbolTriangle())
          ..context = p;
    (s..constSize(1))();
    expect(p.area(), closeTo(1, 1e-6));
    (s..constSize(240))();
    expect(p.area(), closeTo(240, 1e-6));
  });

  test("symbol.type(symbolTriangle) generates the expected path", () {
    final s = Symbol()
      ..constType(SymbolTriangle())
      ..size = (s, [args]) {
        return args![0] as num;
      };
    expect(s([0]), EqualsPath("M0,0L0,0L0,0Z"));
    expect(s([10]),
        EqualsPath("M0,-2.774528L2.402811,1.387264L-2.402811,1.387264Z"));
  });

  test("symbol.type(symbolTriangle2) generates the expected path", () {
    final s = Symbol()
      ..constType(SymbolTriangle2())
      ..size = (s, [args]) {
        return args![0] as num;
      };
    expect(s([0]), EqualsPath("M0,0L0,0L0,0Z"));
    expect(s([20]),
        EqualsPath("M0,-3.051786L2.642924,1.525893L-2.642924,1.525893Z"));
  });

  test("symbol.type(symbolWye) generates a polygon with the specified size",
      () {
    final p = PolygonContext(),
        s = Symbol()
          ..constType(SymbolWye())
          ..context = p;
    (s..constSize(1))();
    expect(p.area(), closeTo(1, 1e-6));
    (s..constSize(240))();
    expect(p.area(), closeTo(240, 1e-6));
  });

  test("symbol.type(symbolWye) generates the expected path", () {
    final s = Symbol()
      ..constType(SymbolWye())
      ..size = (s, [args]) {
        return args![0] as num;
      };
    expect(s([0]), EqualsPath("M0,0L0,0L0,0L0,0L0,0L0,0L0,0L0,0L0,0Z"));
    expect(
        s([10]),
        EqualsPath(
            "M0.853360,0.492688L0.853360,2.199408L-0.853360,2.199408L-0.853360,0.492688L-2.331423,-0.360672L-1.478063,-1.838735L0,-0.985375L1.478063,-1.838735L2.331423,-0.360672Z"));
  });

  test("symbol.type(symbolTimes) generates the expected path", () {
    final s = Symbol()
      ..constType(SymbolTimes())
      ..size = (s, [args]) {
        return args![0] as num;
      };
    expect(s([0]), EqualsPath("M0,0L0,0M0,0L0,0"));
    expect(
        s([20]),
        EqualsPath(
            "M-2.647561,-2.647561L2.647561,2.647561M-2.647561,2.647561L2.647561,-2.647561"));
  });

  test("symbol(type, size) is equivalent to symbol().type(type).size(size)",
      () {
    final s0 = Symbol()
      ..constType(SymbolCross())
      ..constSize(16);
    final s1 = Symbol.withConstants(type: SymbolCross(), size: 16);
    expect(s0(), s1());
  });
}
