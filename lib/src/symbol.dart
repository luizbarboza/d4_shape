import 'package:d4_path/d4_path.dart';

import 'constant.dart';
import 'digits.dart';
import 'symbol/asterisk.dart';
import 'symbol/circle.dart';
import 'symbol/cross.dart';
import 'symbol/diamond.dart';
import 'symbol/diamond2.dart';
import 'symbol/plus.dart';
import 'symbol/square.dart';
import 'symbol/square2.dart';
import 'symbol/star.dart';
import 'symbol/times.dart';
import 'symbol/triangle.dart';
import 'symbol/triangle2.dart';
import 'symbol/type.dart';
import 'symbol/wye.dart';

/// Equivalent to [symbolsFill].
///
/// {@category Symbols}
const symbols = symbolsFill;

// These symbols are designed to be filled.

/// An list containing a set of symbol types designed for filling:
/// [SymbolCircle], [SymbolCross], [SymbolDiamond], [SymbolSquare],
/// [SymbolStar], [SymbolTriangle], and [SymbolWye]. Useful for a categorical
/// shape encoding with an
/// [ordinal scale]((https://pub.dev/documentation/d4_scale/latest/topics/Ordinal%20scales-topic.html)).
///
/// ```dart
/// final symbolType = ScaleOrdinal(range: symbolsFill);
/// ```
///
/// {@category Symbols}
const symbolsFill = [
  SymbolCircle(),
  SymbolCross(),
  SymbolDiamond(),
  SymbolSquare(),
  SymbolStar(),
  SymbolTriangle(),
  SymbolWye()
];

// These symbols are designed to be stroked (with a width of 1.5px and round caps).

/// An list containing a set of symbol types designed for stroking:
/// [SymbolCircle], [SymbolPlus], [SymbolTimes], [SymbolTriangle2],
/// [SymbolAsterisk], [SymbolSquare2], and [SymbolDiamond2]. Useful for a
/// categorical shape encoding with an
/// [ordinal scale]((https://pub.dev/documentation/d4_scale/latest/topics/Ordinal%20scales-topic.html)).
///
/// ```dart
/// final symbolType = ScaleOrdinal(range: symbolsStroke);
/// ```
///
/// {@category Symbols}
const symbolsStroke = [
  SymbolCircle(),
  SymbolPlus(),
  SymbolTimes(),
  SymbolTriangle2(),
  SymbolAsterisk(),
  SymbolSquare2(),
  SymbolDiamond2()
];

/// Symbols provide a categorical shape encoding as in a scatterplot.
///
/// Symbols are centered at the origin; use a
/// [transform](http://www.w3.org/TR/SVG/coords.html#TransformAttribute) to move
/// the symbol to a different position.
///
/// {@category Symbols}
class Symbol with Digits {
  /// Optional context for rendering the generated symbol (see [Symbol.call]) as
  /// a sequence of
  /// [path method](http://www.w3.org/TR/2dcontext/#canvaspathmethods) calls.
  ///
  /// ```dart
  /// final context = …;
  /// final symbol = Symbol()..context = context;
  ///
  /// symbol.context; // context
  /// ```
  ///
  /// Defaults to null, which means the generated symbol is returned as a
  /// [path data](http://www.w3.org/TR/SVG/paths.html#PathData)
  /// string.
  Path? context;

  /// The symbol type.
  ///
  /// ```dart
  /// final symbol = Symbol()..type = (thisArg, [args]) => symbolCross;
  ///
  /// symbol.type; // symbolCross
  /// ```
  ///
  /// *this* and the symbol generator args are passed through this accessor.
  /// This is convenient for use with selection.attr, say in conjunction with an
  /// [ordinal scale](https://pub.dev/documentation/d4_scale/latest/topics/Ordinal%20scales-topic.html)
  /// to produce a categorical symbol encoding.
  ///
  /// ```dart
  /// final symbolType = ScaleOrdinal(range: symbolsFill);
  /// final symbol = Symbol()..type = (thisArg, [args]) => symbolType(args[0]["category"]);
  /// ```
  ///
  /// The symbol type accessor defaults to:
  ///
  /// ```dart
  /// type() {
  ///   return circle;
  /// }
  /// ```
  ///
  /// See [symbolsFill] and [symbolsStroke] for built-in symbol types. To
  /// implement a custom symbol type, pass an object that implements
  /// [SymbolType.draw].
  SymbolType Function(Symbol, [List<Object?>?]) type;

  /// The symbol size.
  ///
  /// ```dart
  /// final symbol = Symbol()..size = (thisArg, [args]) => 100;
  ///
  /// symbol.size; // (thisArg, [args]) => 100
  /// ```
  ///
  /// *this* and the symbol generator args are passed through this accessor.
  /// This is convenient for use with selection.attr, say in conjunction with a
  /// [linear scale](https://pub.dev/documentation/d4_scale/latest/topics/Linear%20scales-topic.html)
  /// to produce a quantitative size encoding.
  ///
  /// ```dart
  /// final symbolSize = ScaleLinear(range: [0, 100]);
  /// final symbol = Symbol()..size = (thisArg, [args]) => symbolSize(args[0]["value"]);
  /// ```
  ///
  /// The symbol size accessor defaults to:
  ///
  /// ```dart
  /// size() {
  ///   return 64;
  /// }
  /// ```
  ///
  /// See [symbolsFill] and [symbolsStroke] for built-in symbol types. To
  /// implement a custom symbol type, pass an object that implements
  /// [SymbolType.draw].
  num Function(Symbol, [List<Object?>?]) size;

  /// Constructs a new symbol generator of the specified [type] and [size]
  /// accessors.
  ///
  /// If not specified, [type] defaults to a circle, and [size] defaults to 64.
  Symbol(
      {SymbolType Function(Symbol, [List<Object?>?])? type,
      num Function(Symbol, [List<Object?>?])? size})
      : type = type ?? constant(SymbolCircle()) as dynamic,
        size = size ?? constant(64) as dynamic;

  /// Constructs a new symbol generator of the specified [type] and [size].
  ///
  /// If not specified, [type] defaults to a circle, and [size] defaults to 64.
  Symbol.withConstants({SymbolType? type, num? size})
      : type = constant(type ?? SymbolCircle()),
        size = constant(size ?? 64);

  /// Generates a symbol for the given [args].
  ///
  /// The [args] are arbitrary; they are propagated to the symbol generator’s
  /// accessor functions along with the this object. With the default settings,
  /// invoking the symbol generator produces a circle of 64 square pixels.
  ///
  /// ```dart
  /// Symbol()() // "M4.514,0A4.514,4.514,0,1,1,-4.514,0A4.514,4.514,0,1,1,4.514,0"
  /// ```
  ///
  /// If the symbol generator has a [context], then the symbol is rendered to
  /// this context as a sequence of
  /// [path method](http://www.w3.org/TR/2dcontext/#canvaspathmethods) calls and
  /// this function returns void. Otherwise, a
  /// [path data](http://www.w3.org/TR/SVG/paths.html#PathData) string is
  /// returned.
  String? call([List<Object?>? args]) {
    Path? buffer;
    context ??= buffer = path();
    type(this, args).draw(context!, size(this, args));
    if (buffer != null) {
      context = null;
      return buffer.toString();
    }

    return null;
  }

  /// Defines the [Symbol.type]-accessor as a constant function that always
  /// returns the specified value.
  void constType(SymbolType type) {
    this.type = constant(type);
  }

  /// Defines the [Symbol.size]-accessor as a constant function that always
  /// returns the specified value.
  void constSize(num size) {
    this.size = constant(size);
  }

  /// The maximum number of digits after the decimal separator.
  ///
  /// ```dart
  /// final symbol = Symbol()..digits = 3;
  ///
  /// symbol.digits; // 3
  /// ```
  ///
  /// This option only applies when the associated [context] is null, as when
  /// this symbol generator is used to produce
  /// [path data](http://www.w3.org/TR/SVG/paths.html#PathData).
  @override
  get digits;
}
