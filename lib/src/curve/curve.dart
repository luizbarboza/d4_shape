import 'package:d4_path/d4_path.dart';

import '../area.dart';
import '../line.dart';
import 'linear.dart';

/// Curves are typically not used directly, instead being passed to [Line.curve]
/// and [Area.curve]. However, you can define your own curve implementation
/// should none of the built-in curves satisfy your needs using the following
/// interface; see the [curveLinear] source for an example implementation.
///
/// You can also use this low-level interface with a built-in curve type as an
/// alternative to the line and area generators.
///
/// {@category Curves}
abstract interface class Curve {
  /// Indicates the start of a new area segment.
  ///
  /// Each area segment consists of exactly two line segments ([lineStart]):
  /// the topline, followed by the baseline, with the baseline points in reverse
  /// order.
  void areaStart();

  /// Indicates the end of the current area segment.
  void areaEnd();

  /// Indicates the start of a new line segment. Zero or more [point]s will
  /// follow.
  void lineStart();

  /// Indicates the end of the current line segment.
  void lineEnd();

  /// Indicates a new point in the current line segment with the given [x]- and
  /// [y]-values.
  void point(num x, num y);
}

/// The definition of a curve factory: given a [context], returns a curve.
///
/// {@category Curves}
typedef CurveFactory = Curve Function(Path context);
