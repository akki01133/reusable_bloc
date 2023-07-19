import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:reusable_bloc/reusable_bloc.dart';
import 'reusable_event_handler.dart';

abstract class DataBloc<T> extends Bloc<DataEvent<T>, DataState<T>> {
  final DataEventHandler<T> _handler;

  DataBloc(DataState<T> initialState)
      : _handler = DataEventHandler<T>(),
        super(initialState) {
    on<FetchData<T>>(_mapFetchDataToState);
    on<FetchDataSync<T>>(_mapFetchDataToStateSync);
  }

  /// Propagates the [FetchData] event down to the corresponding event handler.
  Future<void> _mapFetchDataToState(
    FetchData<T> event,
    Emitter<DataState<T>> emit,
  ) async {
    return _handleStatesOnEvent(
      isNoOp:
          state is DataFetching || state is DataError || state is DataSuccess,
      onDataUninitialized: () => _handler.mapInitialFetchDataToState(
        event,
        state as DataUninitialized,
        emit,
        fetchAndParseData,
      ),
      onDataLoaded: () => _handler.mapRefetchDataToState(
        event,
        state as DataLoaded<T>,
        emit,
        fetchAndParseData,
      ),
    );
  }

  /// Helper function that can be used by [_mapFetchDataToState] function
  /// for cleaner propagation of the events to the corresponding event handler.
  Future<void> _handleStatesOnEvent({
    required bool isNoOp,
    Function()? onDataUninitialized,
    Function()? onDataLoaded,
  }) async {
    if (isNoOp) {
      return;
    } else if (state is DataUninitialized && onDataUninitialized != null) {
      return onDataUninitialized();
    } else if (state is DataLoaded && onDataLoaded != null) {
      return onDataLoaded();
    } else {
      throw UnimplementedError(
          'No handler implemented for combination: ${state.runtimeType}.');
    }
  }

  /// Function which retrieves the blocs data from the backend,
  /// parses the response and returns the parsed [Data] Object.
  /// The [oldState] and thus the old [Data] object is also accesible,
  /// if merging of the new and old data is required.
  Future<Either<Failure, T>> fetchAndParseData<Failure>(
      DataState<T> oldState, FetchData event) => throw UnimplementedError(
      'Async fetching not implemented');

  FutureOr<void> _mapFetchDataToStateSync(
      FetchDataSync<T> event, Emitter<DataState<T>> emit) {
    return _handleStatesOnEvent(
      isNoOp:
          state is DataFetching || state is DataError || state is DataSuccess,
      onDataUninitialized: () => _handler.mapInitialFetchDataToStateSync(
          event, state as DataUninitialized, emit, fetchAndParseDataSync),
      onDataLoaded: () => _handler.mapRefetchDataToStateSync(
          event, state as DataLoaded<T>, emit, fetchAndParseDataSync),
    );
  }

  Either<Failure, T> fetchAndParseDataSync<Failure>(
          DataState<T> oldState, FetchDataSync event) =>
      throw UnimplementedError('Sync fetching not implemented');
}
