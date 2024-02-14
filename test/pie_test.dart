import 'dart:math';

import 'package:d4_shape/src/pie.dart';
import 'package:test/test.dart';

import 'equals_pie_arc.dart';

void main() {
  test("pie() returns a default pie shape", () {
    final p = Pie.withDefaults();
    expect(p.value(42, 0, []), 42);
    expect(p.sortValues!(1, 2), greaterThan(0));
    expect(p.sortValues!(2, 1), lessThan(0));
    expect(p.sortValues!(1, 1), isZero);
    expect(p.sort, isNull);
    expect(p.startAngle(p), isZero);
    expect(p.endAngle(p), 2 * pi);
    expect(p.padAngle(p), isZero);
  });

  test("pie(data) returns arcs in input order", () {
    final p = Pie.withDefaults();
    expect(p([1, 3, 2]), [
      EqualsPieArc({
        "value": 1,
        "index": 2,
        "startAngle": 5.235987755982988,
        "endAngle": 6.283185307179585,
        "padAngle": 0
      }, 1),
      EqualsPieArc({
        "value": 3,
        "index": 0,
        "startAngle": 0.000000000000000,
        "endAngle": 3.141592653589793,
        "padAngle": 0
      }, 3),
      EqualsPieArc({
        "value": 2,
        "index": 1,
        "startAngle": 3.141592653589793,
        "endAngle": 5.235987755982988,
        "padAngle": 0
      }, 2)
    ]);
  });

  test("pie(data) accepts an iterable", () {
    final p = Pie.withDefaults();
    expect(p({1, 3, 2}), [
      EqualsPieArc({
        "value": 1,
        "index": 2,
        "startAngle": 5.235987755982988,
        "endAngle": 6.283185307179585,
        "padAngle": 0
      }, 1),
      EqualsPieArc({
        "value": 3,
        "index": 0,
        "startAngle": 0.000000000000000,
        "endAngle": 3.141592653589793,
        "padAngle": 0
      }, 3),
      EqualsPieArc({
        "value": 2,
        "index": 1,
        "startAngle": 3.141592653589793,
        "endAngle": 5.235987755982988,
        "padAngle": 0
      }, 2)
    ]);
  });

  test("pie(data) treats negative values as zero", () {
    final p = Pie.withDefaults();
    expect(p([1, 0, -1]), [
      EqualsPieArc({
        "value": 1,
        "index": 0,
        "startAngle": 0.000000000000000,
        "endAngle": 6.283185307179586,
        "padAngle": 0
      }, 1),
      EqualsPieArc({
        "value": 0,
        "index": 1,
        "startAngle": 6.283185307179586,
        "endAngle": 6.283185307179586,
        "padAngle": 0
      }, 0),
      EqualsPieArc({
        "value": -1,
        "index": 2,
        "startAngle": 6.283185307179586,
        "endAngle": 6.283185307179586,
        "padAngle": 0
      }, -1)
    ]);
  });

  test("pie(data) treats NaN values as zero", () {
    final p = Pie.withDefaults();
    final actual = p([1, double.nan]);
    final expected = [
      EqualsPieArc({
        "value": 1,
        "index": 0,
        "startAngle": 0.000000000000000,
        "endAngle": 6.283185307179586,
        "padAngle": 0
      }, 1),
      EqualsPieArc({
        "value": isNaN,
        "index": 1,
        "startAngle": 6.283185307179586,
        "endAngle": 6.283185307179586,
        "padAngle": 0
      }, isNaN),
    ];
    expect(actual[1].data, isNaN);
    expect(actual[1]["value"], isNaN);
    expect(actual, expected);
  });

  test("pie(data) puts everything at the startAngle when the sum is zero", () {
    final p = Pie.withDefaults();
    expect(p([0, 0]), [
      EqualsPieArc({
        "value": 0,
        "index": 0,
        "startAngle": 0,
        "endAngle": 0,
        "padAngle": 0
      }, 0),
      EqualsPieArc({
        "value": 0,
        "index": 1,
        "startAngle": 0,
        "endAngle": 0,
        "padAngle": 0
      }, 0)
    ]);
    expect((p..constStartAngle(1))([0, 0]), [
      EqualsPieArc({
        "value": 0,
        "index": 0,
        "startAngle": 1,
        "endAngle": 1,
        "padAngle": 0
      }, 0),
      EqualsPieArc({
        "value": 0,
        "index": 1,
        "startAngle": 1,
        "endAngle": 1,
        "padAngle": 0
      }, 0)
    ]);
  });

  test("pie(data) restricts |endAngle - startAngle| to τ", () {
    final p = Pie.withDefaults();
    expect(
        (p
          ..constStartAngle(0)
          ..constEndAngle(7))([1, 2]),
        [
          EqualsPieArc({
            "value": 1,
            "index": 1,
            "startAngle": 4.1887902047863905,
            "endAngle": 6.2831853071795860,
            "padAngle": 0
          }, 1),
          EqualsPieArc({
            "value": 2,
            "index": 0,
            "startAngle": 0.0000000000000000,
            "endAngle": 4.1887902047863905,
            "padAngle": 0
          }, 2)
        ]);
    expect(
        (p
          ..constStartAngle(7)
          ..constEndAngle(0))([1, 2]),
        [
          EqualsPieArc({
            "value": 1,
            "index": 1,
            "startAngle": 2.8112097952136095,
            "endAngle": 0.7168146928204142,
            "padAngle": 0
          }, 1),
          EqualsPieArc({
            "value": 2,
            "index": 0,
            "startAngle": 7.0000000000000000,
            "endAngle": 2.8112097952136095,
            "padAngle": 0
          }, 2)
        ]);
    expect(
        (p
          ..constStartAngle(1)
          ..constEndAngle(8))([1, 2]),
        [
          EqualsPieArc({
            "value": 1,
            "index": 1,
            "startAngle": 5.1887902047863905,
            "endAngle": 7.2831853071795860,
            "padAngle": 0
          }, 1),
          EqualsPieArc({
            "value": 2,
            "index": 0,
            "startAngle": 1.0000000000000000,
            "endAngle": 5.1887902047863905,
            "padAngle": 0
          }, 2)
        ]);
    expect(
        (p
          ..constStartAngle(8)
          ..constEndAngle(1))([1, 2]),
        [
          EqualsPieArc({
            "value": 1,
            "index": 1,
            "startAngle": 3.8112097952136095,
            "endAngle": 1.7168146928204142,
            "padAngle": 0
          }, 1),
          EqualsPieArc({
            "value": 2,
            "index": 0,
            "startAngle": 8.0000000000000000,
            "endAngle": 3.8112097952136095,
            "padAngle": 0
          }, 2)
        ]);
  });

  test("pie.value(value)(data) observes the specified value function", () {
    expect(
        (Pie.withDefaults()
          ..value = (d, i, _) {
            return i;
          })(List.filled(3, 0)),
        [
          EqualsPieArc({
            "value": 0,
            "index": 2,
            "startAngle": 6.2831853071795860,
            "endAngle": 6.2831853071795860,
            "padAngle": 0
          }, 0),
          EqualsPieArc({
            "value": 1,
            "index": 1,
            "startAngle": 4.1887902047863905,
            "endAngle": 6.2831853071795860,
            "padAngle": 0
          }, 0),
          EqualsPieArc({
            "value": 2,
            "index": 0,
            "startAngle": 0.0000000000000000,
            "endAngle": 4.1887902047863905,
            "padAngle": 0
          }, 0)
        ]);
  });

  test("pie.value(f)(data) passes d, i and data to the specified function f",
      () {
    const data = [2, 3];
    var actual = [];
    (Pie.withDefaults()
      ..value = (d, i, data) {
        actual.add([d, i, data]);
        return 0;
      })(data);
    expect(actual, [
      [2, 0, data],
      [3, 1, data]
    ]);
  });

  test(
      "pie().startAngle(f)(…) propagates the context and arguments to the specified function f",
      () {
    final p = Pie.withDefaults();
    final expected = <String, dynamic>{
      "that": p,
      "args": [42]
    };
    late Map actual;
    (p.startAngle = (p, [args]) {
      actual = {"that": p, "args": args};
      return 0;
    })(expected["that"], expected["args"]);
    expect(actual, expected);
  });

  test("pie().startAngle(θ)(data) observes the specified start angle", () {
    expect((Pie.withDefaults()..constStartAngle(pi))([1, 2, 3]), [
      EqualsPieArc({
        "value": 1,
        "index": 2,
        "startAngle": 5.759586531581287,
        "endAngle": 6.283185307179586,
        "padAngle": 0
      }, 1),
      EqualsPieArc({
        "value": 2,
        "index": 1,
        "startAngle": 4.712388980384690,
        "endAngle": 5.759586531581287,
        "padAngle": 0
      }, 2),
      EqualsPieArc({
        "value": 3,
        "index": 0,
        "startAngle": 3.141592653589793,
        "endAngle": 4.712388980384690,
        "padAngle": 0
      }, 3)
    ]);
  });

  test("pie().endAngle(θ)(data) observes the specified end angle", () {
    expect((Pie.withDefaults()..constEndAngle(pi))([1, 2, 3]), [
      EqualsPieArc({
        "value": 1,
        "index": 2,
        "startAngle": 2.6179938779914940,
        "endAngle": 3.1415926535897927,
        "padAngle": 0
      }, 1),
      EqualsPieArc({
        "value": 2,
        "index": 1,
        "startAngle": 1.5707963267948966,
        "endAngle": 2.6179938779914940,
        "padAngle": 0
      }, 2),
      EqualsPieArc({
        "value": 3,
        "index": 0,
        "startAngle": 0.0000000000000000,
        "endAngle": 1.5707963267948966,
        "padAngle": 0
      }, 3)
    ]);
  });

  test("pie().padAngle(δ)(data) observes the specified pad angle", () {
    expect((Pie.withDefaults()..constPadAngle(0.1))([1, 2, 3]), [
      EqualsPieArc({
        "value": 1,
        "index": 2,
        "startAngle": 5.1859877559829880,
        "endAngle": 6.2831853071795850,
        "padAngle": 0.1
      }, 1),
      EqualsPieArc({
        "value": 2,
        "index": 1,
        "startAngle": 3.0915926535897933,
        "endAngle": 5.1859877559829880,
        "padAngle": 0.1
      }, 2),
      EqualsPieArc({
        "value": 3,
        "index": 0,
        "startAngle": 0.0000000000000000,
        "endAngle": 3.0915926535897933,
        "padAngle": 0.1
      }, 3)
    ]);
  });

  test(
      "pie().endAngle(f)(…) propagates the context and arguments to the specified function f",
      () {
    final p = Pie.withDefaults();
    final expected = <String, dynamic>{
      "that": p,
      "args": [42]
    };
    late Map actual;
    (p.endAngle = (p, [args]) {
      actual = {"that": p, "args": args};
      return 0;
    })(expected["that"], expected["args"]);
    expect(actual, expected);
  });

  test(
      "pie().padAngle(f)(…) propagates the context and arguments to the specified function f",
      () {
    final p = Pie.withDefaults();
    final expected = <String, dynamic>{
      "that": p,
      "args": [42]
    };
    late Map actual;
    (p.padAngle = (p, [args]) {
      actual = {"that": p, "args": args};
      return 0;
    })(expected["that"], expected["args"]);
    expect(actual, expected);
  });

  test(
      "pie().startAngle(θ₀).endAngle(θ₁).padAngle(δ)(data) restricts the pad angle to |θ₁ - θ₀| / data.length",
      () {
    expect(
        (Pie.withDefaults()
          ..constStartAngle(0)
          ..constEndAngle(pi)
          ..constPadAngle(double.infinity))([1, 2, 3]),
        [
          EqualsPieArc({
            "value": 1,
            "index": 2,
            "startAngle": 2.0943951023931953,
            "endAngle": 3.1415926535897930,
            "padAngle": 1.0471975511965976
          }, 1),
          EqualsPieArc({
            "value": 2,
            "index": 1,
            "startAngle": 1.0471975511965976,
            "endAngle": 2.0943951023931953,
            "padAngle": 1.0471975511965976
          }, 2),
          EqualsPieArc({
            "value": 3,
            "index": 0,
            "startAngle": 0.0000000000000000,
            "endAngle": 1.0471975511965976,
            "padAngle": 1.0471975511965976
          }, 3)
        ]);
    expect(
        (Pie.withDefaults()
          ..constStartAngle(0)
          ..constEndAngle(-pi)
          ..constPadAngle(double.infinity))([1, 2, 3]),
        [
          EqualsPieArc({
            "value": 1,
            "index": 2,
            "startAngle": -2.0943951023931953,
            "endAngle": -3.1415926535897930,
            "padAngle": 1.0471975511965976
          }, 1),
          EqualsPieArc({
            "value": 2,
            "index": 1,
            "startAngle": -1.0471975511965976,
            "endAngle": -2.0943951023931953,
            "padAngle": 1.0471975511965976
          }, 2),
          EqualsPieArc({
            "value": 3,
            "index": 0,
            "startAngle": 0.0000000000000000,
            "endAngle": -1.0471975511965976,
            "padAngle": 1.0471975511965976
          }, 3)
        ]);
  });

  test(
      "pie.sortValues(f) sorts arcs by value per the specified comparator function f",
      () {
    final p = Pie.withDefaults();
    expect(
        (p
          ..sortValues = (a, b) {
            return (a - b).sign.toInt();
          })([1, 3, 2]),
        [
          EqualsPieArc({
            "value": 1,
            "index": 0,
            "startAngle": 0.0000000000000000,
            "endAngle": 1.0471975511965976,
            "padAngle": 0
          }, 1),
          EqualsPieArc({
            "value": 3,
            "index": 2,
            "startAngle": 3.1415926535897930,
            "endAngle": 6.2831853071795860,
            "padAngle": 0
          }, 3),
          EqualsPieArc({
            "value": 2,
            "index": 1,
            "startAngle": 1.0471975511965976,
            "endAngle": 3.1415926535897930,
            "padAngle": 0
          }, 2)
        ]);
    expect(
        (p
          ..sortValues = (a, b) {
            return (b - a).sign.toInt();
          })([1, 3, 2]),
        [
          EqualsPieArc({
            "value": 1,
            "index": 2,
            "startAngle": 5.2359877559829880,
            "endAngle": 6.2831853071795850,
            "padAngle": 0
          }, 1),
          EqualsPieArc({
            "value": 3,
            "index": 0,
            "startAngle": 0.0000000000000000,
            "endAngle": 3.1415926535897930,
            "padAngle": 0
          }, 3),
          EqualsPieArc({
            "value": 2,
            "index": 1,
            "startAngle": 3.1415926535897930,
            "endAngle": 5.2359877559829880,
            "padAngle": 0
          }, 2)
        ]);
    expect(p.sort, isNull);
  });

  test("pie.sort(f) sorts arcs by data per the specified comparator function f",
      () {
    const a = (value: 1, name: "a");
    const b = (value: 2, name: "b");
    const c = (value: 3, name: "c");
    final p = Pie((({num value, String name}) d, _, __) => d.value);
    expect(
        (p
          ..sort = (a, b) {
            return a.name.compareTo(b.name);
          })([a, c, b]),
        [
          EqualsPieArc({
            "value": 1,
            "index": 0,
            "startAngle": 0.0000000000000000,
            "endAngle": 1.0471975511965976,
            "padAngle": 0
          }, a),
          EqualsPieArc({
            "value": 3,
            "index": 2,
            "startAngle": 3.1415926535897930,
            "endAngle": 6.2831853071795860,
            "padAngle": 0
          }, c),
          EqualsPieArc({
            "value": 2,
            "index": 1,
            "startAngle": 1.0471975511965976,
            "endAngle": 3.1415926535897930,
            "padAngle": 0
          }, b)
        ]);
    expect(
        (p
          ..sort = (a, b) {
            return b.name.compareTo(a.name);
          })([a, c, b]),
        [
          EqualsPieArc({
            "value": 1,
            "index": 2,
            "startAngle": 5.2359877559829880,
            "endAngle": 6.2831853071795850,
            "padAngle": 0
          }, a),
          EqualsPieArc({
            "value": 3,
            "index": 0,
            "startAngle": 0.0000000000000000,
            "endAngle": 3.1415926535897930,
            "padAngle": 0
          }, c),
          EqualsPieArc({
            "value": 2,
            "index": 1,
            "startAngle": 3.1415926535897930,
            "endAngle": 5.2359877559829880,
            "padAngle": 0
          }, b)
        ]);
    expect(p.sortValues, null);
  });
}
