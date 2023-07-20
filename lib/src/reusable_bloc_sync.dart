import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:reusable_bloc/src/reusable_event.dart';
import 'package:reusable_bloc/src/reusable_state.dart';
import 'reusable_event_handler.dart';

abstract class DataBlocSync<L, T> extends Bloc<DataEventSync<T>, DataState<T>> {
  final DataEventHandler<L, T> _handler;

  DataBlocSync(DataState<T> initialState)
      : _handler = DataEventHandler<L, T>(),
        super(initialState) {
    on<FetchDataSync<T>>(_mapFetchDataToStateSync);
  }

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
      DataState<T> oldState, FetchDataSync event);
}
