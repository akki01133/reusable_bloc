

import 'package:bloc/bloc.dart';
import 'package:reusable_bloc/src/reusable_event.dart';
import 'package:reusable_bloc/src/reusable_state.dart';

class DataEventHandler<T> {
  const DataEventHandler();

  /// Handler for [FetchData] + [DataUninitialized] combination.
  /// Handles initial fetch when the  data is not yet present.
  ///
  /// On success it emits: [DataInitialFetching], [DataLoaded].
  /// On failure it emits: [DataInitialFetching], [DataInitialFetchingError], [DataUninitialized].
  Future<void> mapInitialFetchDataToState(
    FetchData event,
    DataUninitialized state,
    Emitter<DataState<T>> emit,
    Function(DataState<T>, FetchData) fetchAndParseData,
  ) async {
    try {
      emit(DataInitialFetching());
      final T data = await fetchAndParseData(state as DataState<T>, event);
      emit(DataLoaded(data));
    } catch (e) {
      print(e);
      emit(DataInitialFetchingError(e));
      emit(DataUninitialized());
    }
  }

  /// Handler for [FetchData] + [DataLoaded] combination.
  /// Handles refetch of the  data.
  ///
  /// On success it emits: [DataRefetching], [DataLoaded].
  /// On failure it emits: [DataRefetching], [DataRefetchingFailed], [DataLoaded].
  Future<void> mapRefetchDataToState(
    FetchData<T> event,
    DataLoaded<T> state,
    Emitter<DataState<T>> emit,
    Function(DataState<T>, FetchData<T>) fetchAndParseData,
  ) async {
    try {
      emit(DataRefetching(state));
      final T data = await fetchAndParseData(state, event);
      emit(DataRefetchingSuccess(data));
      emit(DataLoaded(data));
    } catch (e) {
      print(e);
      emit(DataRefetchingError(state, e));
      emit(DataLoaded.clone(state));
    }
  }
}