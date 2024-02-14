import 'dart:collection';

class DelegatingMap<K, V> extends MapBase<K, V> {
  final Map<K, V> _source;

  DelegatingMap(this._source);

  @override
  Iterable<K> get keys => _source.keys;

  @override
  V? operator [](Object? key) => _source[key];

  @override
  void operator []=(K key, V value) => _source[key] = value;

  @override
  V? remove(Object? key) => _source.remove(key);

  @override
  void clear() => _source.clear();
}
