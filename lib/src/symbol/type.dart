import 'package:d4_path/d4_path.dart';

import '../symbol.dart';

/// Symbol types are typically not used directly, instead being passed to
/// [Symbol.type]. However, you can define your own symbol type implementation
/// should none of the built-in types satisfy your needs using the following
/// interface.
///
/// You can also use this low-level interface with a built-in symbol type as an
/// alternative to the symbol generator.
///
/// ```dart
/// final path = Path.round(3);
/// final circle = SymbolCircle.draw(path, 64);
/// path.toString(); // "M4.514,0A4.514,4.514,0,1,1,-4.514,0A4.514,4.514,0,1,1,4.514,0"
/// ```
///
/// {@category Symbols}
abstract interface class SymbolType {
  const SymbolType();

  /// Renders this symbol type to the specified [context] with the specified
  /// [size] in square pixels.
  ///
  /// The [context] implements the
  /// [CanvasPathMethods](http://www.w3.org/TR/2dcontext/#canvaspathmethods)
  /// interface. (Note that this is a subset of the CanvasRenderingContext2D
  /// interface!) See also
  /// [d4_path](https://pub.dev/documentation/d4_path/latest/d4_path/d4_path-library.html).
  void draw(Path context, num size);
}
