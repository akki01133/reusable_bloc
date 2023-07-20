import 'package:equatable/equatable.dart';

abstract class DataState<T> extends Equatable {
  const DataState();

  @override
  List<Object?> get props => [];
}

/// Mixin for every [DataState] that represents network activity.
mixin DataFetching<T> on DataState<T> {}

/// Mixin for every [DataState] that represents an temporary error.
mixin DataError<T> on DataState<T> {}

/// Mixin for every [DataState] that represents an temporary success.
mixin DataSuccess<T> on DataState<T> {}

// ####################
// Uninitialized States
// ####################

class DataUninitialized<T> extends DataState<T> {}

class DataInitialFetching<T> extends DataState<T> with DataFetching<T> {
  const DataInitialFetching();

  @override
  List<Object?> get props => [...super.props];
}

class DataInitialFetchingError<T> extends DataState<T> with DataError<T> {
  final dynamic error;
  DataInitialFetchingError(this.error);

  @override
  List<Object?> get props => [...super.props, error];
}

// ##################
// Initialized States
// ##################

abstract class DataInitialized<T> extends DataState<T> {
  final T data;
  const DataInitialized({required this.data});

  DataInitialized.clone(DataInitialized<T> oldState)
      : this(data: oldState.data);

  @override
  List<Object?> get props => [...super.props, data];
}

class DataLoaded<T> extends DataInitialized<T> {
  DataLoaded(T data) : super(data: data);
  DataLoaded.clone(DataInitialized<T> oldState) : super.clone(oldState);
}

class DataRefetching<T> extends DataInitialized<T> with DataFetching<T> {
  DataRefetching(DataInitialized<T> oldState) : super.clone(oldState);
}

class DataRefetchingSuccess<T> extends DataInitialized<T> with DataSuccess<T> {
  DataRefetchingSuccess(T data) : super(data: data);
}

class DataRefetchingError<T> extends DataInitialized<T> with DataError<T> {
  final dynamic error;
  DataRefetchingError(DataInitialized<T> oldState, this.error)
      : super.clone(oldState);

  @override
  List<Object?> get props => [...super.props, error];
}
