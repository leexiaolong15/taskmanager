sealed class Result<S, E extends Exception> {
  const Result();
}

/// Represents a successful result, containing a value of type S.
class Ok<S, E extends Exception> extends Result<S, E> {
  final S value;
  const Ok(this.value);
}

/// Represents an error result, containing an Exception of type E.
class Err<S, E extends Exception> extends Result<S, E> {
  final E error;
  const Err(this.error);
}