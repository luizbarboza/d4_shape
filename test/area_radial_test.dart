import 'package:d4_path/d4_path.dart';
import 'package:d4_shape/d4_shape.dart';
import 'package:test/test.dart';

import 'equals_path.dart';

void main() {
  test("areaRadial() returns a default radial area shape", () {
    final a = AreaRadial.withDefaults();
    expect(a.startAngle([42, 34], 0, []), 42);
    expect(a.endAngle, null);
    expect(a.innerRadius([42, 34], 0, []), 0);
    expect(a.outerRadius!([42, 34], 0, []), 34);
    expect(a.defined([42, 34], 0, []), true);
    expect(a.curve, curveLinear);
    expect(a.context, null);
    expect(
        a([
          [0, 1],
          [2, 3],
          [4, 5]
        ]),
        EqualsPath("M0,-1L2.727892,1.248441L-3.784012,3.268218L0,0L0,0L0,0Z"));
  });

  test("areaRadial.lineStartAngle() returns a line derived from the area", () {
    defined(_, __, ___) {
      return true;
    }

    final curve = curveCardinal;
    final context = Path();
    startAngle(_, __, ___) {
      return 0;
    }

    num endAngle(_, __, ___) {
      return 0;
    }

    num radius(_, __, ___) {
      return 0;
    }

    final a = AreaRadial.withDefaults()
      ..defined = defined
      ..curve = curve
      ..context = context
      ..radius = radius
      ..startAngle = startAngle
      ..endAngle = endAngle;
    final l = a.lineStartAngle();
    expect(l.defined, defined);
    expect(l.curve, curve);
    expect(l.context, context);
    expect(l.angle, startAngle);
    expect(l.radius, radius);
  });

  test("areaRadial.lineEndAngle() returns a line derived from the area", () {
    defined(_, __, ___) {
      return true;
    }

    final curve = curveCardinal;
    final context = Path();
    num startAngle(_, __, ___) {
      return 0;
    }

    num endAngle(_, __, ___) {
      return 0;
    }

    num radius(_, __, ___) {
      return 0;
    }

    final a = AreaRadial.withDefaults()
      ..defined = defined
      ..curve = curve
      ..context = context
      ..radius = radius
      ..startAngle = startAngle
      ..endAngle = endAngle;
    final l = a.lineEndAngle();
    expect(l.defined, defined);
    expect(l.curve, curve);
    expect(l.context, context);
    expect(l.angle, endAngle);
    expect(l.radius, radius);
  });

  test("areaRadial.lineInnerRadius() returns a line derived from the area", () {
    defined(_, __, ___) {
      return true;
    }

    final curve = curveCardinal;
    final context = Path();
    num angle(_, __, ___) {
      return 0;
    }

    num innerRadius(_, __, ___) {
      return 0;
    }

    num outerRadius(_, __, ___) {
      return 0;
    }

    final a = AreaRadial.withDefaults()
      ..defined = defined
      ..curve = curve
      ..context = context
      ..angle = angle
      ..innerRadius = innerRadius
      ..outerRadius = outerRadius;
    final l = a.lineInnerRadius();
    expect(l.defined, defined);
    expect(l.curve, curve);
    expect(l.context, context);
    expect(l.angle, angle);
    expect(l.radius, innerRadius);
  });

  test("areaRadial.lineOuterRadius() returns a line derived from the area", () {
    defined(_, __, ___) {
      return true;
    }

    final curve = curveCardinal;
    final context = Path();
    num angle(_, __, ___) {
      return 0;
    }

    num innerRadius(_, __, ___) {
      return 0;
    }

    num outerRadius(_, __, ___) {
      return 0;
    }

    final a = AreaRadial.withDefaults()
      ..defined = defined
      ..curve = curve
      ..context = context
      ..angle = angle
      ..innerRadius = innerRadius
      ..outerRadius = outerRadius;
    final l = a.lineOuterRadius();
    expect(l.defined, defined);
    expect(l.curve, curve);
    expect(l.context, context);
    expect(l.angle, angle);
    expect(l.radius, outerRadius);
  });
}
