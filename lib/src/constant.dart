T Function([Object?, Object?, Object?, Object?]) constant<T>(T x) {
  return ([Object? a, Object? b, Object? c, Object? d]) {
    return x;
  };
}

final constantNaN = constant(double.nan);
