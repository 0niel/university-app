import 'package:flutter/widgets.dart';
import 'package:rxdart/rxdart.dart';

/// Immutable representation of the most recent interaction with a data fetching
/// computation.
///
/// See also:
///  * [ResultBuilder], which builds itself based on a snapshot from interacting with a [Stream] of `Result`s.
@immutable
class Result<T> {
  /// Creates a new Result.
  ///
  /// See also:
  ///   * [Result.loading], for a Result in the loading state.
  ///   * [Result.success], for a Result in the success state.
  ///   * [Result.error], for a Result in the error state.
  Result(
    this.data,
    this.error, {
    required this.isLoading,
    required this.isCached,
  }) : assert(
          T != Never,
          'Result() called without specifying the data type. Call Result<T>() instead',
        );

  /// Creates a new Result in the loading state.
  ///
  /// See also:
  ///   * [Result], for a basic Result.
  ///   * [Result.success], for a Result in the success state.
  ///   * [Result.error], for a Result in the error state.
  Result.loading()
      : data = null,
        error = null,
        isLoading = true,
        isCached = false,
        assert(
          T != Never,
          'Result.loading() called without specifying the data type. Call Result<T>.loading() instead',
        );

  /// Creates a new Result in the success state.
  ///
  /// See also:
  ///   * [Result], for a basic Result.
  ///   * [Result.loading], for a Result in the loading state.
  ///   * [Result.error], for a Result in the error state.
  Result.success(this.data)
      : error = null,
        isLoading = false,
        isCached = false,
        assert(
          T != Never,
          'Result.success() called without specifying the data type. Call Result<T>.success() instead',
        );

  /// Creates a new Result in the error state.
  ///
  /// See also:
  ///   * [Result], for a basic Result.
  ///   * [Result.loading], for a Result in the loading state.
  ///   * [Result.success], for a Result in the success state.
  Result.error(this.error)
      : data = null,
        isLoading = false,
        isCached = false,
        assert(
          T != Never,
          'Result.error() called without specifying the data type. Call Result<T>.error() instead',
        );

  /// The latest data received by the data fetching computation.
  ///
  /// If this is non-null, [hasData] will be `true`.
  ///
  /// If the data fetching computation has never returned a value, this may be
  /// set to an initial data value.
  /// See [ResultBuilder.initialData].
  final T? data;

  /// The latest error object received by the data fetching computation.
  ///
  /// A result may both have an error and data.
  final Object? error;

  /// Whether new [data] is being fetched right now.
  ///
  /// A loading result may have cached data.
  final bool isLoading;

  /// Whether the [data] was fetched from cache.
  ///
  /// A cached result may be in the loading state.
  final bool isCached;

  /// Transforms the subtype of the Result by applying [callback].
  ///
  /// If the result has no data `callback` will not be called.
  Result<R> transform<R>(R? Function(T data) callback) => Result(
        hasData ? callback(data as T) : null,
        error,
        isLoading: isLoading,
        isCached: isCached,
      );

  /// Copies this Result in a loading state.
  Result<T> asLoading() => copyWith(isLoading: true);

  /// Copies this Result and optionally replaces the [data], [error], [isLoading] and [isCached].
  Result<T> copyWith({
    T? data,
    Object? error,
    bool? isLoading,
    bool? isCached,
  }) =>
      Result(
        data ?? this.data,
        error ?? this.error,
        isLoading: isLoading ?? this.isLoading,
        isCached: isCached ?? this.isCached,
      );

  /// Returns whether this snapshot contains a non-null [error] value.
  ///
  /// A result may both have an error and data.
  bool get hasError => error != null;

  /// Returns whether this snapshot contains a non-null [data] value.
  ///
  /// This can be false even when the asynchronous computation has completed
  /// successfully, if the computation did not return a non-null value. For
  /// example, a [Future<void>] will complete with the null value even if it
  /// completes successfully.
  /// A result may both have an error and data.
  bool get hasData => data != null;

  /// Returns whether this snapshot is equal to a [Result.success].
  ///
  /// A successful result has data, has no error and is neither loading nor cached.
  bool get hasSuccessfulData => hasData && !isCached && !isLoading && !hasError;

  /// Returns the latest data received, failing if there is no data.
  ///
  /// Throws a [StateError], if no data is present.
  T get requireData {
    if (hasData) {
      return data!;
    }

    throw StateError('Result has no data');
  }

  @override
  bool operator ==(Object other) =>
      other is Result &&
      other.isLoading == isLoading &&
      other.data == data &&
      other.error?.toString() == error?.toString();

  @override
  int get hashCode => Object.hash(data, error?.toString(), isLoading, isCached);

  @override
  String toString() => 'Result($data, $error, isLoading: $isLoading, isCached: $isCached)';
}

/// Signature for strategies that build widgets based on asynchronous [Result]s.
///
/// See also:
///  * [ResultBuilder], which delegates to an [ResultWidgetBuilder] to build
///    itself based on [Result] events from a [Stream].
typedef ResultWidgetBuilder<T> = Widget Function(BuildContext context, Result<T> snapshot);

/// Widget that builds itself based on the latest snapshot of interaction with
/// a [Stream<Result>].
///
/// Widget rebuilding is scheduled by each interaction, using [State.setState],
/// but is otherwise decoupled from the timing of the stream. The [builder]
/// is called at the discretion of the Flutter pipeline, and will thus receive a
/// timing-dependent sub-sequence of the snapshots that represent the
/// interaction with the stream.
///
/// The initial snapshot data can be controlled by specifying [initialData].
/// This should be used to ensure that the first frame has the expected value,
/// as the builder will always be called before the stream listener has a chance
/// to be processed.
class ResultBuilder<T> extends StreamBuilderBase<Result<T>, Result<T>> {
  /// Creates a new result stream builder.
  ///
  /// See also:
  ///   * [ResultBuilder.behaviorSubject] for automatically setting the initial
  ///     data from a [BehaviorSubject].
  const ResultBuilder({
    required this.builder,
    this.initialData,
    super.stream,
    super.key,
  });

  /// Creates a new result stream builder for a [BehaviorSubject].
  ///
  /// The [initialData] will be set to the current value of the subject.
  ResultBuilder.behaviorSubject({
    required this.builder,
    BehaviorSubject<Result<T>>? subject,
    super.key,
  })  : initialData = subject?.valueOrNull,
        super(stream: subject);

  /// Builder function called with the current [Result] value.
  ///
  /// This builder must only return a widget and should not have any side
  /// effects as it may be called multiple times.
  final ResultWidgetBuilder<T> builder;

  /// The data that will be used to create the initial result.
  ///
  /// Providing this value (presumably obtained synchronously when the [Stream]
  /// was created) ensures that the first frame will show useful data.
  /// Otherwise, the first frame will be built with the value null, regardless
  /// of whether a value is available on the stream: since streams are
  /// asynchronous, no events from the stream can be obtained before the initial
  /// build.
  final Result<T>? initialData;

  @override
  Result<T> initial() => initialData?.asLoading() ?? Result<T>.loading();

  @override
  Result<T> afterData(Result<T> current, Result<T> data) {
    // prevent rebuild when only the cache state changes
    if (current == data) {
      return current;
    }

    return data;
  }

  @override
  Result<T> afterError(Result<T> current, Object error, StackTrace stackTrace) {
    if (current.hasError) {
      return current;
    }

    return Result(
      current.data,
      error,
      isLoading: false,
      isCached: false,
    );
  }

  @override
  Widget build(BuildContext context, Result<T> currentSummary) => builder(context, currentSummary);
}
