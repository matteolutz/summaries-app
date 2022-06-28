class FutureOption<T> {

  final T? _value;
  final bool _isLoading;
  final bool _isSome;

  const FutureOption.some(this._value) : _isSome = true, _isLoading = false;
  const FutureOption.none() : _isSome = false, _value = null, _isLoading = false;
  const FutureOption.loading() : _isSome = false, _value = null, _isLoading = true;

  get isSome => _isSome;
  get isNone => !_isSome;

  get isLoading => _isLoading;

  get value => _value;

  T unwrap() {
    if (isSome) {
      return value;
    }
    throw Exception("Option is None");
  }

  bool operator ==(Object other) =>
    identical(this, other) ||
    other is FutureOption &&
      runtimeType == other.runtimeType &&
      _isSome == other._isSome &&
      _value == other._value &&
      _isLoading == other._isLoading;

  @override
  int get hashCode => _isSome.hashCode ^ _value.hashCode ^ _isLoading.hashCode;


}