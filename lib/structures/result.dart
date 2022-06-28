class Result<T, E> {
  final T? _value;
  final E? _error;

  Result.success(T value)
      : _value = value,
        _error = null;

  Result.error(E error)
      : _value = null,
        _error = error;

  get value => _value;

  get error => _error;

  get isSuccess => _value != null;

  get isError => _error != null;
}
