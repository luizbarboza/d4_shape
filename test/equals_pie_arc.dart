import 'package:test/test.dart';

class EqualsPieArc<T> extends CustomMatcher {
  EqualsPieArc(Map arc, T data)
      : super("Pie arc which when represented as [arc, arc.data] is equal to",
            "a representation", equals([arc, data]));

  @override
  Object? featureValueOf(actual) {
    return [actual, actual.data];
  }
}
