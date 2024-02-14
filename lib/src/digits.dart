import 'package:d4_path/d4_path.dart';

mixin Digits {
  num? _digits = 3;

  num? get digits => _digits;
  set digits(num? digits) {
    if (digits == null) {
      _digits = null;
    } else {
      final d = digits.floorToDouble();
      if (!(d >= 0)) {
        throw ArgumentError.value(
            digits, "digits", "Not greater than or equal to zero");
      }
      _digits = d;
    }
  }
}

extension PathExtension on Digits {
  Path path() {
    return digits != null ? Path.round(digits) : Path();
  }
}
