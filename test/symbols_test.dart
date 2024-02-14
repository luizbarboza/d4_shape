import 'package:d4_shape/d4_shape.dart';
import 'package:test/test.dart';

void main() {
  test("symbols is a deprecated alias for symbolsFill", () {
    expect(symbols, symbolsFill);
  });

  test("symbolsFill is the array of symbol types", () {
    expect(symbolsFill, [
      isA<SymbolCircle>(),
      isA<SymbolCross>(),
      isA<SymbolDiamond>(),
      isA<SymbolSquare>(),
      isA<SymbolStar>(),
      isA<SymbolTriangle>(),
      isA<SymbolWye>()
    ]);
  });

  test("symbolsStroke is the array of symbol types", () {
    expect(symbolsStroke, [
      isA<SymbolCircle>(),
      isA<SymbolPlus>(),
      isA<SymbolTimes>(),
      isA<SymbolTriangle2>(),
      isA<SymbolAsterisk>(),
      isA<SymbolSquare2>(),
      isA<SymbolDiamond2>()
    ]);
  });
}
