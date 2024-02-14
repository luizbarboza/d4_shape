import 'dart:math' as math;

final atan2 = math.atan2;
final cos = math.cos;
final max = math.max;
final min = math.min;
final sin = math.sin;
final sqrt = math.sqrt;

const epsilon = 1e-12;
const pi = math.pi;
const halfPi = pi / 2;
const tau = 2 * pi;

num abs(num x) => x.abs();

double acos(num x) {
  return x > 1
      ? 0
      : x < -1
          ? pi
          : math.acos(x);
}

double asin(num x) {
  return x >= 1
      ? halfPi
      : x <= -1
          ? -halfPi
          : math.asin(x);
}
