import 'dart:math';

import 'package:d4_path/d4_path.dart';
import 'package:d4_shape/d4_shape.dart';
import 'package:test/test.dart';

import 'equals_path.dart';

void main() {
  test("link(curve) returns a default link with the given curve", () {
    final l = Link.withDefaults(curve: curveLinear);
    expect(
        l.source(l, [
          {
            "source": [42]
          }
        ]),
        [42]);
    expect(
        l.target(l, [
          {
            "target": [34]
          }
        ]),
        [34]);
    expect(l.x([42, 34]), 42);
    expect(l.y([42, 34]), 34);
    expect(l.context, null);
    expect(
        l([
          {
            "source": [0, 1],
            "target": [2, 3]
          }
        ]),
        EqualsPath("M0,1L2,3"));
  });

  test("link.source(source) sets source", () {
    final l = Link.withDefaults(curve: curveLinear);
    List<num> x(_, [args]) => args[0]["x"];
    expect(l..source = x, l);
    expect(l.source, x);
    expect(
        l([
          {
            "x": [0, 1],
            "target": [2, 3]
          }
        ]),
        EqualsPath("M0,1L2,3"));
  });

  test("link.target(target) sets target", () {
    final l = Link.withDefaults(curve: curveLinear);
    List<num> x(_, [args]) => args[0]["x"];
    expect(l..target = x, l);
    expect(l.target, x);
    expect(
        l([
          {
            "source": [0, 1],
            "x": [2, 3]
          }
        ]),
        EqualsPath("M0,1L2,3"));
  });

  test("link.source(f)(..args) passes arguments to the specified function f",
      () {
    const data = {
      "source": [0, 1],
      "target": [2, 3]
    };
    const extra = {
      "extra": [4, 5]
    };
    final actual = [];
    (Link.withDefaults(curve: curveLinear)
      ..source = (_, [args]) {
        actual.add(args!.sublist(0));
        return (args[0] as Map)["source"];
      })([data, extra]);
    expect(actual, [
      [data, extra]
    ]);
  });

  test(
      "link.target(f)(..args) passes source and arguments to the specified function f",
      () {
    const data = {
      "source": [0, 1],
      "target": [2, 3]
    };
    const extra = {
      "extra": [4, 5]
    };
    final actual = [];
    (Link.withDefaults(curve: curveLinear)
      ..target = (_, [args]) {
        actual.add(args!.sublist(0));
        return (args[0] as Map)["target"];
      })([data, extra]);
    expect(actual, [
      [data, extra]
    ]);
  });

  test("link.x(x) sets x", () {
    final l = Link.withDefaults(curve: curveLinear);
    num x(List<num> d, [_]) => d[0] * 2;
    expect(l..x = x, l);
    expect(l.x, x);
    expect(
        l([
          {
            "source": [0, 1],
            "target": [1, 3]
          }
        ]),
        EqualsPath("M0,1L2,3"));
  });

  test("link.y(y) sets y", () {
    final l = Link.withDefaults(curve: curveLinear);
    num y(List<num> d, [_]) => d[1] / 2;
    expect(l..y = y, l);
    expect(l.y, y);
    expect(
        l([
          {
            "source": [0, 2],
            "target": [2, 6]
          }
        ]),
        EqualsPath("M0,1L2,3"));
  });

  test(
      "link.x(f)(..args) passes source and arguments to the specified function f",
      () {
    const source = [0, 1];
    const target = [2, 3];
    const data = {"source": source, "target": target};
    const extra = {
      "extra": [4, 5]
    };
    final actual = [];
    (Link.withDefaults(curve: curveLinear)
      ..x = (_, [args]) {
        actual.add([_, args]);
        return _[0];
      })([data, extra]);
    expect(actual, [
      [
        source,
        [data, extra]
      ],
      [
        target,
        [data, extra]
      ]
    ]);
  });

  test(
      "link.y(f)(..args) passes source and arguments to the specified function f",
      () {
    const source = [0, 1];
    const target = [2, 3];
    const data = {"source": source, "target": target};
    const extra = {
      "extra": [4, 5]
    };
    final actual = [];
    (Link.withDefaults(curve: curveLinear)
      ..y = (_, [args]) {
        actual.add([_, args]);
        return _[0];
      })([data, extra]);
    expect(actual, [
      [
        source,
        [data, extra]
      ],
      [
        target,
        [data, extra]
      ]
    ]);
  });

  test("linkHorizontal() is an alias for link(curveBumpX)", () {
    final l = Link.horizontalWithDefaults(),
        l2 = Link.withDefaults(curve: curveBumpX);
    expect(l.source, l2.source);
    expect(l.target, l2.target);
    expect(l.x, l2.x);
    expect(l.y, l2.y);
    expect(l.context, l2.context);
    expect(
        l([
          {
            "source": [0, 1],
            "target": [2, 3]
          }
        ]),
        EqualsPath(l2([
          {
            "source": [0, 1],
            "target": [2, 3]
          }
        ])!));
  });

  test("linkVertical() is an alias for link(curveBumpY)", () {
    final l = Link.verticalWithDefaults(),
        l2 = Link.withDefaults(curve: curveBumpY);
    expect(l.source, l2.source);
    expect(l.target, l2.target);
    expect(l.x, l2.x);
    expect(l.y, l2.y);
    expect(l.context, l2.context);
    expect(
        l([
          {
            "source": [0, 1],
            "target": [2, 3]
          }
        ]),
        EqualsPath(l2([
          {
            "source": [0, 1],
            "target": [2, 3]
          }
        ])!));
  });

  test("link.context(context) sets the context", () {
    final p = Path.round(6);
    final l = Link.withDefaults(curve: curveLinear)..context = p;
    expect(
        l([
          {
            "source": [0, e],
            "target": [pi, 3]
          }
        ]),
        null);
    expect(p.toString(), "M0.0,2.718282L3.141593,3.0");
  });

  test("linkRadial() works as expected", () {
    final l = LinkRadial.withDefaults(),
        l2 = Link.withDefaults(curve: curveLinear);
    expect(l.source, l2.source);
    expect(l.target, l2.target);
    expect(l.angle, l2.x);
    expect(l.radius, l2.y);
    expect(l.context, l2.context);
    expect(
        l([
          {
            "source": [0, 1],
            "target": [pi / 2, 3]
          }
        ]),
        EqualsPath("M0,-1C0,-2,2,0,3,0"));
  });
}
