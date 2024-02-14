import 'package:d4_path/d4_path.dart';
import 'package:d4_polygon/d4_polygon.dart';

class PolygonContext extends Path {
  List<List<num>>? _points;

  num area() {
    return polygonArea(_points!).abs();
  }

  @override
  moveTo(x, y) {
    _points = [
      [x, y]
    ];
  }

  @override
  lineTo(x, y) {
    _points!.add([x, y]);
  }

  @override
  rect(x, y, w, h) {
    _points = [
      [x, y],
      [x + w, y],
      [x + w, y + h],
      [x, y + h]
    ];
  }

  @override
  closePath() {}
}
