import 'dart:collection';

class DelegatingList<T> extends ListBase<T> {
  final List<T> _source;

  DelegatingList(this._source);

  @override
  get length => _source.length;

  @override
  set length(length) => _source.length = length;

  @override
  operator [](index) => _source[index];

  @override
  operator []=(index, value) => _source[index] = value;

  @override
  add(element) => _source.add(element);

  @override
  addAll(iterable) => _source.addAll(iterable);
}
