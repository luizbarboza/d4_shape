import 'dart:math';

import 'package:d4_shape/d4_shape.dart';
import 'package:test/test.dart';

import 'equals_path.dart';

void main() {
  test(
      "(arc..innerRadius = f)(…) propagates the context and arguments to the specified function f",
      () {
    final arc = Arc.withDefaults();
    final expected = {
      "that": arc,
      "args": [
        {
          "innerRadius": 42,
          "outerRadius": 43,
          "cornerRadius": 44,
          "startAngle": 45,
          "endAngle": 46,
          "padAngle": 47,
          "padRadius": 48
        }
      ]
    };
    Map<String, Object?>? actual;
    (arc
      ..innerRadius = (arc, [args]) {
        actual = {"that": arc, "args": args};
        return double.nan;
      })(expected["args"] as List<Object?>);
    expect(actual, expected);
  });

  test(
      "(arc..outerRadius = f)(…) propagates the context and arguments to the specified function f",
      () {
    final arc = Arc.withDefaults();
    final expected = {
      "that": arc,
      "args": [
        {
          "innerRadius": 42,
          "outerRadius": 43,
          "cornerRadius": 44,
          "startAngle": 45,
          "endAngle": 46,
          "padAngle": 47,
          "padRadius": 48
        }
      ]
    };
    Map<String, Object?>? actual;
    (arc
      ..outerRadius = (arc, [args]) {
        actual = {"that": arc, "args": args};
        return double.nan;
      })(expected["args"] as List<Object?>);
    expect(actual, expected);
  });

  test(
      "(arc..cornerRadius = f)(…) propagates the context and arguments to the specified function f",
      () {
    final arc = Arc.withDefaults();
    final expected = {
      "that": arc,
      "args": [
        {
          "innerRadius": 42,
          "outerRadius": 43,
          "cornerRadius": 44,
          "startAngle": 45,
          "endAngle": 46,
          "padAngle": 47,
          "padRadius": 48
        }
      ]
    };
    Map<String, Object?>? actual;
    (arc
      ..cornerRadius = (arc, [args]) {
        actual = {"that": arc, "args": args};
        return double.nan;
      })(expected["args"] as List<Object?>);
    expect(actual, expected);
  });

  test(
      "(arc..startAngle = f)(…) propagates the context and arguments to the specified function f",
      () {
    final arc = Arc.withDefaults();
    final expected = {
      "that": arc,
      "args": [
        {
          "innerRadius": 42,
          "outerRadius": 43,
          "cornerRadius": 44,
          "startAngle": 45,
          "endAngle": 46,
          "padAngle": 47,
          "padRadius": 48
        }
      ]
    };
    Map<String, Object?>? actual;
    (arc
      ..startAngle = (arc, [args]) {
        actual = {"that": arc, "args": args};
        return double.nan;
      })(expected["args"] as List<Object?>);
    expect(actual, expected);
  });

  test(
      "(arc..endAngle = f)(…) propagates the context and arguments to the specified function f",
      () {
    final arc = Arc.withDefaults();
    final expected = {
      "that": arc,
      "args": [
        {
          "innerRadius": 42,
          "outerRadius": 43,
          "cornerRadius": 44,
          "startAngle": 45,
          "endAngle": 46,
          "padAngle": 47,
          "padRadius": 48
        }
      ]
    };
    Map<String, Object?>? actual;
    (arc
      ..endAngle = (arc, [args]) {
        actual = {"that": arc, "args": args};
        return double.nan;
      })(expected["args"] as List<Object?>);
    expect(actual, expected);
  });

  test(
      "(arc..padAngle = f)(…) propagates the context and arguments to the specified function f",
      () {
    final arc = Arc.withDefaults();
    final expected = {
      "that": arc,
      "args": [
        {
          "innerRadius": 42,
          "outerRadius": 43,
          "cornerRadius": 44,
          "startAngle": 45,
          "endAngle": 46,
          "padAngle": 47,
          "padRadius": 48
        }
      ]
    };
    Map<String, Object?>? actual;
    (arc
      ..padAngle = (arc, [args]) {
        actual = {"that": arc, "args": args};
        return double.nan;
      })(expected["args"] as List<Object?>);
    expect(actual, expected);
  });

  test(
      "(arc..padRadius = f)(…) propagates the context and arguments to the specified function f",
      () {
    final arc = Arc.withDefaults();
    final expected = {
      "that": arc,
      "args": [
        {
          "innerRadius": 42,
          "outerRadius": 43,
          "cornerRadius": 44,
          "startAngle": 45,
          "endAngle": 46,
          "padAngle": 47,
          "padRadius": 48
        }
      ]
    };
    Map<String, Object?>? actual;
    (arc
      ..padRadius = (arc, [args]) {
        actual = {"that": arc, "args": args};
        return double.nan;
      })(expected["args"] as List<Object?>);
    expect(actual, expected);
  });

  test(
      "Arc.withDefaults().centroid(…) computes the midpoint of the center line of the arc",
      () {
    final a = Arc.withDefaults();
    round(num x) => (x * 1e6).round() / 1e6;
    expect(
        a.centroid([
          {
            "innerRadius": 0,
            "outerRadius": 100,
            "startAngle": 0,
            "endAngle": pi
          }
        ]).map(round),
        [50, 0]);
    expect(
        a.centroid([
          {
            "innerRadius": 0,
            "outerRadius": 100,
            "startAngle": 0,
            "endAngle": pi / 2
          }
        ]).map(round),
        [35.355339, -35.355339]);
    expect(
        a.centroid([
          {
            "innerRadius": 50,
            "outerRadius": 100,
            "startAngle": 0,
            "endAngle": -pi
          }
        ]).map(round),
        [-75, -0]);
    expect(
        a.centroid([
          {
            "innerRadius": 50,
            "outerRadius": 100,
            "startAngle": 0,
            "endAngle": -pi / 2
          }
        ]).map(round),
        [-53.033009, -53.033009]);
  });

  test(
      "Arc.withDefaults().innerRadius(f).centroid(…) propagates the context and arguments to the specified function f",
      () {
    final arc = Arc.withDefaults();
    final expected = {
      "that": arc,
      "args": [
        {
          "innerRadius": 42,
          "outerRadius": 43,
          "cornerRadius": 44,
          "startAngle": 45,
          "endAngle": 46,
          "padAngle": 47,
          "padRadius": 48
        }
      ]
    };
    late Map actual;
    (arc
          ..innerRadius = (arc, [args]) {
            actual = {"that": arc, "args": args};
            return double.nan;
          })
        .centroid(expected["args"] as List<Object?>);
    expect(actual, expected);
  });

  test(
      "Arc.withDefaults().outerRadius(f).centroid(…) propagates the context and arguments to the specified function f",
      () {
    final arc = Arc.withDefaults();
    final expected = {
      "that": arc,
      "args": [
        {
          "innerRadius": 42,
          "outerRadius": 43,
          "cornerRadius": 44,
          "startAngle": 45,
          "endAngle": 46,
          "padAngle": 47,
          "padRadius": 48
        }
      ]
    };
    late Map actual;
    (arc
          ..outerRadius = (arc, [args]) {
            actual = {"that": arc, "args": args};
            return double.nan;
          })
        .centroid(expected["args"] as List<Object?>);
    expect(actual, expected);
  });

  test(
      "Arc.withDefaults().startAngle(f).centroid(…) propagates the context and arguments to the specified function f",
      () {
    final arc = Arc.withDefaults();
    final expected = {
      "that": arc,
      "args": [
        {
          "innerRadius": 42,
          "outerRadius": 43,
          "cornerRadius": 44,
          "startAngle": 45,
          "endAngle": 46,
          "padAngle": 47,
          "padRadius": 48
        }
      ]
    };
    late Map actual;
    (arc
          ..startAngle = (arc, [args]) {
            actual = {"that": arc, "args": args};
            return double.nan;
          })
        .centroid(expected["args"] as List<Object?>);
    expect(actual, expected);
  });

  test(
      "Arc.withDefaults().endAngle(f).centroid(…) propagates the context and arguments to the specified function f",
      () {
    final arc = Arc.withDefaults();
    final expected = {
      "that": arc,
      "args": [
        {
          "innerRadius": 42,
          "outerRadius": 43,
          "cornerRadius": 44,
          "startAngle": 45,
          "endAngle": 46,
          "padAngle": 47,
          "padRadius": 48
        }
      ]
    };
    late Map actual;
    (arc
          ..endAngle = (arc, [args]) {
            actual = {"that": arc, "args": args};
            return double.nan;
          })
        .centroid(expected["args"] as List<Object?>);
    expect(actual, expected);
  });

  test("Arc.withDefaults().innerRadius(0).outerRadius(0) renders a point", () {
    final a = Arc.withDefaults()
      ..constInnerRadius(0)
      ..constOuterRadius(0);
    expect(
        (a
          ..constStartAngle(0)
          ..constEndAngle(2 * pi))(),
        EqualsPath("M0,0Z"));
    expect(
        (a
          ..constStartAngle(0)
          ..constEndAngle(0))(),
        EqualsPath("M0,0Z"));
  });

  test("a negative angle span proceeds anticlockwise", () {
    final a = Arc.withDefaults()
      ..constInnerRadius(0)
      ..constOuterRadius(100);
    expect(
        (a
          ..constStartAngle(0)
          ..constEndAngle(-pi / 2))(),
        EqualsPath("M0,-100A100,100,0,0,0,-100,0L0,0Z"));
  });

  test(
      "Arc.withDefaults().innerRadius(0).outerRadius(r).startAngle(θ₀).endAngle(θ₁) renders a clockwise circle if r > 0 and θ₁ - θ₀ ≥ τ",
      () {
    final a = Arc.withDefaults()
      ..constInnerRadius(0)
      ..constOuterRadius(100);
    expect(
        (a
          ..constStartAngle(0)
          ..constEndAngle(2 * pi))(),
        EqualsPath("M0,-100A100,100,0,1,1,0,100A100,100,0,1,1,0,-100Z"));
    expect(
        (a
          ..constStartAngle(0)
          ..constEndAngle(3 * pi))(),
        EqualsPath("M0,-100A100,100,0,1,1,0,100A100,100,0,1,1,0,-100Z"));
    expect(
        (a
          ..constStartAngle(-2 * pi)
          ..constEndAngle(0))(),
        EqualsPath("M0,-100A100,100,0,1,1,0,100A100,100,0,1,1,0,-100Z"));
    expect(
        (a
          ..constStartAngle(-pi)
          ..constEndAngle(pi))(),
        EqualsPath("M0,100A100,100,0,1,1,0,-100A100,100,0,1,1,0,100Z"));
    expect(
        (a
          ..constStartAngle(-3 * pi)
          ..constEndAngle(0))(),
        EqualsPath("M0,100A100,100,0,1,1,0,-100A100,100,0,1,1,0,100Z"));
  });

  test(
      "Arc.withDefaults().innerRadius(0).outerRadius(r).startAngle(θ₀).endAngle(θ₁) renders an anticlockwise circle if r > 0 and θ₀ - θ₁ ≥ τ",
      () {
    final a = Arc.withDefaults()
      ..constInnerRadius(0)
      ..constOuterRadius(100);
    expect(
        (a
          ..constStartAngle(0)
          ..constEndAngle(-2 * pi))(),
        EqualsPath("M0,-100A100,100,0,1,0,0,100A100,100,0,1,0,0,-100Z"));
    expect(
        (a
          ..constStartAngle(0)
          ..constEndAngle(-3 * pi))(),
        EqualsPath("M0,-100A100,100,0,1,0,0,100A100,100,0,1,0,0,-100Z"));
    expect(
        (a
          ..constStartAngle(2 * pi)
          ..constEndAngle(0))(),
        EqualsPath("M0,-100A100,100,0,1,0,0,100A100,100,0,1,0,0,-100Z"));
    expect(
        (a
          ..constStartAngle(pi)
          ..constEndAngle(-pi))(),
        EqualsPath("M0,100A100,100,0,1,0,0,-100A100,100,0,1,0,0,100Z"));
    expect(
        (a
          ..constStartAngle(3 * pi)
          ..constEndAngle(0))(),
        EqualsPath("M0,100A100,100,0,1,0,0,-100A100,100,0,1,0,0,100Z"));
  });

  // Note: The outer ring starts and ends at θ₀, but the inner ring starts and ends at θ₁.
  // Note: The outer ring is clockwise, but the inner ring is anticlockwise.
  test(
      "Arc.withDefaults().innerRadius(r₀).outerRadius(r₁).startAngle(θ₀).endAngle(θ₁) renders a clockwise annulus if r₀ > 0, r₁ > 0 and θ₀ - θ₁ ≥ τ",
      () {
    final a = Arc.withDefaults()
      ..constInnerRadius(50)
      ..constOuterRadius(100);
    expect(
        (a
          ..constStartAngle(0)
          ..constEndAngle(2 * pi))(),
        EqualsPath(
            "M0,-100A100,100,0,1,1,0,100A100,100,0,1,1,0,-100M0,-50A50,50,0,1,0,0,50A50,50,0,1,0,0,-50Z"));
    expect(
        (a
          ..constStartAngle(0)
          ..constEndAngle(3 * pi))(),
        EqualsPath(
            "M0,-100A100,100,0,1,1,0,100A100,100,0,1,1,0,-100M0,50A50,50,0,1,0,0,-50A50,50,0,1,0,0,50Z"));
    expect(
        (a
          ..constStartAngle(-2 * pi)
          ..constEndAngle(0))(),
        EqualsPath(
            "M0,-100A100,100,0,1,1,0,100A100,100,0,1,1,0,-100M0,-50A50,50,0,1,0,0,50A50,50,0,1,0,0,-50Z"));
    expect(
        (a
          ..constStartAngle(-pi)
          ..constEndAngle(pi))(),
        EqualsPath(
            "M0,100A100,100,0,1,1,0,-100A100,100,0,1,1,0,100M0,50A50,50,0,1,0,0,-50A50,50,0,1,0,0,50Z"));
    expect(
        (a
          ..constStartAngle(-3 * pi)
          ..constEndAngle(0))(),
        EqualsPath(
            "M0,100A100,100,0,1,1,0,-100A100,100,0,1,1,0,100M0,-50A50,50,0,1,0,0,50A50,50,0,1,0,0,-50Z"));
  });

  // Note: The outer ring starts and ends at θ₀, but the inner ring starts and ends at θ₁.
  // Note: The outer ring is anticlockwise, but the inner ring is clockwise.
  test(
      "Arc.withDefaults().innerRadius(r₀).outerRadius(r₁).startAngle(θ₀).endAngle(θ₁) renders an anticlockwise annulus if r₀ > 0, r₁ > 0 and θ₁ - θ₀ ≥ τ",
      () {
    final a = Arc.withDefaults()
      ..constInnerRadius(50)
      ..constOuterRadius(100);
    expect(
        (a
          ..constStartAngle(0)
          ..constEndAngle(-2 * pi))(),
        EqualsPath(
            "M0,-100A100,100,0,1,0,0,100A100,100,0,1,0,0,-100M0,-50A50,50,0,1,1,0,50A50,50,0,1,1,0,-50Z"));
    expect(
        (a
          ..constStartAngle(0)
          ..constEndAngle(-3 * pi))(),
        EqualsPath(
            "M0,-100A100,100,0,1,0,0,100A100,100,0,1,0,0,-100M0,50A50,50,0,1,1,0,-50A50,50,0,1,1,0,50Z"));
    expect(
        (a
          ..constStartAngle(2 * pi)
          ..constEndAngle(0))(),
        EqualsPath(
            "M0,-100A100,100,0,1,0,0,100A100,100,0,1,0,0,-100M0,-50A50,50,0,1,1,0,50A50,50,0,1,1,0,-50Z"));
    expect(
        (a
          ..constStartAngle(pi)
          ..constEndAngle(-pi))(),
        EqualsPath(
            "M0,100A100,100,0,1,0,0,-100A100,100,0,1,0,0,100M0,50A50,50,0,1,1,0,-50A50,50,0,1,1,0,50Z"));
    expect(
        (a
          ..constStartAngle(3 * pi)
          ..constEndAngle(0))(),
        EqualsPath(
            "M0,100A100,100,0,1,0,0,-100A100,100,0,1,0,0,100M0,-50A50,50,0,1,1,0,50A50,50,0,1,1,0,-50Z"));
  });

  test(
      "Arc.withDefaults().innerRadius(0).outerRadius(r).startAngle(θ₀).endAngle(θ₁) renders a small clockwise sector if r > 0 and π > θ₁ - θ₀ ≥ 0",
      () {
    final a = Arc.withDefaults()
      ..constInnerRadius(0)
      ..constOuterRadius(100);
    expect(
        (a
          ..constStartAngle(0)
          ..constEndAngle(pi / 2))(),
        EqualsPath("M0,-100A100,100,0,0,1,100,0L0,0Z"));
    expect(
        (a
          ..constStartAngle(2 * pi)
          ..constEndAngle(5 * pi / 2))(),
        EqualsPath("M0,-100A100,100,0,0,1,100,0L0,0Z"));
    expect(
        (a
          ..constStartAngle(-pi)
          ..constEndAngle(-pi / 2))(),
        EqualsPath("M0,100A100,100,0,0,1,-100,0L0,0Z"));
  });

  test(
      "Arc.withDefaults().innerRadius(0).outerRadius(r).startAngle(θ₀).endAngle(θ₁) renders a small anticlockwise sector if r > 0 and π > θ₀ - θ₁ ≥ 0",
      () {
    final a = Arc.withDefaults()
      ..constInnerRadius(0)
      ..constOuterRadius(100);
    expect(
        (a
          ..constStartAngle(0)
          ..constEndAngle(-pi / 2))(),
        EqualsPath("M0,-100A100,100,0,0,0,-100,0L0,0Z"));
    expect(
        (a
          ..constStartAngle(-2 * pi)
          ..constEndAngle(-5 * pi / 2))(),
        EqualsPath("M0,-100A100,100,0,0,0,-100,0L0,0Z"));
    expect(
        (a
          ..constStartAngle(pi)
          ..constEndAngle(pi / 2))(),
        EqualsPath("M0,100A100,100,0,0,0,100,0L0,0Z"));
  });

  test(
      "Arc.withDefaults().innerRadius(0).outerRadius(r).startAngle(θ₀).endAngle(θ₁) renders a large clockwise sector if r > 0 and τ > θ₁ - θ₀ ≥ π",
      () {
    final a = Arc.withDefaults()
      ..constInnerRadius(0)
      ..constOuterRadius(100);
    expect(
        (a
          ..constStartAngle(0)
          ..constEndAngle(3 * pi / 2))(),
        EqualsPath("M0,-100A100,100,0,1,1,-100,0L0,0Z"));
    expect(
        (a
          ..constStartAngle(2 * pi)
          ..constEndAngle(7 * pi / 2))(),
        EqualsPath("M0,-100A100,100,0,1,1,-100,0L0,0Z"));
    expect(
        (a
          ..constStartAngle(-pi)
          ..constEndAngle(pi / 2))(),
        EqualsPath("M0,100A100,100,0,1,1,100,0L0,0Z"));
  });

  test(
      "Arc.withDefaults().innerRadius(0).outerRadius(r).startAngle(θ₀).endAngle(θ₁) renders a large anticlockwise sector if r > 0 and τ > θ₀ - θ₁ ≥ π",
      () {
    final a = Arc.withDefaults()
      ..constInnerRadius(0)
      ..constOuterRadius(100);
    expect(
        (a
          ..constStartAngle(0)
          ..constEndAngle(-3 * pi / 2))(),
        EqualsPath("M0,-100A100,100,0,1,0,100,0L0,0Z"));
    expect(
        (a
          ..constStartAngle(-2 * pi)
          ..constEndAngle(-7 * pi / 2))(),
        EqualsPath("M0,-100A100,100,0,1,0,100,0L0,0Z"));
    expect(
        (a
          ..constStartAngle(pi)
          ..constEndAngle(-pi / 2))(),
        EqualsPath("M0,100A100,100,0,1,0,-100,0L0,0Z"));
  });

  // Note: The outer ring is clockwise, but the inner ring is anticlockwise.
  test(
      "Arc.withDefaults().innerRadius(r₀).outerRadius(r₁).startAngle(θ₀).endAngle(θ₁) renders a small clockwise annular sector if r₀ > 0, r₁ > 0 and π > θ₁ - θ₀ ≥ 0",
      () {
    final a = Arc.withDefaults()
      ..constInnerRadius(50)
      ..constOuterRadius(100);
    expect(
        (a
          ..constStartAngle(0)
          ..constEndAngle(pi / 2))(),
        EqualsPath("M0,-100A100,100,0,0,1,100,0L50,0A50,50,0,0,0,0,-50Z"));
    expect(
        (a
          ..constStartAngle(2 * pi)
          ..constEndAngle(5 * pi / 2))(),
        EqualsPath("M0,-100A100,100,0,0,1,100,0L50,0A50,50,0,0,0,0,-50Z"));
    expect(
        (a
          ..constStartAngle(-pi)
          ..constEndAngle(-pi / 2))(),
        EqualsPath("M0,100A100,100,0,0,1,-100,0L-50,0A50,50,0,0,0,0,50Z"));
  });

  // Note: The outer ring is anticlockwise, but the inner ring is clockwise.
  test(
      "Arc.withDefaults().innerRadius(r₀).outerRadius(r₁).startAngle(θ₀).endAngle(θ₁) renders a small anticlockwise annular sector if r₀ > 0, r₁ > 0 and π > θ₀ - θ₁ ≥ 0",
      () {
    final a = Arc.withDefaults()
      ..constInnerRadius(50)
      ..constOuterRadius(100);
    expect(
        (a
          ..constStartAngle(0)
          ..constEndAngle(-pi / 2))(),
        EqualsPath("M0,-100A100,100,0,0,0,-100,0L-50,0A50,50,0,0,1,0,-50Z"));
    expect(
        (a
          ..constStartAngle(-2 * pi)
          ..constEndAngle(-5 * pi / 2))(),
        EqualsPath("M0,-100A100,100,0,0,0,-100,0L-50,0A50,50,0,0,1,0,-50Z"));
    expect(
        (a
          ..constStartAngle(pi)
          ..constEndAngle(pi / 2))(),
        EqualsPath("M0,100A100,100,0,0,0,100,0L50,0A50,50,0,0,1,0,50Z"));
  });

  // Note: The outer ring is clockwise, but the inner ring is anticlockwise.
  test(
      "Arc.withDefaults().innerRadius(r₀).outerRadius(r₁).startAngle(θ₀).endAngle(θ₁) renders a large clockwise annular sector if r₀ > 0, r₁ > 0 and τ > θ₁ - θ₀ ≥ π",
      () {
    final a = Arc.withDefaults()
      ..constInnerRadius(50)
      ..constOuterRadius(100);
    expect(
        (a
          ..constStartAngle(0)
          ..constEndAngle(3 * pi / 2))(),
        EqualsPath("M0,-100A100,100,0,1,1,-100,0L-50,0A50,50,0,1,0,0,-50Z"));
    expect(
        (a
          ..constStartAngle(2 * pi)
          ..constEndAngle(7 * pi / 2))(),
        EqualsPath("M0,-100A100,100,0,1,1,-100,0L-50,0A50,50,0,1,0,0,-50Z"));
    expect(
        (a
          ..constStartAngle(-pi)
          ..constEndAngle(pi / 2))(),
        EqualsPath("M0,100A100,100,0,1,1,100,0L50,0A50,50,0,1,0,0,50Z"));
  });

  // Note: The outer ring is anticlockwise, but the inner ring is clockwise.
  test(
      "Arc.withDefaults().innerRadius(r₀).outerRadius(r₁).startAngle(θ₀).endAngle(θ₁) renders a large anticlockwise annular sector if r₀ > 0, r₁ > 0 and τ > θ₀ - θ₁ ≥ π",
      () {
    final a = Arc.withDefaults()
      ..constInnerRadius(50)
      ..constOuterRadius(100);
    expect(
        (a
          ..constStartAngle(0)
          ..constEndAngle(-3 * pi / 2))(),
        EqualsPath("M0,-100A100,100,0,1,0,100,0L50,0A50,50,0,1,1,0,-50Z"));
    expect(
        (a
          ..constStartAngle(-2 * pi)
          ..constEndAngle(-7 * pi / 2))(),
        EqualsPath("M0,-100A100,100,0,1,0,100,0L50,0A50,50,0,1,1,0,-50Z"));
    expect(
        (a
          ..constStartAngle(pi)
          ..constEndAngle(-pi / 2))(),
        EqualsPath("M0,100A100,100,0,1,0,-100,0L-50,0A50,50,0,1,1,0,50Z"));
  });

  test(
      "Arc.withDefaults().innerRadius(0).outerRadius(0).cornerRadius(r) renders a point",
      () {
    final a = Arc.withDefaults()
      ..constInnerRadius(0)
      ..constOuterRadius(0)
      ..constCornerRadius(5);
    expect(
        (a
          ..constStartAngle(0)
          ..constEndAngle(2 * pi))(),
        EqualsPath("M0,0Z"));
    expect(
        (a
          ..constStartAngle(0)
          ..constEndAngle(0))(),
        EqualsPath("M0,0Z"));
  });

  test(
      "Arc.withDefaults().innerRadius(0).outerRadius(r).startAngle(θ₀).endAngle(θ₁).cornerRadius(rᵧ) renders a clockwise circle if r > 0 and θ₁ - θ₀ ≥ τ",
      () {
    final a = Arc.withDefaults()
      ..constInnerRadius(0)
      ..constOuterRadius(100)
      ..constCornerRadius(5);
    expect(
        (a
          ..constStartAngle(0)
          ..constEndAngle(2 * pi))(),
        EqualsPath("M0,-100A100,100,0,1,1,0,100A100,100,0,1,1,0,-100Z"));
    expect(
        (a
          ..constStartAngle(0)
          ..constEndAngle(3 * pi))(),
        EqualsPath("M0,-100A100,100,0,1,1,0,100A100,100,0,1,1,0,-100Z"));
    expect(
        (a
          ..constStartAngle(-2 * pi)
          ..constEndAngle(0))(),
        EqualsPath("M0,-100A100,100,0,1,1,0,100A100,100,0,1,1,0,-100Z"));
    expect(
        (a
          ..constStartAngle(-pi)
          ..constEndAngle(pi))(),
        EqualsPath("M0,100A100,100,0,1,1,0,-100A100,100,0,1,1,0,100Z"));
    expect(
        (a
          ..constStartAngle(-3 * pi)
          ..constEndAngle(0))(),
        EqualsPath("M0,100A100,100,0,1,1,0,-100A100,100,0,1,1,0,100Z"));
  });

  test(
      "Arc.withDefaults().innerRadius(0).outerRadius(r).startAngle(θ₀).endAngle(θ₁).cornerRadius(rᵧ) renders an anticlockwise circle if r > 0 and θ₀ - θ₁ ≥ τ",
      () {
    final a = Arc.withDefaults()
      ..constInnerRadius(0)
      ..constOuterRadius(100)
      ..constCornerRadius(5);
    expect(
        (a
          ..constStartAngle(0)
          ..constEndAngle(-2 * pi))(),
        EqualsPath("M0,-100A100,100,0,1,0,0,100A100,100,0,1,0,0,-100Z"));
    expect(
        (a
          ..constStartAngle(0)
          ..constEndAngle(-3 * pi))(),
        EqualsPath("M0,-100A100,100,0,1,0,0,100A100,100,0,1,0,0,-100Z"));
    expect(
        (a
          ..constStartAngle(2 * pi)
          ..constEndAngle(0))(),
        EqualsPath("M0,-100A100,100,0,1,0,0,100A100,100,0,1,0,0,-100Z"));
    expect(
        (a
          ..constStartAngle(pi)
          ..constEndAngle(-pi))(),
        EqualsPath("M0,100A100,100,0,1,0,0,-100A100,100,0,1,0,0,100Z"));
    expect(
        (a
          ..constStartAngle(3 * pi)
          ..constEndAngle(0))(),
        EqualsPath("M0,100A100,100,0,1,0,0,-100A100,100,0,1,0,0,100Z"));
  });

  // Note: The outer ring starts and ends at θ₀, but the inner ring starts and ends at θ₁.
  // Note: The outer ring is clockwise, but the inner ring is anticlockwise.
  test(
      "Arc.withDefaults().innerRadius(r₀).outerRadius(r₁).startAngle(θ₀).endAngle(θ₁).cornerRadius(rᵧ) renders a clockwise annulus if r₀ > 0, r₁ > 0 and θ₀ - θ₁ ≥ τ",
      () {
    final a = Arc.withDefaults()
      ..constInnerRadius(50)
      ..constOuterRadius(100)
      ..constCornerRadius(5);
    expect(
        (a
          ..constStartAngle(0)
          ..constEndAngle(2 * pi))(),
        EqualsPath(
            "M0,-100A100,100,0,1,1,0,100A100,100,0,1,1,0,-100M0,-50A50,50,0,1,0,0,50A50,50,0,1,0,0,-50Z"));
    expect(
        (a
          ..constStartAngle(0)
          ..constEndAngle(3 * pi))(),
        EqualsPath(
            "M0,-100A100,100,0,1,1,0,100A100,100,0,1,1,0,-100M0,50A50,50,0,1,0,0,-50A50,50,0,1,0,0,50Z"));
    expect(
        (a
          ..constStartAngle(-2 * pi)
          ..constEndAngle(0))(),
        EqualsPath(
            "M0,-100A100,100,0,1,1,0,100A100,100,0,1,1,0,-100M0,-50A50,50,0,1,0,0,50A50,50,0,1,0,0,-50Z"));
    expect(
        (a
          ..constStartAngle(-pi)
          ..constEndAngle(pi))(),
        EqualsPath(
            "M0,100A100,100,0,1,1,0,-100A100,100,0,1,1,0,100M0,50A50,50,0,1,0,0,-50A50,50,0,1,0,0,50Z"));
    expect(
        (a
          ..constStartAngle(-3 * pi)
          ..constEndAngle(0))(),
        EqualsPath(
            "M0,100A100,100,0,1,1,0,-100A100,100,0,1,1,0,100M0,-50A50,50,0,1,0,0,50A50,50,0,1,0,0,-50Z"));
  });

  // Note: The outer ring starts and ends at θ₀, but the inner ring starts and ends at θ₁.
  // Note: The outer ring is anticlockwise, but the inner ring is clockwise.
  test(
      "Arc.withDefaults().innerRadius(r₀).outerRadius(r₁).startAngle(θ₀).endAngle(θ₁).cornerRadius(rᵧ) renders an anticlockwise annulus if r₀ > 0, r₁ > 0 and θ₁ - θ₀ ≥ τ",
      () {
    final a = Arc.withDefaults()
      ..constInnerRadius(50)
      ..constOuterRadius(100)
      ..constCornerRadius(5);
    expect(
        (a
          ..constStartAngle(0)
          ..constEndAngle(-2 * pi))(),
        EqualsPath(
            "M0,-100A100,100,0,1,0,0,100A100,100,0,1,0,0,-100M0,-50A50,50,0,1,1,0,50A50,50,0,1,1,0,-50Z"));
    expect(
        (a
          ..constStartAngle(0)
          ..constEndAngle(-3 * pi))(),
        EqualsPath(
            "M0,-100A100,100,0,1,0,0,100A100,100,0,1,0,0,-100M0,50A50,50,0,1,1,0,-50A50,50,0,1,1,0,50Z"));
    expect(
        (a
          ..constStartAngle(2 * pi)
          ..constEndAngle(0))(),
        EqualsPath(
            "M0,-100A100,100,0,1,0,0,100A100,100,0,1,0,0,-100M0,-50A50,50,0,1,1,0,50A50,50,0,1,1,0,-50Z"));
    expect(
        (a
          ..constStartAngle(pi)
          ..constEndAngle(-pi))(),
        EqualsPath(
            "M0,100A100,100,0,1,0,0,-100A100,100,0,1,0,0,100M0,50A50,50,0,1,1,0,-50A50,50,0,1,1,0,50Z"));
    expect(
        (a
          ..constStartAngle(3 * pi)
          ..constEndAngle(0))(),
        EqualsPath(
            "M0,100A100,100,0,1,0,0,-100A100,100,0,1,0,0,100M0,-50A50,50,0,1,1,0,50A50,50,0,1,1,0,-50Z"));
  });

  test(
      "Arc.withDefaults().innerRadius(0).outerRadius(r).startAngle(θ₀).endAngle(θ₁).cornerRadius(rᵧ) renders a small clockwise sector if r > 0 and π > θ₁ - θ₀ ≥ 0",
      () {
    final a = Arc.withDefaults()
      ..constInnerRadius(0)
      ..constOuterRadius(100)
      ..constCornerRadius(5);
    expect(
        (a
          ..constStartAngle(0)
          ..constEndAngle(pi / 2))(),
        EqualsPath(
            "M0,-94.868330A5,5,0,0,1,5.263158,-99.861400A100,100,0,0,1,99.861400,-5.263158A5,5,0,0,1,94.868330,0L0,0Z"));
    expect(
        (a
          ..constStartAngle(2 * pi)
          ..constEndAngle(5 * pi / 2))(),
        EqualsPath(
            "M0,-94.868330A5,5,0,0,1,5.263158,-99.861400A100,100,0,0,1,99.861400,-5.263158A5,5,0,0,1,94.868330,0L0,0Z"));
    expect(
        (a
          ..constStartAngle(-pi)
          ..constEndAngle(-pi / 2))(),
        EqualsPath(
            "M0,94.868330A5,5,0,0,1,-5.263158,99.861400A100,100,0,0,1,-99.861400,5.263158A5,5,0,0,1,-94.868330,0L0,0Z"));
  });

  test(
      "Arc.withDefaults().innerRadius(0).outerRadius(r).startAngle(θ₀).endAngle(θ₁).cornerRadius(rᵧ) renders a small anticlockwise sector if r > 0 and π > θ₀ - θ₁ ≥ 0",
      () {
    final a = Arc.withDefaults()
      ..constInnerRadius(0)
      ..constOuterRadius(100)
      ..constCornerRadius(5);
    expect(
        (a
          ..constStartAngle(0)
          ..constEndAngle(-pi / 2))(),
        EqualsPath(
            "M0,-94.868330A5,5,0,0,0,-5.263158,-99.861400A100,100,0,0,0,-99.861400,-5.263158A5,5,0,0,0,-94.868330,0L0,0Z"));
    expect(
        (a
          ..constStartAngle(-2 * pi)
          ..constEndAngle(-5 * pi / 2))(),
        EqualsPath(
            "M0,-94.868330A5,5,0,0,0,-5.263158,-99.861400A100,100,0,0,0,-99.861400,-5.263158A5,5,0,0,0,-94.868330,0L0,0Z"));
    expect(
        (a
          ..constStartAngle(pi)
          ..constEndAngle(pi / 2))(),
        EqualsPath(
            "M0,94.868330A5,5,0,0,0,5.263158,99.861400A100,100,0,0,0,99.861400,5.263158A5,5,0,0,0,94.868330,0L0,0Z"));
  });

  test(
      "Arc.withDefaults().innerRadius(0).outerRadius(r).startAngle(θ₀).endAngle(θ₁).cornerRadius(rᵧ) renders a large clockwise sector if r > 0 and τ > θ₁ - θ₀ ≥ π",
      () {
    final a = Arc.withDefaults()
      ..constInnerRadius(0)
      ..constOuterRadius(100)
      ..constCornerRadius(5);
    expect(
        (a
          ..constStartAngle(0)
          ..constEndAngle(3 * pi / 2))(),
        EqualsPath(
            "M0,-94.868330A5,5,0,0,1,5.263158,-99.861400A100,100,0,1,1,-99.861400,5.263158A5,5,0,0,1,-94.868330,0L0,0Z"));
    expect(
        (a
          ..constStartAngle(2 * pi)
          ..constEndAngle(7 * pi / 2))(),
        EqualsPath(
            "M0,-94.868330A5,5,0,0,1,5.263158,-99.861400A100,100,0,1,1,-99.861400,5.263158A5,5,0,0,1,-94.868330,0L0,0Z"));
    expect(
        (a
          ..constStartAngle(-pi)
          ..constEndAngle(pi / 2))(),
        EqualsPath(
            "M0,94.868330A5,5,0,0,1,-5.263158,99.861400A100,100,0,1,1,99.861400,-5.263158A5,5,0,0,1,94.868330,0L0,0Z"));
  });

  test(
      "Arc.withDefaults().innerRadius(0).outerRadius(r).startAngle(θ₀).endAngle(θ₁).cornerRadius(rᵧ) renders a large anticlockwise sector if r > 0 and τ > θ₀ - θ₁ ≥ π",
      () {
    final a = Arc.withDefaults()
      ..constInnerRadius(0)
      ..constOuterRadius(100)
      ..constCornerRadius(5);
    expect(
        (a
          ..constStartAngle(0)
          ..constEndAngle(-3 * pi / 2))(),
        EqualsPath(
            "M0,-94.868330A5,5,0,0,0,-5.263158,-99.861400A100,100,0,1,0,99.861400,5.263158A5,5,0,0,0,94.868330,0L0,0Z"));
    expect(
        (a
          ..constStartAngle(-2 * pi)
          ..constEndAngle(-7 * pi / 2))(),
        EqualsPath(
            "M0,-94.868330A5,5,0,0,0,-5.263158,-99.861400A100,100,0,1,0,99.861400,5.263158A5,5,0,0,0,94.868330,0L0,0Z"));
    expect(
        (a
          ..constStartAngle(pi)
          ..constEndAngle(-pi / 2))(),
        EqualsPath(
            "M0,94.868330A5,5,0,0,0,5.263158,99.861400A100,100,0,1,0,-99.861400,-5.263158A5,5,0,0,0,-94.868330,0L0,0Z"));
  });

  // Note: The outer ring is clockwise, but the inner ring is anticlockwise.
  test(
      "Arc.withDefaults().innerRadius(r₀).outerRadius(r₁).startAngle(θ₀).endAngle(θ₁).cornerRadius(rᵧ) renders a small clockwise annular sector if r₀ > 0, r₁ > 0 and π > θ₁ - θ₀ ≥ 0",
      () {
    final a = Arc.withDefaults()
      ..constInnerRadius(50)
      ..constOuterRadius(100)
      ..constCornerRadius(5);
    expect(
        (a
          ..constStartAngle(0)
          ..constEndAngle(pi / 2))(),
        EqualsPath(
            "M0,-94.868330A5,5,0,0,1,5.263158,-99.861400A100,100,0,0,1,99.861400,-5.263158A5,5,0,0,1,94.868330,0L54.772256,0A5,5,0,0,1,49.792960,-4.545455A50,50,0,0,0,4.545455,-49.792960A5,5,0,0,1,0,-54.772256Z"));
    expect(
        (a
          ..constStartAngle(2 * pi)
          ..constEndAngle(5 * pi / 2))(),
        EqualsPath(
            "M0,-94.868330A5,5,0,0,1,5.263158,-99.861400A100,100,0,0,1,99.861400,-5.263158A5,5,0,0,1,94.868330,0L54.772256,0A5,5,0,0,1,49.792960,-4.545455A50,50,0,0,0,4.545455,-49.792960A5,5,0,0,1,0,-54.772256Z"));
    expect(
        (a
          ..constStartAngle(-pi)
          ..constEndAngle(-pi / 2))(),
        EqualsPath(
            "M0,94.868330A5,5,0,0,1,-5.263158,99.861400A100,100,0,0,1,-99.861400,5.263158A5,5,0,0,1,-94.868330,0L-54.772256,0A5,5,0,0,1,-49.792960,4.545455A50,50,0,0,0,-4.545455,49.792960A5,5,0,0,1,0,54.772256Z"));
  });

  // Note: The outer ring is anticlockwise, but the inner ring is clockwise.
  test(
      "Arc.withDefaults().innerRadius(r₀).outerRadius(r₁).startAngle(θ₀).endAngle(θ₁).cornerRadius(rᵧ) renders a small anticlockwise annular sector if r₀ > 0, r₁ > 0 and π > θ₀ - θ₁ ≥ 0",
      () {
    final a = Arc.withDefaults()
      ..constInnerRadius(50)
      ..constOuterRadius(100)
      ..constCornerRadius(5);
    expect(
        (a
          ..constStartAngle(0)
          ..constEndAngle(-pi / 2))(),
        EqualsPath(
            "M0,-94.868330A5,5,0,0,0,-5.263158,-99.861400A100,100,0,0,0,-99.861400,-5.263158A5,5,0,0,0,-94.868330,0L-54.772256,0A5,5,0,0,0,-49.792960,-4.545455A50,50,0,0,1,-4.545455,-49.792960A5,5,0,0,0,0,-54.772256Z"));
    expect(
        (a
          ..constStartAngle(-2 * pi)
          ..constEndAngle(-5 * pi / 2))(),
        EqualsPath(
            "M0,-94.868330A5,5,0,0,0,-5.263158,-99.861400A100,100,0,0,0,-99.861400,-5.263158A5,5,0,0,0,-94.868330,0L-54.772256,0A5,5,0,0,0,-49.792960,-4.545455A50,50,0,0,1,-4.545455,-49.792960A5,5,0,0,0,0,-54.772256Z"));
    expect(
        (a
          ..constStartAngle(pi)
          ..constEndAngle(pi / 2))(),
        EqualsPath(
            "M0,94.868330A5,5,0,0,0,5.263158,99.861400A100,100,0,0,0,99.861400,5.263158A5,5,0,0,0,94.868330,0L54.772256,0A5,5,0,0,0,49.792960,4.545455A50,50,0,0,1,4.545455,49.792960A5,5,0,0,0,0,54.772256Z"));
  });

  // Note: The outer ring is clockwise, but the inner ring is anticlockwise.
  test(
      "Arc.withDefaults().innerRadius(r₀).outerRadius(r₁).startAngle(θ₀).endAngle(θ₁).cornerRadius(rᵧ) renders a large clockwise annular sector if r₀ > 0, r₁ > 0 and τ > θ₁ - θ₀ ≥ π",
      () {
    final a = Arc.withDefaults()
      ..constInnerRadius(50)
      ..constOuterRadius(100)
      ..constCornerRadius(5);
    expect(
        (a
          ..constStartAngle(0)
          ..constEndAngle(3 * pi / 2))(),
        EqualsPath(
            "M0,-94.868330A5,5,0,0,1,5.263158,-99.861400A100,100,0,1,1,-99.861400,5.263158A5,5,0,0,1,-94.868330,0L-54.772256,0A5,5,0,0,1,-49.792960,4.545455A50,50,0,1,0,4.545455,-49.792960A5,5,0,0,1,0,-54.772256Z"));
    expect(
        (a
          ..constStartAngle(2 * pi)
          ..constEndAngle(7 * pi / 2))(),
        EqualsPath(
            "M0,-94.868330A5,5,0,0,1,5.263158,-99.861400A100,100,0,1,1,-99.861400,5.263158A5,5,0,0,1,-94.868330,0L-54.772256,0A5,5,0,0,1,-49.792960,4.545455A50,50,0,1,0,4.545455,-49.792960A5,5,0,0,1,0,-54.772256Z"));
    expect(
        (a
          ..constStartAngle(-pi)
          ..constEndAngle(pi / 2))(),
        EqualsPath(
            "M0,94.868330A5,5,0,0,1,-5.263158,99.861400A100,100,0,1,1,99.861400,-5.263158A5,5,0,0,1,94.868330,0L54.772256,0A5,5,0,0,1,49.792960,-4.545455A50,50,0,1,0,-4.545455,49.792960A5,5,0,0,1,0,54.772256Z"));
  });

  // Note: The outer ring is anticlockwise, but the inner ring is clockwise.
  test(
      "Arc.withDefaults().innerRadius(r₀).outerRadius(r₁).startAngle(θ₀).endAngle(θ₁).cornerRadius(rᵧ) renders a large anticlockwise annular sector if r₀ > 0, r₁ > 0 and τ > θ₀ - θ₁ ≥ π",
      () {
    final a = Arc.withDefaults()
      ..constInnerRadius(50)
      ..constOuterRadius(100)
      ..constCornerRadius(5);
    expect(
        (a
          ..constStartAngle(0)
          ..constEndAngle(-3 * pi / 2))(),
        EqualsPath(
            "M0,-94.868330A5,5,0,0,0,-5.263158,-99.861400A100,100,0,1,0,99.861400,5.263158A5,5,0,0,0,94.868330,0L54.772256,0A5,5,0,0,0,49.792960,4.545455A50,50,0,1,1,-4.545455,-49.792960A5,5,0,0,0,0,-54.772256Z"));
    expect(
        (a
          ..constStartAngle(-2 * pi)
          ..constEndAngle(-7 * pi / 2))(),
        EqualsPath(
            "M0,-94.868330A5,5,0,0,0,-5.263158,-99.861400A100,100,0,1,0,99.861400,5.263158A5,5,0,0,0,94.868330,0L54.772256,0A5,5,0,0,0,49.792960,4.545455A50,50,0,1,1,-4.545455,-49.792960A5,5,0,0,0,0,-54.772256Z"));
    expect(
        (a
          ..constStartAngle(pi)
          ..constEndAngle(-pi / 2))(),
        EqualsPath(
            "M0,94.868330A5,5,0,0,0,5.263158,99.861400A100,100,0,1,0,-99.861400,-5.263158A5,5,0,0,0,-94.868330,0L-54.772256,0A5,5,0,0,0,-49.792960,-4.545455A50,50,0,1,1,4.545455,49.792960A5,5,0,0,0,0,54.772256Z"));
  });

  test(
      "Arc.withDefaults().innerRadius(r₀).outerRadius(r₁).cornerRadius(rᵧ) restricts rᵧ to |r₁ - r₀| / 2",
      () {
    final a = Arc.withDefaults()
      ..constCornerRadius(double.infinity)
      ..constStartAngle(0)
      ..constEndAngle(pi / 2);
    expect(
        (a
          ..constInnerRadius(90)
          ..constOuterRadius(100))(),
        EqualsPath(
            "M0,-94.868330A5,5,0,0,1,5.263158,-99.861400A100,100,0,0,1,99.861400,-5.263158A5,5,0,0,1,94.868330,0L94.868330,0A5,5,0,0,1,89.875260,-4.736842A90,90,0,0,0,4.736842,-89.875260A5,5,0,0,1,0,-94.868330Z"));
    expect(
        (a
          ..constInnerRadius(100)
          ..constOuterRadius(90))(),
        EqualsPath(
            "M0,-94.868330A5,5,0,0,1,5.263158,-99.861400A100,100,0,0,1,99.861400,-5.263158A5,5,0,0,1,94.868330,0L94.868330,0A5,5,0,0,1,89.875260,-4.736842A90,90,0,0,0,4.736842,-89.875260A5,5,0,0,1,0,-94.868330Z"));
  });

  test(
      "Arc.withDefaults().innerRadius(r₀).outerRadius(r₁).cornerRadius(rᵧ) merges adjacent corners when rᵧ is relatively large",
      () {
    final a = Arc.withDefaults()
      ..constCornerRadius(double.infinity)
      ..constStartAngle(0)
      ..constEndAngle(pi / 2);
    expect(
        (a
          ..constInnerRadius(10)
          ..constOuterRadius(100))(),
        EqualsPath(
            "M0,-41.421356A41.421356,41.421356,0,1,1,41.421356,0L24.142136,0A24.142136,24.142136,0,0,1,0,-24.142136Z"));
    expect(
        (a
          ..constInnerRadius(100)
          ..constOuterRadius(10))(),
        EqualsPath(
            "M0,-41.421356A41.421356,41.421356,0,1,1,41.421356,0L24.142136,0A24.142136,24.142136,0,0,1,0,-24.142136Z"));
  });

  test(
      "Arc.withDefaults().innerRadius(0).outerRadius(0).startAngle(0).endAngle(τ).padAngle(δ) does not pad a point",
      () {
    final a = Arc.withDefaults()
      ..constInnerRadius(0)
      ..constOuterRadius(0)
      ..constStartAngle(0)
      ..constEndAngle(2 * pi)
      ..constPadAngle(0.1);
    expect(a(), EqualsPath("M0,0Z"));
  });

  test(
      "Arc.withDefaults().innerRadius(0).outerRadius(r).startAngle(0).endAngle(τ).padAngle(δ) does not pad a circle",
      () {
    final a = Arc.withDefaults()
      ..constInnerRadius(0)
      ..constOuterRadius(100)
      ..constStartAngle(0)
      ..constEndAngle(2 * pi)
      ..constPadAngle(0.1);
    expect(
        a(), EqualsPath("M0,-100A100,100,0,1,1,0,100A100,100,0,1,1,0,-100Z"));
  });

  test(
      "Arc.withDefaults().innerRadius(r₀).outerRadius(r₁).startAngle(0).endAngle(τ).padAngle(δ) does not pad an annulus",
      () {
    final a = Arc.withDefaults()
      ..constInnerRadius(50)
      ..constOuterRadius(100)
      ..constStartAngle(0)
      ..constEndAngle(2 * pi)
      ..constPadAngle(0.1);
    expect(
        a(),
        EqualsPath(
            "M0,-100A100,100,0,1,1,0,100A100,100,0,1,1,0,-100M0,-50A50,50,0,1,0,0,50A50,50,0,1,0,0,-50Z"));
  });

  test(
      "Arc.withDefaults().innerRadius(0).outerRadius(r).startAngle(θ₀).endAngle(θ₁).padAngle(δ) pads the outside of a circular sector",
      () {
    final a = Arc.withDefaults()
      ..constInnerRadius(0)
      ..constOuterRadius(100)
      ..constStartAngle(0)
      ..constEndAngle(pi / 2)
      ..constPadAngle(0.1);
    expect(
        a(),
        EqualsPath(
            "M4.997917,-99.875026A100,100,0,0,1,99.875026,-4.997917L0,0Z"));
  });

  test(
      "Arc.withDefaults().innerRadius(r₀).outerRadius(r₁).startAngle(θ₀).endAngle(θ₁).padAngle(δ) pads an annular sector",
      () {
    final a = Arc.withDefaults()
      ..constInnerRadius(50)
      ..constOuterRadius(100)
      ..constStartAngle(0)
      ..constEndAngle(pi / 2)
      ..constPadAngle(0.1);
    expect(
        a(),
        EqualsPath(
            "M5.587841,-99.843758A100,100,0,0,1,99.843758,-5.587841L49.686779,-5.587841A50,50,0,0,0,5.587841,-49.686779Z"));
  });

  test(
      "Arc.withDefaults().innerRadius(r₀).outerRadius(r₁).startAngle(θ₀).endAngle(θ₁).padAngle(δ) may collapse the inside of an annular sector",
      () {
    final a = Arc.withDefaults()
      ..constInnerRadius(10)
      ..constOuterRadius(100)
      ..constStartAngle(0)
      ..constEndAngle(pi / 2)
      ..constPadAngle(0.2);
    expect(
        a(),
        EqualsPath(
            "M10.033134,-99.495408A100,100,0,0,1,99.495408,-10.033134L7.071068,-7.071068Z"));
  });

  test(
      "Arc.withDefaults().innerRadius(0).outerRadius(r).startAngle(θ₀).endAngle(θ₁).padAngle(δ).cornerRadius(rᵧ) rounds and pads a circular sector",
      () {
    final a = Arc.withDefaults()
      ..constInnerRadius(0)
      ..constOuterRadius(100)
      ..constStartAngle(0)
      ..constEndAngle(pi / 2)
      ..constPadAngle(0.1)
      ..constCornerRadius(10);
    expect(
        a(),
        EqualsPath(
            "M4.470273,-89.330939A10,10,0,0,1,16.064195,-98.701275A100,100,0,0,1,98.701275,-16.064195A10,10,0,0,1,89.330939,-4.470273L0,0Z"));
  });

  test(
      "Arc.withDefaults().innerRadius(r₀).outerRadius(r₁).startAngle(θ₀).endAngle(θ₁).padAngle(δ).cornerRadius(rᵧ) rounds and pads an annular sector",
      () {
    final a = Arc.withDefaults()
      ..constInnerRadius(50)
      ..constOuterRadius(100)
      ..constStartAngle(0)
      ..constEndAngle(pi / 2)
      ..constPadAngle(0.1)
      ..constCornerRadius(10);
    expect(
        a(),
        EqualsPath(
            "M5.587841,-88.639829A10,10,0,0,1,17.319823,-98.488698A100,100,0,0,1,98.488698,-17.319823A10,10,0,0,1,88.639829,-5.587841L57.939790,-5.587841A10,10,0,0,1,48.283158,-12.989867A50,50,0,0,0,12.989867,-48.283158A10,10,0,0,1,5.587841,-57.939790Z"));
  });

  test(
      "Arc.withDefaults().innerRadius(r₀).outerRadius(r₁).startAngle(θ₀).endAngle(θ₁).padAngle(δ).cornerRadius(rᵧ) rounds and pads a collapsed annular sector",
      () {
    final a = Arc.withDefaults()
      ..constInnerRadius(10)
      ..constOuterRadius(100)
      ..constStartAngle(0)
      ..constEndAngle(pi / 2)
      ..constPadAngle(0.2)
      ..constCornerRadius(10);
    expect(
        a(),
        EqualsPath(
            "M9.669396,-88.145811A10,10,0,0,1,21.849183,-97.583878A100,100,0,0,1,97.583878,-21.849183A10,10,0,0,1,88.145811,-9.669396L7.071068,-7.071068Z"));
  });

  test("Arc.withDefaults() handles a very small arc with rounded corners", () {
    final a = Arc.withDefaults()
      ..constInnerRadius(15)
      ..constOuterRadius(24)
      ..constPadAngle(0)
      ..constStartAngle(1.2 - 1e-8)
      ..constEndAngle(1.2)
      ..constCornerRadius(4);
    expect(a(), EqualsPath("M22.369,-8.697L13.981,-5.435Z"));
  });
}
