class Option<T> {

  final T? _value;
  final bool _isSome;

  const Option.some(this._value) : _isSome = true;
  const Option.none() : _isSome = false, _value = null;

  get isSome => _isSome;
  get isNone => !_isSome;

  get value => _value;

  T unwrap() {
    if (isSome) {
      return value;
    }
    throw Exception("Option is None");
  }

  bool operator ==(Object other) =>
    identical(this, other) ||
    other is Option &&
      runtimeType == other.runtimeType &&
      _isSome == other._isSome &&
      _value == other._value;

  @override
  int get hashCode => _isSome.hashCode ^ _value.hashCode;


}