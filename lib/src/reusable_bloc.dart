import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:reusable_bloc/src/reusable_event.dart';
import 'package:reusable_bloc/src/reusable_state.dart';
import 'reusable_event_handler.dart';

abstract class DataBloc<L, T> extends Bloc<DataEvent<T>, DataState<T>> {
  final DataEventHandler<L, T> _handler;

  DataBloc(DataState<T> initialState)
      : _handler = DataEventHandler<L, T>(),
        super(initialState) {
    on<FetchData<T>>(_mapFetchDataToState);
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
  Future<Either<L, T>> fetchAndParseData(
      DataState<T> oldState, FetchData event);
}
