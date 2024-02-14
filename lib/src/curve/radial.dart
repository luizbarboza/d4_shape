import 'dart:math';

import 'package:d4_path/d4_path.dart';

import 'curve.dart';
import 'linear.dart';

Curve curveRadialLinear(Path context) => curveRadial(curveLinear)(context);

class Radial implements Curve {
  final Curve _curve;

  Radial(Curve curve) : _curve = curve;

  @override
  areaStart() {
    _curve.areaStart();
  }

  @override
  areaEnd() {
    _curve.areaEnd();
  }

  @override
  lineStart() {
    _curve.lineStart();
  }

  @override
  lineEnd() {
    _curve.lineEnd();
  }

  @override
  point(a, r) {
    _curve.point(r * sin(a), r * -cos(a));
  }
}

CurveFactory curveRadial(CurveFactory curve) =>
    (Path context) => Radial(curve(context));
