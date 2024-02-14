import 'dart:math';

/// Returns the point \[*x*, *y*\] for the given [angle] in radians, with 0 at
/// -y (12 o’clock) and positive angles proceeding clockwise, and the given
/// [radius].
///
/// ```dart
/// pointRadial(pi / 3, 100) // (86.60254037844386, -50)
/// ```
///
/// {@category Symbols}
List<num> pointRadial(num angle, num radius) {
  return [radius * cos(angle -= pi / 2), radius * sin(angle)];
}
